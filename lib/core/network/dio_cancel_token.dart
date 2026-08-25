import 'package:dio/dio.dart';
import 'package:vocabik_app/core/network/app_cancel_token.dart';

class DioCancelToken implements AppCancelToken {
  final CancelToken token;

  DioCancelToken([CancelToken? token]) : token = token ?? CancelToken();

  @override
  void cancel([dynamic reason]) {
    token.cancel(reason);
  }

  @override
  bool get isCancelled => token.isCancelled;
}

extension AppCancelTokenX on AppCancelToken? {
  CancelToken? toDio() {
    final self = this;
    if (self is DioCancelToken) {
      return self.token;
    }
    return null;
  }
}
