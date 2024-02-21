import 'package:dartz/dartz.dart';
import 'package:education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/src/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/src/course/features/exams/domain/repos/exam_repo.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/submit_exam.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'exam_repo.mock.dart';

void main() {
  late SubmitExam usecase;
  late ExamRepo repo;

  final tUserExam = UserExam.empty();

  setUp(() {
    repo = MockExamRepo();
    usecase = SubmitExam(repo);
    registerFallbackValue(tUserExam);
  });

  test('should return void when call SubmitExam success', () async {
    when(() => repo.submitExam(any()))
        .thenAnswer((_) async => const Right(null));

    final result = await usecase(tUserExam);

    expect(result, equals(const Right<dynamic, void>(null)));

    verify(() => repo.submitExam(tUserExam));

    verifyNoMoreInteractions(repo);
  });
}
