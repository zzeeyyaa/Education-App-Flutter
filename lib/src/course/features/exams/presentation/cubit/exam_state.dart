part of 'exam_cubit.dart';

sealed class ExamState extends Equatable {
  const ExamState();

  @override
  List<Object> get props => [];
}

final class ExamInitial extends ExamState {
  const ExamInitial();
}

//*GetExams
class GettingExam extends ExamState {
  const GettingExam();
}

class ExamsLoaded extends ExamState {
  const ExamsLoaded(this.exams);

  final List<Exam> exams;

  @override
  List<Object> get props => [exams];
}

//*get-Exam-Questions
class GettingExamQuestions extends ExamState {
  const GettingExamQuestions();
}

class ExamQuestionsLoaded extends ExamState {
  const ExamQuestionsLoaded(this.questions);

  final List<ExamQuestion> questions;

  @override
  List<Object> get props => [questions];
}

//*upload-Exam
class UploadingExam extends ExamState {
  const UploadingExam();
}

class ExamUploaded extends ExamState {
  const ExamUploaded();
}

//*update-Exam
class UpdatingExam extends ExamState {
  const UpdatingExam();
}

class ExamUpdated extends ExamState {
  const ExamUpdated();
}

//*submit-Exam
class SubmittingExam extends ExamState {
  const SubmittingExam();
}

class ExamSubmitted extends ExamState {
  const ExamSubmitted();
}

//*get-User-Exams
class GettingUserExams extends ExamState {
  const GettingUserExams();
}

class UserExamsLoaded extends ExamState {
  const UserExamsLoaded(this.exams);

  final List<UserExam> exams;

  @override
  List<Object> get props => [exams];
}

//*get-User-Course-Exams
class GettingUserCourseExams extends ExamState {
  const GettingUserCourseExams();
}

class UserCourseExamsLoaded extends ExamState {
  const UserCourseExamsLoaded(this.exams);

  final List<UserExam> exams;

  @override
  List<Object> get props => [exams];
}

//*error
class ExamError extends ExamState {
  const ExamError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
