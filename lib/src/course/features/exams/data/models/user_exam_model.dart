import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/features/exams/data/models/user_choice_model.dart';
import 'package:education_app/src/course/features/exams/domain/entities/user_choice.dart';
import 'package:education_app/src/course/features/exams/domain/entities/user_exam.dart';

class UserExamModel extends UserExam {
  const UserExamModel({
    required super.dateSubmitted,
    required super.answers,
    required super.examId,
    required super.courseId,
    required super.totalQuestions,
    required super.examTitle,
    super.examImageUrl,
  });

  UserExamModel.empty([DateTime? date])
      : this(
          examId: '',
          courseId: '',
          totalQuestions: 0,
          examTitle: '',
          examImageUrl: '',
          dateSubmitted: date ?? DateTime.now(),
          answers: const [],
        );

  UserExamModel.fromMap(DataMap map)
      : this(
          examId: map['examId'] as String,
          courseId: map['courseId'] as String,
          totalQuestions: (map['totalQuestions'] as num).toInt(),
          examTitle: map['examTitle'] as String,
          examImageUrl: map['examImageUrl'] as String?,
          dateSubmitted: (map['dateSubmitted'] as Timestamp).toDate(),
          answers: List<DataMap>.from(map['answers'] as List<dynamic>)
              .map(UserChoiceModel.fromMap)
              .toList(),
        );

  UserExamModel copyWith({
    String? examId,
    String? courseId,
    int? totalQuestions,
    String? examTitle,
    String? examImageUrl,
    DateTime? dateSubmitted,
    List<UserChoice>? answers,
  }) {
    return UserExamModel(
      dateSubmitted: dateSubmitted ?? this.dateSubmitted,
      answers: answers ?? this.answers,
      examId: examId ?? this.examId,
      courseId: courseId ?? this.courseId,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      examTitle: examTitle ?? this.examTitle,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'examId': examId,
      'courseId': courseId,
      'totalQuestions': totalQuestions,
      'examTitle': examTitle,
      'examImageUrl': examImageUrl,
      'dateSubmitted': FieldValue.serverTimestamp(),
      'answers':
          answers.map((answer) => (answer as UserChoiceModel).toMap()).toList(),
    };
  }
}
