import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';

abstract class AuthRepo {
  const AuthRepo();

  ResultVoid forgotPassword(String email);

  ResultFuture<LocalUser> signIn({
    required String email,
    required String password,
  });

  ResultVoid signUp({
    required String email,
    required String fullName,
    required String password,
  });

  ResultVoid updateUser({
    //what action user trying to be updated
    required UpdateUserAction action,
    dynamic userData,
  });
}
