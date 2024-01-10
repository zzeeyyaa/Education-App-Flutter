import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';
import 'package:education_app/src/auth/domain/usecases/forgot_password.dart';
import 'package:education_app/src/auth/domain/usecases/sign_in.dart';
import 'package:education_app/src/auth/domain/usecases/sign_up.dart';
import 'package:education_app/src/auth/domain/usecases/update_user.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required ForgotPassword forgotPassword,
    required SignIn signIn,
    required SignUp signUp,
    required UpdateUser updateUser,
  })  : _forgotPassword = forgotPassword,
        _signIn = signIn,
        _signUp = signUp,
        _updateUser = updateUser,
        super(const AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(const AuthLoading());
    });
    on<ForgotPasswordEvent>(_forgotPasswordHandler);
    on<SignInEvent>(_signInHandler);
    on<SignUpEvent>(_signUpHandler);
    on<UpdateUserEvent>(_updateUserHandler);
    // on<SignUpEvent>(_signUpHandler);
  }

  final ForgotPassword _forgotPassword;
  final SignIn _signIn;
  final SignUp _signUp;
  final UpdateUser _updateUser;

  Future<void> _forgotPasswordHandler(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _forgotPassword(event.email);

    result.fold(
      (failure) => emit(AuthError(failure.errorMeesage)),
      (_) => emit(const ForgotPasswordSent()),
    );
  }

  Future<void> _signInHandler(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signIn(
      SignInParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthError(failure.errorMeesage)),
      (user) => emit(SignedIn(user)),
    );
  }

  Future<void> _signUpHandler(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signUp(
      SignUpParams(
        email: event.email,
        fullName: event.fullName,
        password: event.password,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.errorMeesage)),
      (_) => emit(const SignedUp()),
    );
  }

  Future<void> _updateUserHandler(
    UpdateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _updateUser(
      UpdateUserParams(
        action: event.action,
        userData: event.userData,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.errorMeesage)),
      (_) => emit(const UserUpdated()),
    );
  }
}
