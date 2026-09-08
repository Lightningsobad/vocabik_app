import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/data_sources/auth_local_data_source.dart';
import '../../data/models/user_model.dart';
import '../../domain/entities/user.dart';
import '../../domain/use_cases/get_me_use_case.dart';
import '../../domain/use_cases/sign_out_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignOutUseCase _signOutUseCase;
  final GetMeUseCase _getMeUseCase;
  final AuthLocalDataSource _authLocalDataSource;

  AuthBloc(
    this._signOutUseCase,
    this._getMeUseCase,
    this._authLocalDataSource,
  ) : super(_getInitialState(_authLocalDataSource)) {
    on<AuthCheckRequested>(
      _onAuthCheckRequested,
      transformer: droppable(),
    );
    on<LogoutRequested>(
      _onLogoutRequested,
      transformer: droppable(),
    );
    on<SessionExpired>(
      _onSessionExpired,
      transformer: droppable(),
    );
    on<GetMeRequested>(
      _onGetMeRequested,
      transformer: droppable(),
    );
    on<UserAuthenticated>(_onUserAuthenticated);
    on<UserProfileUpdated>(_onUserProfileUpdated);
  }

  static AuthState _getInitialState(AuthLocalDataSource localDataSource) {
    final token = localDataSource.getAccessToken();
    final cachedUser = localDataSource.getUser();
    if (token != null && token.isNotEmpty) {
      if (cachedUser != null) {
        return AuthState(status: AuthStatus.success, user: cachedUser);
      }
      return const AuthState(status: AuthStatus.loading);
    }
    return const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final token = _authLocalDataSource.getAccessToken();
    if (token == null || token.isEmpty) {
      emit(const AuthState(status: AuthStatus.unauthenticated));
      return;
    }
    final cachedUser = _authLocalDataSource.getUser();
    if (cachedUser != null) {
      emit(state.copyWith(status: AuthStatus.success, user: cachedUser));
    }
    add(const GetMeRequested());
  }

  Future<void> _onSessionExpired(
    SessionExpired event,
    Emitter<AuthState> emit,
  ) async {
    await _authLocalDataSource.clear();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  void _onUserAuthenticated(
    UserAuthenticated event,
    Emitter<AuthState> emit,
  ) {
    _authLocalDataSource.saveUser(UserModel.fromEntity(event.user));
    emit(state.copyWith(
      status: AuthStatus.success,
      user: event.user,
    ));
  }

  void _onUserProfileUpdated(
    UserProfileUpdated event,
    Emitter<AuthState> emit,
  ) {
    _authLocalDataSource.saveUser(UserModel.fromEntity(event.user));
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
    final cachedUser = state.user ?? _authLocalDataSource.getUser();
    if (cachedUser != null) {
      emit(state.copyWith(
        status: AuthStatus.success,
        user: cachedUser,
      ));
    } else {
      emit(state.copyWith(status: AuthStatus.loading));
    }
    final result = await _getMeUseCase();
    result.fold(
      (failure) {
        if (state.user != null) {
          emit(state.copyWith(
            status: AuthStatus.success,
            errorMessage: failure.message,
          ));
        } else {
          emit(state.copyWith(
            status: AuthStatus.failure,
            errorMessage: failure.message,
          ));
        }
      },
      (user) {
        _authLocalDataSource.saveUser(UserModel.fromEntity(user));
        emit(state.copyWith(
          status: AuthStatus.success,
          user: user,
        ));
      },
    );
  }
}
