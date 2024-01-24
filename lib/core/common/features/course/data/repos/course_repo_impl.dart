import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/data/datasources/course_remote_datasource.dart';
import 'package:education_app/core/common/features/course/domain/entities/course.dart';
import 'package:education_app/core/common/features/course/domain/repos/course_repo.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/core/utils/typedefs.dart';

class CourseRepoImpl implements CourseRepo {
  const CourseRepoImpl(this._remoteDatasource);

  final CourseRemoteDatasource _remoteDatasource;

  @override
  ResultVoid addCourse(Course course) async {
    try {
      await _remoteDatasource.addCourse(course);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<Course>> getCourses() async {
    try {
      final result = await _remoteDatasource.getCourse();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
