import 'package:dartz/dartz.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:education_app/src/course/features/videos/domain/repos/video_repo.dart';
import 'package:education_app/src/course/features/videos/domain/usecases/get_videos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'video_repo.mock.dart';

void main() {
  late VideoRepo repo;
  late GetVideos usecase;

  final tVideo = Video.empty();

  setUp(() {
    repo = MockVideoRepo();
    usecase = GetVideos(repo);
  });

  test('should return List<Video> when success call repo GetVideos', () async {
    when(() => repo.getVideos(tVideo.courseId))
        .thenAnswer((_) async => Right([tVideo]));

    final result = await usecase(tVideo.courseId);

    // expect(result, equals(const Right<dynamic, List<Video>>([])));
    expect(result, isA<Right<dynamic, List<Video>>>());

    verify(() => repo.getVideos(tVideo.courseId)).called(1);
  });
}
