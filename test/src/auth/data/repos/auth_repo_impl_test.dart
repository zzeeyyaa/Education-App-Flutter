import 'package:dartz/dartz.dart';
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/auth/data/datasources/auth_remote_datasource.dart';
import 'package:education_app/src/auth/data/models/user_model.dart';
import 'package:education_app/src/auth/data/repos/auth_repo_impl.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRemoteDataSource remoteDataSource;
  late AuthRepoImpl repoImpl;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repoImpl = AuthRepoImpl(remoteDataSource);
    registerFallbackValue(UpdateUserAction.password);
  });

  const tException = ServerException(
    message: 'User does not exist',
    statusCode: '404',
  );

  const tPassword = 'Test password';
  const tFullName = 'Test full name';
  const tEmail = 'Test email';
  const tUpdateAction = UpdateUserAction.password;
  const tUserData = 'New password';

  const tUser = LocalUserModel.empty();

  group('forgotPassword', () {
    test('should call [RemoteDataSource.forgotPassword] and success', () async {
      when(
        () => remoteDataSource.forgotPassword(''),
      ).thenAnswer((invocation) async => Future.value());

      final result = await repoImpl.forgotPassword('');

      expect(result, const Right<dynamic, void>(null));

      verify(
        () => remoteDataSource.forgotPassword(''),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });
    test(
        'should call [ServerFailure] when call '
        '[RemoteDataSource.forgorPassword] unsuccess', () async {
      when(
        () => remoteDataSource.forgotPassword(''),
      ).thenThrow(tException);

      final result = await repoImpl.forgotPassword('');

      expect(
        result,
        equals(
          Left<ServerFailure, dynamic>(
            ServerFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );

      verify(
        () => remoteDataSource.forgotPassword(''),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('signIn', () {
    test(
        'should call [RemoteDataSource.signIn], when '
        'success return [LocalUser]', () async {
      when(
        () => remoteDataSource.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => tUser);

      final result = await repoImpl.signIn(
        email: tEmail,
        password: tPassword,
      );

      expect(result, equals(const Right<dynamic, LocalUser>(tUser)));

      verify(
        () => remoteDataSource.signIn(email: tEmail, password: tPassword),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });
    test(
        'should return [ServerFailure] when call RemoteDataSource.signIn'
        ' is unsuccessfull', () async {
      when(
        () => remoteDataSource.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(tException);

      final result = await repoImpl.signIn(
        email: tEmail,
        password: tPassword,
      );

      expect(
        result,
        equals(
          Left<ServerFailure, dynamic>(
            ServerFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );

      verify(
        () => remoteDataSource.signIn(email: tEmail, password: tPassword),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('signUp', () {
    test('should call [RemoteDataSource.signUp] return void when success',
        () async {
      when(
        () => remoteDataSource.signUp(
          email: tEmail,
          fullName: tFullName,
          password: tPassword,
        ),
      ).thenAnswer(
        (_) async => Future.value(),
      );

      final result = await repoImpl.signUp(
        email: tEmail,
        fullName: tFullName,
        password: tPassword,
      );

      expect(result, equals(const Right<dynamic, void>(null)));

      verify(
        () => remoteDataSource.signUp(
          email: tEmail,
          fullName: tFullName,
          password: tPassword,
        ),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
      'should return [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(
          () => remoteDataSource.signUp(
            email: any(named: 'email'),
            fullName: any(named: 'fullName'),
            password: any(named: 'password'),
          ),
        ).thenThrow(tException);

        final result = await repoImpl.signUp(
          email: tEmail,
          fullName: tFullName,
          password: tPassword,
        );

        expect(
          result,
          equals(
            Left<dynamic, void>(
              ServerFailure(
                message: tException.message,
                statusCode: tException.statusCode,
              ),
            ),
          ),
        );

        verify(
          () => remoteDataSource.signUp(
            email: tEmail,
            fullName: tFullName,
            password: tPassword,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('updateUser', () {
    test(
        'should call [RemoteDataSoure.updateUser] return void'
        ' when success', () async {
      when(
        () => remoteDataSource.updateUser(
          action: any(named: 'action'),
          userData: any<dynamic>(
            named: 'userData',
          ),
        ),
      ).thenAnswer((_) => Future.value());

      final result = await repoImpl.updateUser(
        action: tUpdateAction,
        userData: tUserData,
      );

      expect(result, equals(const Right<dynamic, void>(null)));

      verify(
        () => remoteDataSource.updateUser(
          action: tUpdateAction,
          userData: tUserData,
        ),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should return [ServerFailure] when call remote data source'
        ' is unsuccessfull', () async {
      when(
        () => remoteDataSource.updateUser(
          action: any(named: 'action'),
          userData: any<dynamic>(named: 'userData'),
        ),
      ).thenThrow(tException);

      final result = await repoImpl.updateUser(
        action: tUpdateAction,
        userData: tUserData,
      );

      expect(
        result,
        equals(
          Left<dynamic, void>(
            ServerFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );

      verify(
        () => remoteDataSource.updateUser(
          action: tUpdateAction,
          userData: tUserData,
        ),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
