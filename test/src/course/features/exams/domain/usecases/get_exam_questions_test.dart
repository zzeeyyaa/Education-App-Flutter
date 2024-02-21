import 'package:dartz/dartz.dart';
import 'package:education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/src/course/features/exams/domain/entities/exam_question.dart';
import 'package:education_app/src/course/features/exams/domain/repos/exam_repo.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/get_exam_questions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'exam_repo.mock.dart';

void main() {
  late GetExamQuestions usecase;
  late ExamRepo repo;

  const tExam = Exam.empty();

  setUp(() {
    repo = MockExamRepo();
    usecase = GetExamQuestions(repo);
    registerFallbackValue(tExam);
  });

  test('should return List of [ExamQuestion] when call GetExamQuestions',
      () async {
    when(() => repo.getExamQuestions(any()))
        .thenAnswer((_) async => const Right([]));

    final result = await usecase(tExam);

    expect(result, equals(const Right<dynamic, List<ExamQuestion>>([])));

    verify(() => repo.getExamQuestions(tExam)).called(1);

    verifyNoMoreInteractions(repo);
  });
}
