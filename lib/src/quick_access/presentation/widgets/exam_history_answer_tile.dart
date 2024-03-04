import 'package:education_app/core/res/my_colors.dart';
import 'package:education_app/src/course/features/exams/domain/entities/user_choice.dart';
import 'package:flutter/material.dart';

class ExamHistoryAnswerTile extends StatelessWidget {
  const ExamHistoryAnswerTile(
    this.answer, {
    required this.index,
    super.key,
  });

  final UserChoice answer;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(
        'Question $index',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        answer.isCorrect ? 'Right' : 'Wrong',
        style: TextStyle(
          color: answer.isCorrect ? MyColors.greenColour : MyColors.redColour,
          fontWeight: FontWeight.w400,
        ),
      ),
      children: [
        Text(
          'Your  answer: ${answer.userChoice}',
          style: TextStyle(
            color: answer.isCorrect ? MyColors.greenColour : MyColors.redColour,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
