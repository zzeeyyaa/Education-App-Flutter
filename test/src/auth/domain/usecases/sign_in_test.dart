import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';
import 'package:education_app/src/auth/domain/repos/auth_repo.dart';
import 'package:education_app/src/auth/domain/usecases/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late SignIn usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = SignIn(repo);
  });

  const tLocalUser = LocalUser.empty();
  const tSignInParams = SignInParams.empty();

  test('should call [AuthRepo.SignIn] and return [LocalUser]', () async {
    when(
      () => repo.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Right(tLocalUser));

    final result = await usecase(tSignInParams);

    expect(result, equals(const Right<Failure, LocalUser>(tLocalUser)));

    verify(
      () => repo.signIn(
        email: tSignInParams.email,
        password: tSignInParams.password,
      ),
    ).called(1);

    verifyNoMoreInteractions(repo);
  });
}
