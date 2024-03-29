import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/features/materials/domain/entities/resource.dart';

abstract class MaterialRepo {
  const MaterialRepo();

  ResultFuture<List<Resource>> getMaterials(String courseId);

  ResultVoid addMaterial(Resource material);
}
