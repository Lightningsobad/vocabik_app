import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/user.dart';
import '../../domain/use_cases/get_me_use_case.dart';
import '../../domain/use_cases/sign_out_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignOutUseCase _signOutUseCase;
  final GetMeUseCase _getMeUseCase;

  AuthBloc(
    this._signOutUseCase,
    this._getMeUseCase,
  ) : super(const AuthState()) {
    on<LogoutRequested>(
      _onLogoutRequested,
      transformer: droppable(),
    );
    on<GetMeRequested>(
      _onGetMeRequested,
      transformer: droppable(),
    );
    on<UserAuthenticated>(_onUserAuthenticated);
    on<UserProfileUpdated>(_onUserProfileUpdated);
  }

  void _onUserAuthenticated(
    UserAuthenticated event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      status: AuthStatus.success,
      user: event.user,
    ));
  }

  void _onUserProfileUpdated(
    UserProfileUpdated event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      user: event.user,
    ));
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
