import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:formz/formz.dart';

import 'register_event.dart';
import 'register_state.dart';
import '../models/email_input.dart';
import '../models/password_input.dart';
import '../models/display_name_input.dart';
import '../../domain/use_cases/register_use_case.dart';

@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterBloc(this._registerUseCase) : super(const RegisterState()) {
    on<RegisterDisplayNameChanged>(_onDisplayNameChanged);
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterSubmitted>(_onSubmitted);
  }

  void _onDisplayNameChanged(
    RegisterDisplayNameChanged event,
    Emitter<RegisterState> emit,
  ) {
    final displayName = DisplayNameInput.dirty(event.displayName);
    emit(
      state.copyWith(
        displayName: displayName,
        formStatus: Formz.validate([displayName, state.email, state.password])
            ? FormzSubmissionStatus.success
            : FormzSubmissionStatus.initial,
      ),
    );
  }

  void _onEmailChanged(
    RegisterEmailChanged event,
    Emitter<RegisterState> emit,
  ) {
    final email = EmailInput.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        formStatus: Formz.validate([state.displayName, email, state.password])
            ? FormzSubmissionStatus.success
            : FormzSubmissionStatus.initial,
      ),
    );
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final password = PasswordInput.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        formStatus: Formz.validate([state.displayName, state.email, password])
            ? FormzSubmissionStatus.success
            : FormzSubmissionStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (state.formStatus != FormzSubmissionStatus.success &&
        Formz.validate([state.displayName, state.email, state.password])) {
      return;
    }

    emit(state.copyWith(status: RegisterStatus.loading));

    final result = await _registerUseCase(
      RegisterParams(
        email: state.email.value,
        password: state.password.value,
        displayName: state.displayName.value,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: RegisterStatus.success)),
    );
  }
}
