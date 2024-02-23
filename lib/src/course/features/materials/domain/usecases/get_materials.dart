import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:education_app/src/course/features/materials/domain/repos/material_repo.dart';

class GetMaterials extends FutureUsecaseWithParams<List<Resource>, String> {
  const GetMaterials(this._materialRepo);

  final MaterialRepo _materialRepo;

  @override
  ResultFuture<List<Resource>> call(String params) {
    return _materialRepo.getMaterials(params);
  }
}
