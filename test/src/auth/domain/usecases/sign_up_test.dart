import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/auth/domain/repos/auth_repo.dart';
import 'package:education_app/src/auth/domain/usecases/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late SignUp usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = SignUp(repo);
  });

  const tSignUp = SignUpParams.empty();

  test('should call [AuthRepo.SignUp] and return [void]', () async {
    when(
      () => repo.signUp(
        email: any(named: 'email'),
        fullName: any(named: 'fullName'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Right(null));

    final result = await usecase(tSignUp);

    expect(result, equals(const Right<Failure, void>(null)));

    verify(
      () => repo.signUp(
        email: tSignUp.email,
        fullName: tSignUp.fullName,
        password: tSignUp.password,
      ),
    ).called(1);

    verifyNoMoreInteractions(repo);
  });
}
