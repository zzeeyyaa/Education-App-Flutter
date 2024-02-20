import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:education_app/src/course/features/materials/domain/repos/material_repo.dart';
import 'package:education_app/src/course/features/materials/domain/usecases/add_material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'material_repo.mock.dart';

void main() {
  late MaterialRepo repo;
  late AddMaterial usecase;

  // const tCourseId = 'courseId test';

  final tResource = Resource.empty();

  setUp(() {
    repo = MockMaterialRepo();
    usecase = AddMaterial(repo);
    registerFallbackValue(tResource);
  });

  test('should call MaterialRepo.addMaterial', () async {
    when(() => repo.addMaterial(any()))
        .thenAnswer((invocation) async => const Right(null));

    final result = await usecase(tResource);

    expect(result, equals(const Right<Failure, void>(null)));

    verify(() => repo.addMaterial(tResource)).called(1);

    verifyNoMoreInteractions(repo);
  });
}
