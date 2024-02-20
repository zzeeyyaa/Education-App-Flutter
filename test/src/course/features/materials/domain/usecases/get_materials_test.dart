import 'package:dartz/dartz.dart';
import 'package:education_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:education_app/src/course/features/materials/domain/repos/material_repo.dart';
import 'package:education_app/src/course/features/materials/domain/usecases/get_materials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'material_repo.mock.dart';

void main() {
  late MaterialRepo repo;
  late GetMaterials usecase;

  final tResource = Resource.empty();

  setUp(() {
    repo = MockMaterialRepo();
    usecase = GetMaterials(repo);
    registerFallbackValue(tResource);
  });

  test('should call MaterialRepo.getMaterials', () async {
    when(() => repo.getMaterials(any()))
        .thenAnswer((invocation) async => const Right([]));

    final result = await usecase(tResource.courseId);

    expect(result, isA<Right<dynamic, List<Resource>>>());

    verify(() => repo.getMaterials(tResource.courseId)).called(1);

    verifyNoMoreInteractions(repo);
  });
}
