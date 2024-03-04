import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/res/my_colors.dart';
import 'package:education_app/src/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/src/quick_access/presentation/views/exam_history_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ExamHistoryTile extends StatelessWidget {
  const ExamHistoryTile(
    this.exam, {
    super.key,
    this.navigateToDetails = true,
  });

  final UserExam exam;
  final bool navigateToDetails;

  @override
  Widget build(BuildContext context) {
    final answeredQuestinsPercentage =
        exam.answers.length / exam.totalQuestions;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: navigateToDetails
          ? () => Navigator.of(context).pushNamed(
                ExamHistoryDetailsScreen.routeName,
                arguments: exam,
              )
          : null,
      child: Row(
        children: [
          Container(
            height: 14,
            width: 54,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: MyColors.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: exam.examImageUrl == null
                ? Image.asset(MediaRes.test)
                : Image.network(exam.examImageUrl!),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.examTitle,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'You have completed',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: '${exam.answers.length}/${exam.totalQuestions}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: answeredQuestinsPercentage < .5
                          ? MyColors.redColour
                          : MyColors.greenColour,
                    ),
                    children: const [
                      TextSpan(
                        text: 'questions',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          CircularStepProgressIndicator(
            totalSteps: exam.totalQuestions,
            currentStep: exam.answers.length,
            selectedColor: answeredQuestinsPercentage < .5
                ? MyColors.redColour
                : MyColors.greenColour,
            padding: 0,
            width: 60,
            height: 60,
            child: Center(
              child: Text(
                '${(answeredQuestinsPercentage * 100).toInt()}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: answeredQuestinsPercentage < .5
                      ? MyColors.redColour
                      : MyColors.greenColour,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
