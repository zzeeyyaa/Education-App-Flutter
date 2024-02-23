import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/domain/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

class SignUp extends FutureUsecaseWithParams<void, SignUpParams> {
  const SignUp(this._repo);
  final AuthRepo _repo;

  @override
  ResultFuture<void> call(SignUpParams params) {
    return _repo.signUp(
      email: params.email,
      fullName: params.fullName,
      password: params.password,
    );
  }
}

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.email,
    required this.fullName,
    required this.password,
  });

  const SignUpParams.empty()
      : this(
          email: '',
          fullName: '',
          password: '',
        );

  final String email;
  final String fullName;
  final String password;

  @override
  List<Object?> get props => [email, fullName, password];
}
