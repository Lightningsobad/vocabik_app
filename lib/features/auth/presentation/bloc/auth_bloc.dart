import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../domain/entities/user.dart';
import '../../domain/models/email_input.dart';
import '../../domain/models/password_input.dart';
import '../../domain/use_cases/get_me_use_case.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/sign_out_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetMeUseCase _getMeUseCase;

  AuthBloc(
    this._loginUseCase,
    this._signOutUseCase,
    this._getMeUseCase,
  ) : super(const AuthState()) {
    on<EmailChanged>(
      _onEmailChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<PasswordChanged>(
      _onPasswordChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(
      _onLogoutRequested,
      transformer: droppable(),
    );
    on<GetMeRequested>(
      _onGetMeRequested,
      transformer: droppable(),
    );
  }

  void _onEmailChanged(
    EmailChanged event,
    Emitter<AuthState> emit,
  ) {
    final email = EmailInput.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
      ),
    );
  }

  void _onPasswordChanged(
    PasswordChanged event,
    Emitter<AuthState> emit,
  ) {
    final password = PasswordInput.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
      ),
    );
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final email = EmailInput.dirty(state.email.value);
    final password = PasswordInput.dirty(state.password.value);

    emit(state.copyWith(
      email: email,
      password: password,
      status: AuthStatus.loading,
    ));

    if (Formz.validate([email, password])) {
      final result = await _loginUseCase(
        email: email.value,
        password: password.value,
      );

      result.fold(
        (failure) => emit(state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure.message,
        )),
        (user) => emit(state.copyWith(
          status: AuthStatus.success,
          user: user,
        )),
      );
    } else {
      emit(state.copyWith(
        status: AuthStatus.initial, // Reset loading state if invalid
      ));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _signOutUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(const AuthState(status: AuthStatus.unauthenticated)),
    );
  }

  Future<void> _onGetMeRequested(
    GetMeRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _getMeUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        status: AuthStatus.success,
        user: user,
      )),
    );
  }
}
