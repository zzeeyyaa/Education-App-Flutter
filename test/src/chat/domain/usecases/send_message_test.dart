import 'package:dartz/dartz.dart';
import 'package:education_app/src/chat/domain/entities/message.dart';
import 'package:education_app/src/chat/domain/repos/chat_repo.dart';
import 'package:education_app/src/chat/domain/usecases/send_message.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'chat_repo.mock.dart';

void main() {
  late ChatRepo repo;
  late SendMessage usecase;

  final tMessage = Message.empty();

  setUp(() {
    repo = MockChatRepo();
    usecase = SendMessage(repo);

    registerFallbackValue(tMessage);
  });

  test('should call ChatRepo.sendMessage', () async {
    when(() => repo.sendMessage(any()))
        .thenAnswer((_) async => const Right(null));

    final result = await usecase(tMessage);

    expect(result, const Right<dynamic, void>(null));

    verify(() => repo.sendMessage(tMessage)).called(1);

    verifyNoMoreInteractions(repo);
  });
}
