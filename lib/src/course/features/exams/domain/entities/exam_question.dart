// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:education_app/src/course/features/exams/domain/entities/question_choice.dart';

class ExamQuestion extends Equatable {
  const ExamQuestion({
    required this.id,
    required this.courseId,
    required this.examId,
    required this.questionText,
    required this.choices,
    this.corrextAnswer,
  });

  const ExamQuestion.empty()
      : this(
          id: '',
          examId: '',
          courseId: '',
          questionText: '',
          choices: const [],
        );

  final String id;
  final String courseId;
  final String examId;
  final String questionText;
  final String? corrextAnswer;
  final List<QuestionChoice> choices;

  @override
  List<Object?> get props => [id, examId, courseId];
}
