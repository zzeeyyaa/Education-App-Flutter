import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/domain/repos/course_repo.dart';
import 'package:education_app/src/course/domain/usecases/get_courses.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'course_repo.mock.dart';

void main() {
  late CourseRepo repo;
  late GetCourse usecase;

  setUp(() {
    repo = MockCourseRepo();
    usecase = GetCourse(repo);
  });

  test('should call [CourseRepo.getCourse] and return List<Course>', () async {
    when(() => repo.getCourses()).thenAnswer((_) async => const Right([]));

    final result = await usecase();

    expect(result, equals(const Right<Failure, List<Course>>([])));

    verify(() => repo.getCourses()).called(1);

    verifyNoMoreInteractions(repo);
  });
}
