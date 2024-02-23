import 'package:dartz/dartz.dart';
import 'package:education_app/src/notifications/domain/entities/notification.dart';
import 'package:education_app/src/notifications/domain/repos/notification_repo.dart';
import 'package:education_app/src/notifications/domain/usecases/clear.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'notification_repo.mock.dart';

void main() {
  late Clear usecase;
  late NotificationRepo repo;

  setUp(() {
    repo = MockNotificationRepo();
    usecase = Clear(repo);
  });

  final tNotification = Notification.empty();

  test('should return void when success', () async {
    when(() => repo.clear(any())).thenAnswer((_) async => const Right(null));

    final result = await usecase(tNotification.id);

    expect(result, isA<Right<dynamic, void>>());

    verify(() => repo.clear(tNotification.id)).called(1);

    verifyNoMoreInteractions(repo);
  });
}
