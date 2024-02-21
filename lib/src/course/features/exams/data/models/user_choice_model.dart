import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/features/exams/domain/entities/user_choice.dart';

class UserChoiceModel extends UserChoice {
  const UserChoiceModel({
    required super.userChoice,
    required super.questionId,
    required super.correctChoice,
  });

  const UserChoiceModel.empty()
      : this(
          questionId: '',
          correctChoice: '',
          userChoice: '',
        );

  UserChoiceModel.fromMap(DataMap map)
      : this(
          questionId: map['questionId'] as String,
          correctChoice: map['correctChoice'] as String,
          userChoice: map['userChoice'] as String,
        );

  UserChoiceModel copyWith({
    String? questionId,
    String? correctChoice,
    String? userChoice,
  }) {
    return UserChoiceModel(
      userChoice: userChoice ?? this.userChoice,
      questionId: questionId ?? this.questionId,
      correctChoice: correctChoice ?? this.correctChoice,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'questionId': questionId,
      'correctChoice': correctChoice,
      'userChoice': userChoice,
    };
  }
}
