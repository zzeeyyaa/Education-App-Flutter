import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/course/features/exams/data/models/exam_model.dart';
import 'package:education_app/src/course/features/exams/data/models/exam_question_model.dart';
import 'package:education_app/src/course/features/exams/data/models/user_exam_model.dart';
import 'package:education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/get_exam_questions.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/get_exams.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/get_user_course_exams.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/get_user_exams.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/submit_exam.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/update_exam.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/upload_exam.dart';
import 'package:education_app/src/course/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetExams extends Mock implements GetExams {}

class MockGetExamQuestions extends Mock implements GetExamQuestions {}

class MockUpdateExam extends Mock implements UpdateExam {}

class MockUploadExam extends Mock implements UploadExam {}

class MockSubmitExam extends Mock implements SubmitExam {}

class MockGetUserExams extends Mock implements GetUserExams {}

class MockGetUserCourseExams extends Mock implements GetUserCourseExams {}

void main() {
  late GetExams getExams;
  late GetExamQuestions getExamQuestions;
  late UpdateExam updateExam;
  late UploadExam uploadExam;
  late SubmitExam submitExam;
  late GetUserExams getUserExams;
  late GetUserCourseExams getUserCourseExams;
  late ExamCubit cubit;

  setUp(() {
    getExams = MockGetExams();
    getExamQuestions = MockGetExamQuestions();
    updateExam = MockUpdateExam();
    uploadExam = MockUploadExam();
    submitExam = MockSubmitExam();
    getUserExams = MockGetUserExams();
    getUserCourseExams = MockGetUserCourseExams();
    cubit = ExamCubit(
      getExams: getExams,
      getExamQuestions: getExamQuestions,
      uploadExam: uploadExam,
      updateExam: updateExam,
      submitExam: submitExam,
      getUserExams: getUserExams,
      getUserCourseExams: getUserCourseExams,
    );
  });

  final tFailure = ServerFailure(message: 'Server Failure', statusCode: '500');

  test('should make sure the initial ExamCubit', () {
    expect(cubit.state, const ExamInitial());
  });

  group('getExams', () {
    final tExamModel = [
      const ExamModel.empty(),
      const ExamModel.empty().copyWith(id: '1'),
    ];

    blocTest<ExamCubit, ExamState>(
      'should emit [GettingExams, ExamsLoaded] when success',
      build: () {
        when(() => getExams(any())).thenAnswer((_) async => Right(tExamModel));
        return cubit;
      },
      act: (cubit) => cubit.getExams(tExamModel[0].courseId),
      expect: () => <ExamState>[
        const GettingExam(),
        ExamsLoaded(tExamModel),
      ],
      verify: (_) {
        verify(() => getExams(tExamModel[0].courseId)).called(1);
        verifyNoMoreInteractions(getExams);
      },
    );
    blocTest<ExamCubit, ExamState>(
      'should emit [GettingExams, ExamError] when unsuccessful',
      build: () {
        when(() => getExams(any())).thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.getExams(tExamModel[0].courseId),
      expect: () => const <ExamState>[
        GettingExam(),
        ExamError('500 Error: ServerFailure'),
      ],
      verify: (_) {
        verify(() => getExams(tExamModel[0].courseId)).called(1);
        verifyNoMoreInteractions(getExams);
      },
    );
  });

  group('getExamQuestions', () {
    const tExam = ExamModel.empty();

    setUp(() => registerFallbackValue(tExam));

    final tQuestions = [
      const ExamQuestionModel.empty(),
      const ExamQuestionModel.empty().copyWith(id: '1'),
    ];

    blocTest<ExamCubit, ExamState>(
      'should emit [GettingExamQuestions, ExamQuestionsLoaded] when successful',
      build: () {
        when(() => getExamQuestions(any())).thenAnswer(
          (_) async => Right(tQuestions),
        );
        return cubit;
      },
      act: (cubit) => cubit.getExamQuestions(tExam),
      expect: () => [
        const GettingExamQuestions(),
        ExamQuestionsLoaded(tQuestions),
      ],
      verify: (_) {
        verify(() => getExamQuestions(tExam)).called(1);
        verifyNoMoreInteractions(getExamQuestions);
      },
    );

    blocTest<ExamCubit, ExamState>(
      'should emit [GettingExamQuestions, ExamError] when unsuccessful',
      build: () {
        when(() => getExamQuestions(tExam))
            .thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.getExamQuestions(tExam),
      expect: () => [
        const GettingExamQuestions(),
        const ExamError('500 Error : Server Failure'),
      ],
      verify: (_) {
        verify(() => getExamQuestions(tExam)).called(1);
        verifyNoMoreInteractions(getExamQuestions);
      },
    );
  });

  group('updateExam', () {
    const tExamModel = ExamModel.empty();
    blocTest<ExamCubit, ExamState>(
      'emits [UpdatingExam, ExamUpdated] when success',
      build: () {
        when(() => updateExam(tExamModel))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.updateExam(tExamModel),
      expect: () => const <ExamState>[
        UpdatingExam(),
        ExamUpdated(),
      ],
      verify: (_) {
        verify(() => updateExam(tExamModel)).called(1);
        verifyNoMoreInteractions(updateExam);
      },
    );
    blocTest<ExamCubit, ExamState>(
      'emits [UpdatingExam, ExamError] when failed',
      build: () {
        when(() => updateExam(tExamModel))
            .thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.updateExam(tExamModel),
      expect: () => const <ExamState>[
        UpdatingExam(),
        ExamError('500 Error : Server Failure'),
      ],
      verify: (_) {
        verify(() => updateExam(tExamModel)).called(1);
        verifyNoMoreInteractions(updateExam);
      },
    );
  });

  group('uploadExam', () {
    const tExamModel = ExamModel.empty();

    blocTest<ExamCubit, ExamState>(
      'emits [UploadingExam, ExamUploaded] when success',
      build: () {
        when(() => uploadExam(tExamModel))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.uploadExam(tExamModel),
      expect: () => const <ExamState>[
        UploadingExam(),
        ExamUploaded(),
      ],
      verify: (_) {
        verify(() => uploadExam(tExamModel)).called(1);
        verifyNoMoreInteractions(uploadExam);
      },
    );
    blocTest<ExamCubit, ExamState>(
      'emits [UploadingExam, ExamError] when failed',
      build: () {
        when(() => uploadExam(tExamModel))
            .thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.uploadExam(tExamModel),
      expect: () => const <ExamState>[
        UploadingExam(),
        ExamError('500 Error : Server Failure'),
      ],
      verify: (_) {
        verify(() => uploadExam(tExamModel)).called(1);
        verifyNoMoreInteractions(uploadExam);
      },
    );
  });

  group('submitExam', () {
    final tUserExamModel = UserExamModel.empty();

    blocTest<ExamCubit, ExamState>(
      'emits [SubmittingExam, ExamSubmitted] when success',
      build: () {
        when(() => submitExam(tUserExamModel))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.submitExam(tUserExamModel),
      expect: () => const <ExamState>[
        SubmittingExam(),
        ExamSubmitted(),
      ],
      verify: (_) {
        verify(() => submitExam(tUserExamModel)).called(1);
        verifyNoMoreInteractions(submitExam);
      },
    );
    blocTest<ExamCubit, ExamState>(
      'emits [SubmittingExam, ExamError] when failed',
      build: () {
        when(() => submitExam(tUserExamModel))
            .thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.submitExam(tUserExamModel),
      expect: () => const <ExamState>[
        SubmittingExam(),
        ExamError('500 Error : Server Failure'),
      ],
      verify: (_) {
        verify(() => submitExam(tUserExamModel)).called(1);
        verifyNoMoreInteractions(uploadExam);
      },
    );
  });

  group('getUserExams', () {
    final tUserExamModel = UserExamModel.empty();

    setUp(() {
      registerFallbackValue(tUserExamModel);
    });

    blocTest<ExamCubit, ExamState>(
      'emits [GettingUserExams, UserExamLoaded] when success',
      build: () {
        when(() => getUserExams())
            .thenAnswer((_) async => Right([tUserExamModel]));
        return cubit;
      },
      act: (cubit) => cubit.getUserExams(),
      expect: () => <ExamState>[
        const GettingUserExams(),
        UserExamsLoaded([tUserExamModel]),
      ],
      verify: (_) {
        verify(() => getUserExams()).called(1);
        verifyNoMoreInteractions(getUserExams);
      },
    );
    blocTest<ExamCubit, ExamState>(
      'emits [GettingUserCourseExams, ExamError] when failed',
      build: () {
        when(() => getUserExams()).thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.getUserExams(),
      expect: () => const <ExamState>[
        GettingUserExams(),
        ExamError('500 Error : Server Failure'),
      ],
      verify: (_) {
        verify(() => getUserExams()).called(1);
        verifyNoMoreInteractions(getUserExams);
      },
    );
  });
  group('getUserCourseExams', () {
    final tUserExamModel = UserExamModel.empty();

    setUp(() {
      registerFallbackValue(tUserExamModel);
    });

    const tExamModel = ExamModel.empty();

    blocTest<ExamCubit, ExamState>(
      'emits [GettingUserExams, UserExamLoaded] when success',
      build: () {
        when(() => getUserExams())
            .thenAnswer((_) async => Right([tUserExamModel]));
        return cubit;
      },
      act: (cubit) => cubit.getUserExams(),
      expect: () => <ExamState>[
        const GettingUserExams(),
        UserExamsLoaded([tUserExamModel]),
      ],
      verify: (_) {
        verify(() => getUserExams()).called(1);
        verifyNoMoreInteractions(getUserExams);
      },
    );
    blocTest<ExamCubit, ExamState>(
      'emits [GettingUserCourseExams, ExamError] when failed',
      build: () {
        when(() => getUserCourseExams(tExamModel.courseId))
            .thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.getUserCourseExams(tExamModel.courseId),
      expect: () => const <ExamState>[
        GettingUserCourseExams(),
        ExamError('500 Error : Server Failure'),
      ],
      verify: (_) {
        verify(() => getUserCourseExams(tExamModel.courseId)).called(1);
        verifyNoMoreInteractions(getUserCourseExams);
      },
    );
  });
}
