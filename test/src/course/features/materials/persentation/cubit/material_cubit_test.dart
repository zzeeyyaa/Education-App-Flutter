import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/course/features/materials/data/models/resource_model.dart';
import 'package:education_app/src/course/features/materials/domain/usecases/add_material.dart';
import 'package:education_app/src/course/features/materials/domain/usecases/get_materials.dart';
import 'package:education_app/src/course/features/materials/persentation/cubit/material_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddMaterial extends Mock implements AddMaterial {}

class MockGetMaterials extends Mock implements GetMaterials {}

void main() {
  late AddMaterial addMaterial;
  late GetMaterials getMaterials;
  late MaterialCubit cubit;

  final tMaterial = ResourceModel.empty();

  setUp(() {
    addMaterial = MockAddMaterial();
    getMaterials = MockGetMaterials();
    cubit = MaterialCubit(
      addMaterial: addMaterial,
      getMaterials: getMaterials,
    );
    registerFallbackValue(tMaterial);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be [MaterialInitial]', () async {
    expect(cubit.state, const MaterialInitial());
  });

  group('addMaterial', () {
    blocTest<MaterialCubit, MaterialState>(
      'emits [AddingMaterials, MaterialsAdded] when addMaterial is added.',
      build: () {
        when(() => addMaterial(any()))
            .thenAnswer((invocation) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.addMaterial([tMaterial]),
      expect: () => const <MaterialState>[
        AddingMaterial(),
        MaterialAdded(),
      ],
      verify: (_) {
        verify(() => addMaterial(tMaterial)).called(1);
        verifyNoMoreInteractions(addMaterial);
      },
    );
    blocTest<MaterialCubit, MaterialState>(
      'emits [MyState] when MyEvent is added.',
      build: () {
        when(() => addMaterial(any())).thenAnswer((invocation) async => Left(
              ServerFailure(message: 'Server Failure', statusCode: 500),
            ));
        return cubit;
      },
      act: (cubit) => cubit.addMaterial([tMaterial]),
      expect: () => const <MaterialState>[
        AddingMaterial(),
        MaterialError('500 Error : Server Failure'),
      ],
      verify: (_) {
        verify(() => addMaterial(tMaterial)).called(1);
        verifyNoMoreInteractions(addMaterial);
      },
    );
  });

  group('getMaterials', () {
    blocTest<MaterialCubit, MaterialState>(
      'emits [MyState] when MyEvent is added.',
      build: () {
        when(() => getMaterials(any()))
            .thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.getMaterials(tMaterial.courseId),
      expect: () => const <MaterialState>[
        LoadingMaterials(),
        MaterialsLoaded([]),
      ],
      verify: (_) {
        verify(() => getMaterials(tMaterial.courseId)).called(1);

        verifyNoMoreInteractions(getMaterials);
      },
    );
    blocTest<MaterialCubit, MaterialState>(
      'emits [MyState] when MyEvent is added.',
      build: () {
        when(() => getMaterials(any())).thenAnswer(
          (_) async => Left(
            ServerFailure(message: 'Server Failure', statusCode: 500),
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.getMaterials(tMaterial.courseId),
      expect: () => const <MaterialState>[
        LoadingMaterials(),
        MaterialError('500 Error : Server Failure'),
      ],
      verify: (_) {
        verify(() => getMaterials(tMaterial.courseId)).called(1);
        verifyNoMoreInteractions(getMaterials);
      },
    );
  });
}
