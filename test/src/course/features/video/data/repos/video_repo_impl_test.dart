import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/course/features/videos/data/datasources/video_remote_datasource.dart';
import 'package:education_app/src/course/features/videos/data/models/video_model.dart';
import 'package:education_app/src/course/features/videos/data/repos/video_repo_impl.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockVideoRemoteDatasource extends Mock implements VideoRemoteDatasource {}

void main() {
  late VideoRemoteDatasource remoteDatasource;
  late VideoRepoImpl repoImpl;

  final tVideoModel = VideoModel.empty();

  setUp(() {
    remoteDatasource = MockVideoRemoteDatasource();
    repoImpl = VideoRepoImpl(remoteDatasource);
    registerFallbackValue(tVideoModel);
  });

  const tException = ServerException(
    message: 'Failed ',
    statusCode: '404',
  );

  group('addVideo', () {
    test('should return void when success call remoteDatasource [addVideo]',
        () async {
      when(() => remoteDatasource.addVideo(any()))
          .thenAnswer((_) async => Future.value());

      final result = await repoImpl.addVideo(tVideoModel);

      expect(result, equals(const Right<dynamic, void>(null)));

      verify(() => remoteDatasource.addVideo(tVideoModel)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
    test(
        'should return ServerFailure when failed'
        ' call remoteDatasource [addVideo]', () async {
      when(() => remoteDatasource.addVideo(any())).thenThrow(tException);

      final result = await repoImpl.addVideo(tVideoModel);

      expect(
        result,
        equals(
          Left<ServerFailure, dynamic>(ServerFailure.fromException(tException)),
        ),
      );

      verify(() => remoteDatasource.addVideo(tVideoModel)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });

  group('getVideos', () {
    test(
        'should return List<Video> when success call'
        ' remoteDatasource [getVideo]', () async {
      when(() => remoteDatasource.getVideo(any()))
          .thenAnswer((_) async => [tVideoModel]);

      final result = await repoImpl.getVideos(tVideoModel.courseId);

      expect(result, isA<Right<dynamic, List<Video>>>());

      verify(() => remoteDatasource.getVideo(tVideoModel.courseId)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });

    test(
        'should return ServerFailure when failed call'
        ' remoteDatasource [getVideo]', () async {
      when(() => remoteDatasource.getVideo(any())).thenThrow(tException);

      final result = await repoImpl.getVideos(tVideoModel.courseId);

      expect(
        result,
        equals(
          Left<ServerFailure, dynamic>(ServerFailure.fromException(tException)),
        ),
      );

      verify(() => remoteDatasource.getVideo(tVideoModel.courseId)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });
}
