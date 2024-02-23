import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:education_app/src/course/features/materials/domain/repos/material_repo.dart';

class AddMaterial extends FutureUsecaseWithParams<void, Resource> {
  const AddMaterial(this._materialRepo);

  final MaterialRepo _materialRepo;

  @override
  ResultFuture<void> call(Resource params) {
    return _materialRepo.addMaterial(params);
  }
}
