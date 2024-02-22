import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/course/features/exams/data/datasources/exam_remote_datasource.dart';
import 'package:education_app/src/course/features/exams/data/models/exam_model.dart';
import 'package:education_app/src/course/features/exams/data/models/user_exam_model.dart';
import 'package:education_app/src/course/features/exams/data/repos/exam_repo_impl.dart';
import 'package:education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/src/course/features/exams/domain/entities/exam_question.dart';
import 'package:education_app/src/course/features/exams/domain/entities/user_exam.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockExamRemoteDatasource extends Mock implements ExamRemoteDatasource {}

void main() {
  late ExamRepoImpl repoImpl;
  late ExamRemoteDatasource remoteDatasource;

  const tExamModel = ExamModel.empty();
  final tUserExamModel = UserExamModel.empty();

  setUp(() {
    remoteDatasource = MockExamRemoteDatasource();
    repoImpl = ExamRepoImpl(remoteDatasource);
    registerFallbackValue(tExamModel);
    registerFallbackValue(tUserExamModel);
  });

  const tException = ServerException(
    message: 'Test message',
    statusCode: '500',
  );

  group('getExamQuestions', () {
    test(
        'shsould return [List<ExamQuestions>] when call remoteDatasource successful',
        () async {
      when(() => remoteDatasource.getExamQuestions(any()))
          .thenAnswer((_) async => []);

      final result = await repoImpl.getExamQuestions(tExamModel);

      expect(result, isA<Right<dynamic, List<ExamQuestion>>>());

      verify(() => remoteDatasource.getExamQuestions(tExamModel)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
    test(
        'should return ServerFailure when call to remotedatasource unsuccessful',
        () async {
      when(() => remoteDatasource.getExamQuestions(any()))
          .thenThrow(tException);

      final result = await repoImpl.getExamQuestions(tExamModel);

      expect(
        result,
        Left<ServerFailure, List<ExamQuestion>>(
          ServerFailure.fromException(tException),
        ),
      );

      verify(() => remoteDatasource.getExamQuestions(tExamModel)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });

  group('getExam', () {
    test('should return [List<Exam>] when call remoteDatasource is success',
        () async {
      when(() => remoteDatasource.getExams(any()))
          .thenAnswer((invocation) async => []);

      final result = await repoImpl.getExams(tExamModel.courseId);

      expect(result, isA<Right<dynamic, List<Exam>>>());

      verify(() => remoteDatasource.getExams(tExamModel.courseId)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
    test('should return ServerFailure when call remoteDatasource unsuccessful',
        () async {
      when(() => remoteDatasource.getExams(any())).thenThrow(tException);

      final result = await repoImpl.getExams(tExamModel.courseId);

      expect(
        result,
        Left<ServerFailure, List<Exam>>(
          ServerFailure.fromException(tException),
        ),
      );

      verify(() => remoteDatasource.getExams(tExamModel.courseId)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });

  group('getCourseExam', () {
    test('should return List of userExam when call remoteDatasource is success',
        () async {
      when(() => remoteDatasource.getUserCourseExams(any()))
          .thenAnswer((_) async => []);

      final result = await repoImpl.getUserCourseExams(tExamModel.courseId);

      expect(result, isA<Right<dynamic, List<UserExam>>>());

      verify(() => remoteDatasource.getUserCourseExams(tExamModel.courseId))
          .called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
    test('should return ServerFailure when call remoteDatasource is fail',
        () async {
      when(() => remoteDatasource.getUserCourseExams(any()))
          .thenThrow(tException);

      final result = await repoImpl.getUserCourseExams(tExamModel.courseId);

      expect(
          result,
          Left<ServerFailure, List<UserExam>>(
              ServerFailure.fromException(tException)));

      verify(() => remoteDatasource.getUserCourseExams(tExamModel.courseId))
          .called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });
  group('getUserExams', () {
    test('should return List<UserExam> when call remtoeDatasource is success',
        () async {
      when(() => remoteDatasource.getUserExams()).thenAnswer((_) async => []);

      final result = await repoImpl.getUserExams();

      expect(result, isA<Right<dynamic, List<UserExam>>>());

      verify(() => remoteDatasource.getUserExams());

      verifyNoMoreInteractions(remoteDatasource);
    });
    test('should return ServerFailure when ', () async {
      when(() => remoteDatasource.getUserExams()).thenThrow(tException);

      final result = await repoImpl.getUserExams();

      expect(
          result,
          Left<ServerFailure, List<UserExam>>(
              ServerFailure.fromException(tException)));

      verify(() => remoteDatasource.getUserExams()).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });
  group('submitExam', () {
    test('should return void when call remoteDatasource is success', () async {
      when(() => remoteDatasource.submitExam(any()))
          .thenAnswer((_) async => const Right<dynamic, void>(null));

      final result = await repoImpl.submitExam(tUserExamModel);

      expect(result, isA<Right<dynamic, void>>());

      verify(() => remoteDatasource.submitExam(tUserExamModel)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
    test('should return ServerFailure when call remoteDataSource is failed',
        () async {
      when(() => remoteDatasource.submitExam(any())).thenThrow(tException);

      final result = await repoImpl.submitExam(tUserExamModel);

      expect(result,
          Left<ServerFailure, void>(ServerFailure.fromException(tException)));

      verify(() => remoteDatasource.submitExam(tUserExamModel)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });

  group('updateExam', () {
    test('should return void when call remoteDatasource success', () async {
      when(() => remoteDatasource.updateExam(any()))
          .thenAnswer((invocation) async => const Right<dynamic, void>(null));

      final result = await repoImpl.updateExam(tExamModel);

      expect(result, isA<Right<dynamic, void>>());

      verify(() => remoteDatasource.updateExam(tExamModel)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
    test('should return ServerFailure when call remoteDatasource is failed',
        () async {
      when(() => remoteDatasource.updateExam(any())).thenThrow(tException);

      final result = await repoImpl.updateExam(tExamModel);

      expect(result,
          Left<ServerFailure, void>(ServerFailure.fromException(tException)));

      verify(() => remoteDatasource.updateExam(tExamModel));

      verifyNoMoreInteractions(remoteDatasource);
    });
  });
  group('uploadExam', () {
    test('should return void when call remoteDatasource is success', () async {
      when(() => remoteDatasource.uploadExam(any()))
          .thenAnswer((_) async => const Right<dynamic, void>(null));

      final result = await repoImpl.uploadExam(tExamModel);

      expect(result, isA<Right<dynamic, void>>());

      verify(() => remoteDatasource.uploadExam(tExamModel)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
    test('should return ServerFailure when call remtoeDatasource is failed',
        () async {
      when(() => remoteDatasource.uploadExam(any())).thenThrow(tException);

      final result = await repoImpl.uploadExam(tExamModel);

      expect(result,
          Left<ServerFailure, void>(ServerFailure.fromException(tException)));

      verify(() => remoteDatasource.uploadExam(tExamModel)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });
}
