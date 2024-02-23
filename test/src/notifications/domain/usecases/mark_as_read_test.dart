import 'package:dartz/dartz.dart';
import 'package:education_app/src/notifications/domain/entities/notification.dart';
import 'package:education_app/src/notifications/domain/repos/notification_repo.dart';
import 'package:education_app/src/notifications/domain/usecases/mark_as_read.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'notification_repo.mock.dart';

void main() {
  late MarkAsRead usecase;
  late NotificationRepo repo;

  setUp(() {
    repo = MockNotificationRepo();
    usecase = MarkAsRead(repo);
  });

  final tNotification = Notification.empty();

  test('should return void when success', () async {
    when(() => repo.markAsRead(any()))
        .thenAnswer((_) async => const Right(null));

    final result = await usecase(tNotification.id);

    expect(result, isA<Right<dynamic, void>>());

    verify(() => repo.markAsRead(tNotification.id)).called(1);

    verifyNoMoreInteractions(repo);
  });
}
