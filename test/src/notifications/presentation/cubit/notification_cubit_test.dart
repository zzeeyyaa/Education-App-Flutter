import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/notifications/data/models/notification_model.dart';
import 'package:education_app/src/notifications/domain/usecases/clear.dart';
import 'package:education_app/src/notifications/domain/usecases/clear_all.dart';
import 'package:education_app/src/notifications/domain/usecases/get_notifications.dart';
import 'package:education_app/src/notifications/domain/usecases/mark_as_read.dart';
import 'package:education_app/src/notifications/domain/usecases/send_notification.dart';
import 'package:education_app/src/notifications/presentation/cubit/notification_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockClear extends Mock implements Clear {}

class MockClearAll extends Mock implements ClearAll {}

class MockGetNotifications extends Mock implements GetNotifications {}

class MockMarkAsRead extends Mock implements MarkAsRead {}

class MockSendNotification extends Mock implements SendNotification {}

void main() {
  late NotificationCubit cubit;
  late Clear clear;
  late ClearAll clearAll;
  late GetNotifications getNotifications;
  late MarkAsRead markAsRead;
  late SendNotification sendNotification;

  setUp(() {
    clear = MockClear();
    clearAll = MockClearAll();
    getNotifications = MockGetNotifications();
    markAsRead = MockMarkAsRead();
    sendNotification = MockSendNotification();
    cubit = NotificationCubit(
      clear: clear,
      clearAll: clearAll,
      getNotifications: getNotifications,
      markAsRead: markAsRead,
      sendNotification: sendNotification,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is NotificationInitial', () {
    expect(cubit.state, const NotificationInitial());
  });

  final tFailure = ServerFailure(message: 'Server Error', statusCode: 500);

  final tNotification = NotificationModel.empty();

  group('clear', () {
    blocTest<NotificationCubit, NotificationState>(
      'emits [ClearingNotifications, NotificationInitial] whensuccess',
      build: () {
        when(() => clear(any())).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.clear(tNotification.id),
      expect: () => const <NotificationState>[
        ClearingNotifications(),
        NotificationInitial(),
      ],
      verify: (_) {
        verify(() => clear(tNotification.id)).called(1);
        verifyNoMoreInteractions(clear);
      },
    );
    blocTest<NotificationCubit, NotificationState>(
      'emits [ClearingNotifications, NotificationError] when failed',
      build: () {
        when(() => clear(any())).thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.clear(tNotification.id),
      expect: () => <NotificationState>[
        const ClearingNotifications(),
        NotificationError(tFailure.errorMeesage),
      ],
      verify: (_) {
        verify(() => clear(tNotification.id)).called(1);
        verifyNoMoreInteractions(clear);
      },
    );
  });

  group('clearAll', () {
    blocTest<NotificationCubit, NotificationState>(
      'emits [ClearingNotifications, NotificationInitial] whensuccess',
      build: () {
        when(() => clearAll()).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.clearAll(),
      expect: () => const <NotificationState>[
        ClearingNotifications(),
        NotificationInitial(),
      ],
      verify: (_) {
        verify(() => clearAll()).called(1);
        verifyNoMoreInteractions(clearAll);
      },
    );
    blocTest<NotificationCubit, NotificationState>(
      'emits [ClearingNotifications, NotificationError] when failed',
      build: () {
        when(() => clearAll()).thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.clearAll(),
      expect: () => <NotificationState>[
        const ClearingNotifications(),
        NotificationError(tFailure.errorMeesage),
      ],
      verify: (_) {
        verify(() => clearAll()).called(1);
        verifyNoMoreInteractions(clearAll);
      },
    );
  });

  group('markAsRead', () {
    blocTest<NotificationCubit, NotificationState>(
      'emits [NotificationInitial] whensuccess',
      build: () {
        when(() => markAsRead(any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.markAsRead(tNotification.id),
      expect: () => const <NotificationState>[
        NotificationInitial(),
      ],
      verify: (_) {
        verify(() => markAsRead(tNotification.id)).called(1);
        verifyNoMoreInteractions(markAsRead);
      },
    );
    blocTest<NotificationCubit, NotificationState>(
      'emits [NotificationError] when failed',
      build: () {
        when(() => markAsRead(any())).thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.markAsRead(tNotification.id),
      expect: () => <NotificationState>[
        NotificationError(tFailure.errorMeesage),
      ],
      verify: (_) {
        verify(() => markAsRead(tNotification.id)).called(1);
        verifyNoMoreInteractions(markAsRead);
      },
    );
  });
  group('sendNotification', () {
    setUp(() => registerFallbackValue(tNotification));
    blocTest<NotificationCubit, NotificationState>(
      'emits [SendingNotification, NotificationSent] when success',
      build: () {
        when(() => sendNotification(any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.sendNotification(tNotification),
      expect: () => const <NotificationState>[
        SendingNotification(),
        NotificationSent(),
      ],
      verify: (_) {
        verify(() => sendNotification(tNotification)).called(1);
        verifyNoMoreInteractions(sendNotification);
      },
    );
    blocTest<NotificationCubit, NotificationState>(
      'emits [SendingNotification, NotificationError] when failed',
      build: () {
        when(() => sendNotification(any()))
            .thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.sendNotification(tNotification),
      expect: () => <NotificationState>[
        const SendingNotification(),
        NotificationError(tFailure.errorMeesage),
      ],
      verify: (_) {
        verify(() => sendNotification(tNotification)).called(1);
        verifyNoMoreInteractions(sendNotification);
      },
    );
  });
  group('getNotifications', () {
    final tListNotification = [tNotification];
    blocTest<NotificationCubit, NotificationState>(
      'emits [GettingNotification, NotificationsLoaded] when success',
      build: () {
        when(() => getNotifications())
            .thenAnswer((_) => Stream.value(Right(tListNotification)));
        return cubit;
      },
      act: (cubit) => cubit.getNotifications(),
      expect: () => <NotificationState>[
        const GettingNotifications(),
        NotificationsLoaded(tListNotification),
      ],
      verify: (_) {
        verify(() => getNotifications()).called(1);
        verifyNoMoreInteractions(getNotifications);
      },
    );
    blocTest<NotificationCubit, NotificationState>(
      'emits [GettingNotifications, NotificationError] when failed',
      build: () {
        when(() => getNotifications())
            .thenAnswer((_) => Stream.value(Left(tFailure)));
        return cubit;
      },
      act: (cubit) => cubit.getNotifications(),
      expect: () => <NotificationState>[
        const GettingNotifications(),
        NotificationError(tFailure.errorMeesage),
      ],
      verify: (_) {
        verify(() => getNotifications()).called(1);
        verifyNoMoreInteractions(getNotifications);
      },
    );
  });
}
