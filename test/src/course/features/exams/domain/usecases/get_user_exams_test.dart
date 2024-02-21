import 'package:dartz/dartz.dart';
import 'package:education_app/src/course/features/exams/domain/entities/user_choice.dart';
import 'package:education_app/src/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/src/course/features/exams/domain/repos/exam_repo.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/get_user_exams.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'exam_repo.mock.dart';

void main() {
  late GetUserExams usecase;
  late ExamRepo repo;

  final tUserExam = UserExam.empty();

  setUp(() {
    repo = MockExamRepo();
    usecase = GetUserExams(repo);
    registerFallbackValue(tUserExam);
  });

  test('should return List of UserExam when call GetUserExams success',
      () async {
    when(() => repo.getUserExams()).thenAnswer((_) async => const Right([]));

    final result = await usecase();

    expect(result, equals(const Right<dynamic, List<UserExam>>([])));

    verify(() => repo.getUserExams());

    verifyNoMoreInteractions(repo);
  });
}
