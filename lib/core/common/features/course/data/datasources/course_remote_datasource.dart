import 'package:education_app/core/common/features/course/domain/entities/course.dart';

abstract class CourseRemoteDatasource {
  const CourseRemoteDatasource();

  Future<void> addCourse(Course course);

  Future<List<Course>> getCourse();
}

class CourseRemoteDatasourceImpl implements CourseRemoteDatasource {
  const CourseRemoteDatasourceImpl();

  @override
  Future<void> addCourse(Course course) {
    // TODO: implement addCourse
    throw UnimplementedError();
  }

  @override
  Future<List<Course>> getCourse() {
    // TODO: implement getCourse
    throw UnimplementedError();
  }
}
