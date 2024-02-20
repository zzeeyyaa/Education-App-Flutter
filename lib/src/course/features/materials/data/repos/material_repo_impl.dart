import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/features/materials/data/datasources/material_remote_datasource.dart';
import 'package:education_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:education_app/src/course/features/materials/domain/repos/material_repo.dart';

class MaterialRepoImpl implements MaterialRepo {
  const MaterialRepoImpl(this._remoteDatasource);

  final MaterialRemoteDatasource _remoteDatasource;

  @override
  ResultVoid addMaterial(Resource resource) async {
    try {
      await _remoteDatasource.adddMaterial(resource);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Resource>> getMaterials(String courseId) async {
    try {
      final result = await _remoteDatasource.getMaterials(courseId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
