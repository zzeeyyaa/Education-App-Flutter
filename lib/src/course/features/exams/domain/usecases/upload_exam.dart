import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/src/course/features/exams/domain/repos/exam_repo.dart';

class UploadExam extends UsecaseWithParams<void, Exam> {
  const UploadExam(this._repo);

  final ExamRepo _repo;

  @override
  ResultFuture<void> call(Exam params) {
    return _repo.uploadExam(params);
  }
}
