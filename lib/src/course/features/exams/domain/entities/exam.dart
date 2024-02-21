import 'package:education_app/src/course/features/exams/domain/entities/exam_question.dart';
import 'package:equatable/equatable.dart';

class Exam extends Equatable {
  const Exam({
    required this.id,
    required this.courseId,
    required this.description,
    required this.timeLimit,
    required this.title,
    this.imageUrl,
    this.questions,
  });

  const Exam.empty()
      : this(
          id: '',
          courseId: '',
          title: '',
          description: '',
          timeLimit: 0,
          questions: const [],
        );

  final String id;
  final String courseId;
  final String title;
  final String? imageUrl;
  final String description;
  final int timeLimit;
  final List<ExamQuestion>? questions;

  @override
  List<Object?> get props => [id, courseId];
}
