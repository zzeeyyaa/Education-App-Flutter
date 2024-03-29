import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/features/videos/data/datasources/video_remote_datasource.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:education_app/src/course/features/videos/domain/repos/video_repo.dart';

class VideoRepoImpl implements VideoRepo {
  const VideoRepoImpl(this._remoteDatasource);

  final VideoRemoteDatasource _remoteDatasource;

  @override
  ResultFuture<void> addVideo(Video video) async {
    try {
      await _remoteDatasource.addVideo(video);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<Video>> getVideos(String courseId) async {
    try {
      final result = await _remoteDatasource.getVideo(courseId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
