import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:education_app/src/course/features/videos/domain/repos/video_repo.dart';

class GetVideos extends FutureUsecaseWithParams<List<Video>, String> {
  const GetVideos(this._repo);

  final VideoRepo _repo;

  @override
  ResultFuture<List<Video>> call(String params) {
    return _repo.getVideos(params);
  }
}
