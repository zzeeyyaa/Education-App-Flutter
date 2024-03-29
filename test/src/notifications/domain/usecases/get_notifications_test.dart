import 'package:dartz/dartz.dart';
import 'package:education_app/src/notifications/domain/entities/notification.dart';
import 'package:education_app/src/notifications/domain/repos/notification_repo.dart';
import 'package:education_app/src/notifications/domain/usecases/get_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'notification_repo.mock.dart';

void main() {
  late GetNotifications usecase;
  late NotificationRepo repo;

  setUp(() {
    repo = MockNotificationRepo();
    usecase = GetNotifications(repo);
  });

  test('should return void when success', () {
    when(() => repo.getNotifications())
        .thenAnswer((_) => Stream.value(const Right([])));

    final result = usecase();

    expect(result, emits(const Right<dynamic, List<Notification>>([])));

    verify(() => repo.getNotifications()).called(1);

    verifyNoMoreInteractions(repo);
  });
}
