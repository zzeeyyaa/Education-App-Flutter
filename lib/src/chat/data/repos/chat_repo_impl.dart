import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';
import 'package:education_app/src/chat/data/datasources/chat_remote_datasource.dart';
import 'package:education_app/src/chat/data/models/group_model.dart';
import 'package:education_app/src/chat/data/models/message_model.dart';
import 'package:education_app/src/chat/domain/entities/group.dart';
import 'package:education_app/src/chat/domain/entities/message.dart';
import 'package:education_app/src/chat/domain/repos/chat_repo.dart';

class ChatRepoImpl implements ChatRepo {
  const ChatRepoImpl(this._remoteDatasource);

  final ChatRemoteDatasource _remoteDatasource;

  @override
  ResultStream<List<Group>> getGroups() {
    return _remoteDatasource.getGroups().transform(
          StreamTransformer<List<GroupModel>,
              Either<Failure, List<Group>>>.fromHandlers(
            handleError: (error, stackTrace, sink) {
              if (error is ServerException) {
                sink.add(
                  Left(
                    ServerFailure(
                      message: error.message,
                      statusCode: error.statusCode,
                    ),
                  ),
                );
              } else {
                //handle other types of exceptions as needed
                sink.add(
                  Left(
                    ServerFailure(
                      message: error.toString(),
                      statusCode: 500,
                    ),
                  ),
                );
              }
            },
            handleData: (groups, sink) {
              sink.add(Right(groups));
            },
          ),
        );
  }

  @override
  ResultStream<List<Message>> getMessages(String groupId) {
    return _remoteDatasource.getMessages(groupId).transform(_handleStream());
  }

  StreamTransformer<List<MessageModel>, Either<Failure, List<Message>>>
      _handleStream() {
    return StreamTransformer<List<MessageModel>,
        Either<Failure, List<Message>>>.fromHandlers(
      handleError: (error, stackTrace, sink) {
        if (error is ServerException) {
          sink.add(
            Left(
              ServerFailure(
                message: error.message,
                statusCode: error.statusCode,
              ),
            ),
          );
        } else {
          sink.add(
            Left(
              ServerFailure(
                message: error.toString(),
                statusCode: 500,
              ),
            ),
          );
        }
      },
      handleData: (messages, sink) {
        sink.add(Right(messages));
      },
    );
  }

  @override
  ResultFuture<LocalUser> getUserById(String userId) async {
    try {
      final result = await _remoteDatasource.getUserById(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultVoid joinGroup({
    required String groupId,
    required String userId,
  }) async {
    try {
      await _remoteDatasource.joinGroup(
        groupId: groupId,
        userId: userId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultVoid leaveGroup({
    required String groupId,
    required String userId,
  }) async {
    try {
      await _remoteDatasource.leaveGroup(groupId: groupId, userId: userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultVoid sendMessage(Message message) async {
    try {
      await _remoteDatasource.sendMessage(message);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
