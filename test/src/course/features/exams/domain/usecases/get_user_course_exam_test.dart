import 'package:dartz/dartz.dart';
import 'package:education_app/src/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/src/course/features/exams/domain/repos/exam_repo.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/get_user_course_exams.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'exam_repo.mock.dart';

void main() {
  late GetUserCourseExams usecase;
  late ExamRepo repo;

  final tUserExam = UserExam.empty();

  setUp(() {
    repo = MockExamRepo();
    usecase = GetUserCourseExams(repo);
    registerFallbackValue(tUserExam);
  });

  test('should return List of UserExam when call getUserCourseExam success',
      () async {
    when(() => repo.getUserCourseExams(any()))
        .thenAnswer((_) async => const Right([]));

    final result = await usecase(tUserExam.courseId);

    expect(result, equals(const Right<dynamic, List<UserExam>>([])));

    verify(() => repo.getUserCourseExams(tUserExam.courseId)).called(1);

    verifyNoMoreInteractions(repo);
  });
}
