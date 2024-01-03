import 'package:dartz/dartz.dart';
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/auth/domain/repos/auth_repo.dart';
import 'package:education_app/src/auth/domain/usecases/update_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late UpdateUser usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = UpdateUser(repo);
    registerFallbackValue(UpdateUserAction.email);
  });

  const tUpdateUser = UpdateUserParams.empyt();

  test('should call [AuthRepo.UpdateUser] and return [void]', () async {
    when(
      () => repo.updateUser(
        action: any(named: 'action'),
        userData: any<dynamic>(named: 'userData'),
      ),
    ).thenAnswer((_) async => const Right(null));

    final result = await usecase(tUpdateUser);

    expect(result, equals(const Right<Failure, void>(null)));

    verify(
      () => repo.updateUser(
        action: tUpdateUser.action,
        userData: tUpdateUser.userData,
      ),
    ).called(1);

    verifyNoMoreInteractions(repo);
  });
}
