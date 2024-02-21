import 'package:education_app/src/course/features/exams/domain/entities/user_choice.dart';
import 'package:equatable/equatable.dart';

class UserExam extends Equatable {
  const UserExam({
    required this.dateSubmitted,
    required this.answers,
    required this.examId,
    required this.courseId,
    required this.totalQuestions,
    required this.examTitle,
    this.examImageUrl,
  });

  UserExam.empty([DateTime? date])
      : this(
          examId: '',
          courseId: '',
          totalQuestions: 0,
          examTitle: '',
          examImageUrl: '',
          dateSubmitted: date ?? DateTime.now(),
          answers: const [],
        );

  final String examId;
  final String courseId;
  final int totalQuestions;
  final String examTitle;
  final String? examImageUrl;
  final DateTime dateSubmitted;
  final List<UserChoice> answers;

  @override
  List<Object?> get props => [examId, courseId];
}
