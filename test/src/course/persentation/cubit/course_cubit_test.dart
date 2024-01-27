import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/course/data/models/course_model.dart';
import 'package:education_app/src/course/domain/usecases/add_course.dart';
import 'package:education_app/src/course/domain/usecases/get_courses.dart';
import 'package:education_app/src/course/persentation/cubit/course_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddCourse extends Mock implements AddCourse {}

class MockGetCourse extends Mock implements GetCourse {}

void main() {
  late CourseCubit cubit;
  late AddCourse addCourse;
  late GetCourse getCourse;

  setUp(() {
    addCourse = MockAddCourse();
    getCourse = MockGetCourse();
    cubit = CourseCubit(addCourse, getCourse);
  });

  final tCourse = CourseModel.empty();

  setUpAll(() {
    registerFallbackValue(tCourse);
  });

  final tServerFailure = ServerFailure(
    message: 'Something went wrong',
    statusCode: '500',
  );

  tearDown(() {
    cubit.close();
  });

  test('make sure initial state should be [CourseInitial]', () {
    expect(cubit.state, const CourseInitial());
  });

  group('addCourse', () {
    blocTest<CourseCubit, CourseState>(
      'emits [AddingCourse, CourseAdded] when success call addCourse',
      build: () {
        when(() => addCourse(any())).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.addCourse(tCourse),
      expect: () => const <CourseState>[
        AddingCourse(),
        CourseAdded(),
      ],
      verify: (_) {
        verify(() => addCourse(tCourse)).called(1);
        verifyNoMoreInteractions(addCourse);
      },
    );
    blocTest<CourseCubit, CourseState>(
      'emits [AddingCourse, CourseError] when failed',
      build: () {
        when(() => addCourse(any()))
            .thenAnswer((invocation) async => Left(tServerFailure));
        return cubit;
      },
      act: (cubit) => cubit.addCourse(tCourse),
      expect: () => <CourseState>[
        const AddingCourse(),
        CourseError(tServerFailure.errorMeesage),
      ],
      verify: (_) {
        verify(() => addCourse(tCourse)).called(1);
        verifyNoMoreInteractions(addCourse);
      },
    );
  });

  group('getCourse', () {
    blocTest<CourseCubit, CourseState>(
      'emits [LoadingCourses, CoursesLoaded] when success',
      build: () {
        when(() => getCourse())
            .thenAnswer((invocation) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.getCourse(),
      expect: () => const <CourseState>[
        LoadingCourses(),
        CoursesLoaded([]),
      ],
      verify: (_) {
        verify(() => getCourse()).called(1);
        verifyNoMoreInteractions(getCourse);
      },
    );
    blocTest<CourseCubit, CourseState>(
      'emits [LoadingCourses, CourseError] when failed',
      build: () {
        when(() => getCourse()).thenAnswer((_) async => Left(tServerFailure));
        return cubit;
      },
      act: (cubit) => cubit.getCourse(),
      expect: () => <CourseState>[
        const LoadingCourses(),
        CourseError(tServerFailure.errorMeesage),
      ],
      verify: (_) {
        verify(() => getCourse()).called(1);
        verifyNoMoreInteractions(getCourse);
      },
    );
  });
}
