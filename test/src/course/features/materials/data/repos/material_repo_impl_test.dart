import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/course/features/materials/data/datasources/material_remote_datasource.dart';
import 'package:education_app/src/course/features/materials/data/models/resource_model.dart';
import 'package:education_app/src/course/features/materials/data/repos/material_repo_impl.dart';
import 'package:education_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMaterialRemoteDatasource extends Mock
    implements MaterialRemoteDatasource {}

void main() {
  late MaterialRemoteDatasource remoteDatasource;
  late MaterialRepoImpl repoImpl;

  final tResourceModel = ResourceModel.empty();

  setUp(() {
    remoteDatasource = MockMaterialRemoteDatasource();
    repoImpl = MaterialRepoImpl(remoteDatasource);
    registerFallbackValue(tResourceModel);
  });

  const tException = ServerException(
    message: 'Failed ',
    statusCode: '404',
  );

  group('addMaterial', () {
    test('return null if success call remoteDatasource', () async {
      when(() => remoteDatasource.adddMaterial(any()))
          .thenAnswer((_) async => Future.value());

      final result = await repoImpl.addMaterial(tResourceModel);

      expect(result, equals(const Right<Failure, void>(null)));

      verify(() => remoteDatasource.adddMaterial(tResourceModel)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
    test('should return serverFailure if failed call remoteDatasource',
        () async {
      when(() => remoteDatasource.adddMaterial(any())).thenThrow(tException);

      final result = await repoImpl.addMaterial(tResourceModel);

      expect(
        result,
        equals(
          Left<Failure, void>(
            ServerFailure.fromException(tException),
          ),
        ),
      );

      verify(() => remoteDatasource.adddMaterial(tResourceModel)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });

  group('getMaterials', () {
    test('should return List of Resource if success call remoteDatasource',
        () async {
      when(() => remoteDatasource.getMaterials(any()))
          .thenAnswer((invocation) async => Future.value([]));

      final result = await repoImpl.getMaterials(tResourceModel.courseId);

      expect(result, isA<Right<dynamic, List<Resource>>>());

      verify(() => remoteDatasource.getMaterials(tResourceModel.courseId))
          .called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
    test('should return serverFailure if failed call remoteDatasource',
        () async {
      when(() => remoteDatasource.getMaterials(any())).thenThrow(tException);

      final result = await repoImpl.getMaterials(tResourceModel.courseId);

      expect(
        result,
        equals(
          Left<dynamic, List<Resource>>(
            ServerFailure.fromException(tException),
          ),
        ),
      );

      verify(() => remoteDatasource.getMaterials(tResourceModel.courseId))
          .called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });
}
