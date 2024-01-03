import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/auth/domain/repos/auth_repo.dart';
import 'package:education_app/src/auth/domain/usecases/forgot_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late ForgotPassword usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = ForgotPassword(repo);
  });

  test('Should call [AuthRepo.forgetPassword] and return [void]', () async {
    when(
      () => repo.forgotPassword(any()),
    ).thenAnswer((_) async => const Right(null));

    final result = await usecase('');

    expect(result, equals(const Right<Failure, void>(null)));

    verify(
      () => repo.forgotPassword(''),
    ).called(1);

    verifyNoMoreInteractions(repo);
  });
}
