import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

/// Like `droppable()`, drops new events while an earlier event is running,
/// but completes any [Completer] attached to a dropped event so callers
/// (e.g. `RefreshIndicator`) never hang waiting for a dropped refresh.
EventTransformer<E> droppableCompleter<E>(
  Completer<void>? Function(E event) getCompleter,
) {
  return (events, mapper) {
    late final StreamController<E> controller;
    var isRunning = false;
    var inputDone = false;
    StreamSubscription<E>? inputSub;
    StreamSubscription<E>? activeSub;

    void maybeClose() {
      if (inputDone && !isRunning && !controller.isClosed) {
        controller.close();
      }
    }

    controller = StreamController<E>(
      onListen: () {
        inputSub = events.listen(
          (event) {
            if (isRunning) {
              final completer = getCompleter(event);
              if (completer != null && !completer.isCompleted) {
                completer.complete();
              }
              return;
            }
            isRunning = true;
            activeSub = mapper(event).listen(
              controller.add,
              onError: controller.addError,
              onDone: () {
                isRunning = false;
                activeSub = null;
                maybeClose();
              },
            );
          },
          onError: controller.addError,
          onDone: () {
            inputDone = true;
            maybeClose();
          },
        );
      },
      onCancel: () async {
        await activeSub?.cancel();
        await inputSub?.cancel();
      },
    );

    return controller.stream;
  };
}
