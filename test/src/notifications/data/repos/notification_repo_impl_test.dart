import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:education_app/src/notifications/data/models/notification_model.dart';
import 'package:education_app/src/notifications/data/repos/notification_repo_impl.dart';
import 'package:education_app/src/notifications/domain/entities/notification.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationRemoteDatasource extends Mock
    implements NotificationRemoteDatasource {}

void main() {
  late NotificationRemoteDatasource remoteDatasource;
  late NotificationRepoImpl repoImpl;

  setUp(() {
    remoteDatasource = MockNotificationRemoteDatasource();
    repoImpl = NotificationRepoImpl(remoteDatasource);
  });

  final tNotification = NotificationModel.empty();
  const tException =
      ServerException(message: 'message', statusCode: 'statusCode');

  group('clear', () {
    test('should return [ServerFailure] when call to remotedatasource failed',
        () async {
      when(() => remoteDatasource.clear(any()))
          .thenAnswer((_) async => const Right<dynamic, void>(null));

      final result = await repoImpl.clear(tNotification.id);

      expect(result, equals(const Right<dynamic, void>(null)));

      verify(() => remoteDatasource.clear(tNotification.id)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
    test('should return [ServerFailure] when call remoteDatasource is failed',
        () async {
      when(() => remoteDatasource.clear(any())).thenThrow(tException);

      final result = await repoImpl.clear(tNotification.id);

      expect(
        result,
        equals(
          Left<Failure, dynamic>(
            ServerFailure.fromException(tException),
          ),
        ),
      );

      verify(() => remoteDatasource.clear(tNotification.id)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });

  group('clearAll', () {
    test('should complete successfully when call remotedatasource is success',
        () async {
      when(() => remoteDatasource.clearAll())
          .thenAnswer((_) async => const Right<dynamic, void>(null));

      final result = await repoImpl.clearAll();

      expect(result, equals(const Right<dynamic, void>(null)));

      verify(() => remoteDatasource.clearAll()).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
    test(
        'should return [ServerFailure] when call to remotedatasource is failed',
        () async {
      when(() => remoteDatasource.clearAll()).thenThrow(tException);

      final result = await repoImpl.clearAll();

      expect(
        result,
        equals(
          Left<Failure, dynamic>(
            ServerFailure.fromException(tException),
          ),
        ),
      );

      verify(() => remoteDatasource.clearAll()).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });

  group('markAsRead', () {
    test(
        'should compelte successfully when '
        'call to remtoedatasource is successs', () async {
      when(() => remoteDatasource.markAsRead(any()))
          .thenAnswer((_) async => const Right<dynamic, void>(null));

      final result = await repoImpl.markAsRead(tNotification.id);

      expect(result, equals(const Right<dynamic, void>(null)));

      verify(() => remoteDatasource.markAsRead(tNotification.id)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
    test(
        'should return [ServerFailure] when call to remotedatasource is failed',
        () async {
      when(() => remoteDatasource.markAsRead(any())).thenThrow(tException);

      final result = await repoImpl.markAsRead('id');

      expect(
        result,
        equals(
          Left<Failure, dynamic>(
            ServerFailure.fromException(tException),
          ),
        ),
      );

      verify(() => remoteDatasource.markAsRead('id')).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });

  group('sendNotification', () {
    setUp(() => registerFallbackValue(tNotification));

    test('should complete successfully when call remtoedatasource success',
        () async {
      when(() => remoteDatasource.sendNotification(any()))
          .thenAnswer((_) async => const Right<dynamic, void>(null));

      final result = await repoImpl.sendNotification(tNotification);

      expect(result, equals(const Right<dynamic, void>(null)));

      verify(() => remoteDatasource.sendNotification(tNotification)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });

    test(
        'should return [ServerFailure] when call to remtoedatasource is failed',
        () async {
      when(() => remoteDatasource.sendNotification(any()))
          .thenThrow(tException);

      final result = await repoImpl.sendNotification(tNotification);

      expect(
        result,
        equals(
          Left<Failure, dynamic>(
            ServerFailure.fromException(tException),
          ),
        ),
      );

      verify(() => remoteDatasource.sendNotification(tNotification)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });

  group('getNotifications', () {
    test(
        'should emit [List<Notification>] when '
        'call remotedatasource is success', () async {
      final notifications = [NotificationModel.empty()];
      when(() => remoteDatasource.getNotifications())
          .thenAnswer((_) => Stream.value(notifications));

      final result = repoImpl.getNotifications();

      expect(
        result,
        emits(Right<dynamic, List<Notification>>(notifications)),
      );

      verify(() => remoteDatasource.getNotifications()).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
    test('should return [ServerFailure] when call remotedatasource is failed',
        () async {
      when(() => remoteDatasource.getNotifications())
          .thenAnswer((_) => Stream.error(tException));

      final result = repoImpl.getNotifications();

      expect(
        result,
        emits(
          Left<ServerFailure, dynamic>(
            ServerFailure.fromException(tException),
          ),
        ),
      );

      verify(() => remoteDatasource.getNotifications()).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });
}
