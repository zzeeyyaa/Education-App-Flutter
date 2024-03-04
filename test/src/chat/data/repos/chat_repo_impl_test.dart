import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/auth/data/models/user_model.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';
import 'package:education_app/src/chat/data/datasources/chat_remote_datasource.dart';
import 'package:education_app/src/chat/data/models/group_model.dart';
import 'package:education_app/src/chat/data/models/message_model.dart';
import 'package:education_app/src/chat/data/repos/chat_repo_impl.dart';
import 'package:education_app/src/chat/domain/entities/group.dart';
import 'package:education_app/src/chat/domain/entities/message.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRemoteDatasource extends Mock implements ChatRemoteDatasource {}

void main() {
  late ChatRemoteDatasource remoteDatasource;
  late ChatRepoImpl repoImpl;

  final tMessage = Message.empty();

  const tLocalUser = LocalUserModel.empty();

  const tUserId = 'id';

  setUpAll(() => registerFallbackValue(tMessage));

  setUp(() {
    remoteDatasource = MockChatRemoteDatasource();
    repoImpl = ChatRepoImpl(remoteDatasource);
  });

  group('getMessage', () {
    final expectedMessages = [
      MessageModel.empty(),
      MessageModel.empty().copyWith(
        id: '1',
        message: 'message 1',
      ),
    ];

    const groupId = 'sampleGroupId';

    final serverFailure = ServerFailure(
      message: 'Server Error',
      statusCode: '500',
    );

    test(
        'should return a stream of Right<List<Message>> when remote'
        ' data source is success', () {
      when(() => remoteDatasource.getMessages(any()))
          .thenAnswer((_) => Stream.value(expectedMessages));

      final stream = repoImpl.getMessages(groupId);

      expect(stream, emits(Right<Failure, List<Message>>(expectedMessages)));

      verify(() => remoteDatasource.getMessages(groupId)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
    test(
        'should return a stream of Left<Failure> when call '
        ' remotedatasource is error', () {
      when(() => remoteDatasource.getMessages(any())).thenAnswer(
        (_) => Stream.error(
          ServerException(
            message: serverFailure.message,
            statusCode: serverFailure.statusCode,
          ),
        ),
      );

      final stream = repoImpl.getMessages(groupId);

      expect(
          stream, emits(equals(Left<Failure, List<Message>>(serverFailure))));

      verify(() => remoteDatasource.getMessages(groupId)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });

    group('getGroups', () {
      final expectedGroups = [
        GroupModel.empty(),
        GroupModel.empty().copyWith(id: '1', name: 'Group 1'),
      ];

      final serverFailure = ServerFailure(
        message: 'ServerError',
        statusCode: '500',
      );

      test(
          'should return a stream of Right<List<Group>> when remote datasource'
          ' is success', () {
        when(() => remoteDatasource.getGroups())
            .thenAnswer((invocation) => Stream.value(expectedGroups));

        final stream = repoImpl.getGroups();

        expect(stream, emits(Right<Failure, List<Group>>(expectedGroups)));

        verify(() => remoteDatasource.getGroups()).called(1);

        verifyNoMoreInteractions(remoteDatasource);
      });
      test(
          'should return a stream of Left<Failure> when remote datasource'
          ' is failed', () {
        when(() => remoteDatasource.getGroups()).thenAnswer(
          (invocation) => Stream.error(
            ServerException(
              message: serverFailure.message,
              statusCode: serverFailure.statusCode.toString(),
            ),
          ),
        );

        final stream = repoImpl.getGroups();

        expect(
            stream, emits(equals(Left<Failure, List<Group>>(serverFailure))));

        verify(() => remoteDatasource.getGroups()).called(1);

        verifyNoMoreInteractions(remoteDatasource);
      });
    });
  });

  group('sendMessage', () {
    test('should complete successfully when call to remotedata sourcec success',
        () async {
      when(() => remoteDatasource.sendMessage(any()))
          .thenAnswer((_) async => Future.value());

      final result = await repoImpl.sendMessage(tMessage);

      expect(result, equals(const Right<dynamic, void>(null)));

      verify(() => remoteDatasource.sendMessage(tMessage)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
    test(
        'should return [ServerFailure] when call to remotedata sourcec success',
        () async {
      when(() => remoteDatasource.sendMessage(any())).thenThrow(
        const ServerException(message: 'message', statusCode: 'statusCode'),
      );

      final result = await repoImpl.sendMessage(tMessage);

      expect(
        result,
        equals(
          Left<ServerFailure, dynamic>(
            ServerFailure(message: 'message', statusCode: 'statusCode'),
          ),
        ),
      );

      verify(() => remoteDatasource.sendMessage(tMessage)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });

  group('joinGroup', () {
    const groupId = 'sampleGroupId';
    const userId = 'sampleUserId';

    test('should complete successfully when call to remote source', () async {
      when(
        () => remoteDatasource.joinGroup(
          groupId: any(named: 'groupId'),
          userId: any(named: 'userId'),
        ),
      ).thenAnswer((_) async => Future.value());
      final result = await repoImpl.joinGroup(groupId: groupId, userId: userId);

      expect(result, equals(const Right<dynamic, void>(null)));

      verify(
        () => remoteDatasource.joinGroup(groupId: groupId, userId: userId),
      ).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });

    test(
        'should return [ServerFailure] when call to remote source is '
        'unsuccessful', () async {
      when(
        () => remoteDatasource.joinGroup(
          groupId: any(named: 'groupId'),
          userId: any(named: 'userId'),
        ),
      ).thenThrow(
        const ServerException(message: 'message', statusCode: 'statusCode'),
      );

      final result = await repoImpl.joinGroup(groupId: groupId, userId: userId);

      expect(
        result,
        equals(
          Left<ServerFailure, dynamic>(
            ServerFailure(message: 'message', statusCode: 'statusCode'),
          ),
        ),
      );

      verify(
        () => remoteDatasource.joinGroup(
          groupId: groupId,
          userId: userId,
        ),
      ).called(1);
      verifyNoMoreInteractions(remoteDatasource);
    });
  });

  group('getUserById', () {
    test(
        'should complete successfully when call to remotedatasource is success',
        () async {
      when(() => remoteDatasource.getUserById(any()))
          .thenAnswer((_) async => tLocalUser);

      final result = await repoImpl.getUserById(tUserId);

      expect(result, equals(const Right<dynamic, LocalUser>(tLocalUser)));

      verify(() => remoteDatasource.getUserById(tUserId)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });

    test(
        'should return [ServerFailure] when call to remotedatasource is failed',
        () async {
      when(() => remoteDatasource.getUserById(any())).thenThrow(
          const ServerException(message: 'message', statusCode: 'statusCode'));
      final result = await repoImpl.getUserById(tUserId);

      expect(
        result,
        equals(
          Left<Failure, LocalUser>(
            ServerFailure(message: 'message', statusCode: 'statusCode'),
          ),
        ),
      );

      verify(() => remoteDatasource.getUserById(tUserId)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });
}
