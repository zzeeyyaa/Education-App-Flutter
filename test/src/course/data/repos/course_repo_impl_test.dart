import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/course/data/datasources/course_remote_datasource.dart';
import 'package:education_app/src/course/data/models/course_model.dart';
import 'package:education_app/src/course/data/repos/course_repo_impl.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCourseRemoteDatasource extends Mock
    implements CourseRemoteDatasource {}

void main() {
  late CourseRemoteDatasource remoteDatasource;
  late CourseRepoImpl repoImpl;

  final tCourse = CourseModel.empty();

  setUp(() {
    remoteDatasource = MockCourseRemoteDatasource();
    repoImpl = CourseRepoImpl(remoteDatasource);
    registerFallbackValue(tCourse);
  });

  const tException = ServerException(
    message: 'Something went wring',
    statusCode: '500',
  );

  group('getCourse', () {
    test(
        'should call [CourseRemoteDatasouce.getCourse]'
        ' when success return [List<Course>]', () async {
      when(() => remoteDatasource.getCourse())
          .thenAnswer((_) async => [tCourse]);

      final result = await repoImpl.getCourses();

      expect(result, isA<Right<dynamic, List<Course>>>());

      verify(() => remoteDatasource.getCourse()).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
    test(
        'should return [ServerFailure] when'
        ' unsuccess call [SourseRemoteDatasource.getSourse]', () async {
      when(() => remoteDatasource.getCourse()).thenThrow(tException);

      final result = await repoImpl.getCourses();

      expect(
        result,
        Left<Failure, void>(ServerFailure.fromException(tException)),
      );

      verify(() => remoteDatasource.getCourse()).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });
  group('addCourse', () {
    test(
        'should call [CourseRemoteDatsource.addCourse]'
        ' when success then return void', () async {
      when(() => remoteDatasource.addCourse(any()))
          .thenAnswer((_) => Future.value());

      final result = await repoImpl.addCourse(tCourse);

      expect(result, const Right<Failure, void>(null));

      verify(() => remoteDatasource.addCourse(tCourse)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
    test(
        'should return [ServerFailure] when unsuccess'
        ' call [CourseRemoteDatasource]', () async {
      when(() => remoteDatasource.addCourse(any())).thenThrow(tException);

      final result = await repoImpl.addCourse(tCourse);

      expect(
        result,
        Left<Failure, void>(ServerFailure.fromException(tException)),
      );

      verify(() => remoteDatasource.addCourse(tCourse)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });
}
