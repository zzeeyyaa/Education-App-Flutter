import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/domain/repos/course_repo.dart';

class GetCourse extends UsecaseWithoutParams<List<Course>> {
  const GetCourse(this._repo);

  final CourseRepo _repo;

  @override
  ResultFuture<List<Course>> call() {
    return _repo.getCourses();
  }
}
