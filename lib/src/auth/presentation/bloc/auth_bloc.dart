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
        super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  final ForgotPassword _forgotPassword;
  final SignIn _signIn;
  final SignUp _signUp;
  final UpdateUser _updateUser;
}
