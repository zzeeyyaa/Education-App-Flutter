import 'package:dartz/dartz.dart';
import 'package:education_app/src/notifications/domain/repos/notification_repo.dart';
import 'package:education_app/src/notifications/domain/usecases/clear_all.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'notification_repo.mock.dart';

void main() {
  late ClearAll usecase;
  late NotificationRepo repo;

  setUp(() {
    repo = MockNotificationRepo();
    usecase = ClearAll(repo);
  });

  test('should return void when success', () async {
    when(() => repo.clearAll()).thenAnswer((_) async => const Right(null));

    final result = await usecase();

    expect(result, isA<Right<dynamic, void>>());

    verify(() => repo.clearAll()).called(1);

    verifyNoMoreInteractions(repo);
  });
}
