import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/chat/domain/entities/message.dart';
import 'package:education_app/src/chat/domain/repos/chat_repo.dart';
import 'package:education_app/src/chat/domain/usecases/get_messages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'chat_repo.mock.dart';

void main() {
  late ChatRepo repo;
  late GetMessages usecase;

  setUp(() {
    repo = MockChatRepo();
    usecase = GetMessages(repo);
  });

  test('should emit [List<Message>] from the [ChatRepo]', () async {
    final expectedMessage = [
      Message(
        id: '1',
        senderId: '1',
        message: 'Hello',
        groupId: '1',
        timestamp: DateTime.now(),
      ),
      Message(
        id: '2',
        senderId: '2',
        message: 'Hi',
        groupId: '1',
        timestamp: DateTime.now(),
      ),
    ];

    when(() => repo.getMessages(any()))
        .thenAnswer((_) => Stream.value(Right(expectedMessage)));

    final stream = usecase('groupId');

    expect(
      stream,
      emitsInOrder([Right<Failure, List<Message>>(expectedMessage)]),
    );

    verify(() => repo.getMessages('groupId')).called(1);

    verifyNoMoreInteractions(repo);
  });
}
