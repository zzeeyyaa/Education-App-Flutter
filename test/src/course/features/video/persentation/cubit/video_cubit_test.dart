import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/course/features/videos/data/models/video_model.dart';
import 'package:education_app/src/course/features/videos/domain/usecases/add_video.dart';
import 'package:education_app/src/course/features/videos/domain/usecases/get_videos.dart';
import 'package:education_app/src/course/features/videos/presentation/cubit/video_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddVideo extends Mock implements AddVideo {}

class MockGetVideos extends Mock implements GetVideos {}

void main() {
  late AddVideo addVideo;
  late GetVideos getVideos;
  late VideoCubit cubit;

  final tVideoModel = VideoModel.empty();

  setUp(() {
    addVideo = MockAddVideo();
    getVideos = MockGetVideos();
    cubit = VideoCubit(addVideo: addVideo, getVideos: getVideos);
    registerFallbackValue(tVideoModel);
  });

  final tServerFailure = ServerFailure(
    message: 'video-not-found',
    statusCode: 'There is no video record corresponding to this identifier. '
        'The video may have been deleted',
  );

  group('addVideo', () {
    blocTest<VideoCubit, VideoState>(
      'emits [AddingVideo, VideoAdded] when success',
      build: () {
        when(() => addVideo(any())).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.addVideo(tVideoModel),
      expect: () => const <VideoState>[
        AddingVideo(),
        VideoAdded(),
      ],
      verify: (_) {
        verify(() => addVideo(tVideoModel)).called(1);

        verifyNoMoreInteractions(addVideo);
      },
    );
    blocTest<VideoCubit, VideoState>(
      'emits [AddingVideo, VideoError] when failed',
      build: () {
        when(() => addVideo(any()))
            .thenAnswer((_) async => Left(tServerFailure));
        return cubit;
      },
      act: (cubit) => cubit.addVideo(tVideoModel),
      expect: () => <VideoState>[
        const AddingVideo(),
        VideoError(tServerFailure.message),
      ],
      verify: (_) {
        verify(() => addVideo(tVideoModel)).called(1);

        verifyNoMoreInteractions(addVideo);
      },
    );
  });

  group('getVideos', () {
    blocTest<VideoCubit, VideoState>(
      'emits [LoadingVideos, Videoloaded] when success',
      build: () {
        when(() => getVideos(any()))
            .thenAnswer((_) async => Right([tVideoModel]));
        return cubit;
      },
      act: (cubit) => cubit.getVideos(tVideoModel.courseId),
      expect: () => <VideoState>[
        const LoadingVideos(),
        VideosLoaded([tVideoModel]),
      ],
      verify: (_) {
        verify(() => getVideos(tVideoModel.courseId)).called(1);

        verifyNoMoreInteractions(getVideos);
      },
    );
    blocTest<VideoCubit, VideoState>(
      'emits [LoadingVideos, VideosLoaded] when failed',
      build: () {
        when(() => getVideos(any()))
            .thenAnswer((_) async => Left(tServerFailure));
        return cubit;
      },
      act: (cubit) => cubit.getVideos(tVideoModel.courseId),
      expect: () => <VideoState>[
        const LoadingVideos(),
        VideoError(tServerFailure.message),
      ],
      verify: (_) {
        verify(() => getVideos(tVideoModel.courseId)).called(1);

        verifyNoMoreInteractions(getVideos);
      },
    );
  });
}
