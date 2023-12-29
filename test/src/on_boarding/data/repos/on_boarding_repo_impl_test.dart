import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:education_app/src/on_boarding/data/repos/on_boarding_repo_impl.dart';
import 'package:education_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingLocalDataSource extends Mock
    implements OnBoardingLocalDataSource {}

void main() {
  late OnBoardingLocalDataSource localDataSource;
  late OnBoardingRepoImpl repoImpl;

  setUp(() {
    localDataSource = MockOnBoardingLocalDataSource();
    repoImpl = OnBoardingRepoImpl(localDataSource);
  });

  test('should be a subclass of [OnBoardingRepo]', () async {
    //arrange
    //act
    expect(repoImpl, isA<OnBooardingRepo>());
    //assert
  });

  group('cacheFirstTimer', () {
    test(
        'should return [Right] successfully when call local source is successful',
        () async {
      //arrange
      when(() => localDataSource.cacheFirstTimer()).thenAnswer(
        (_) async => Future.value(),
      );

      //act
      final result = await repoImpl.cacheFirstTimer();

      expect(result, equals(const Right<dynamic, void>(null)));

      //assert
      verify(
        () => localDataSource.cacheFirstTimer(),
      ).called(1);
      verifyNoMoreInteractions(localDataSource);
    });

    test(
        'should return [CacheFailure] when call to local source is unsuccessfull',
        () async {
      //arrage
      when(
        () => localDataSource.cacheFirstTimer(),
      ).thenThrow(
        const CacheException(
          message: 'Insufficient storage',
        ),
      );

      //act
      final result = await repoImpl.cacheFirstTimer();

      expect(
        result,
        equals(
          Left<CacheFailure, dynamic>(
            CacheFailure(message: 'Insufficient storage', statusCode: 500),
          ),
        ),
      );
      //assert
      verify(
        () => localDataSource.cacheFirstTimer(),
      ).called(1);
      verifyNoMoreInteractions(localDataSource);
    });
  });

  group('checkIfUserIsFirstTime', () {
    test('should return [Right] successfully when call local source is successful', () async {
      when(() => localDataSource.checkIfUserIsFirstTimer(),).thenAnswer((_) =>  );
    });
    test('description', () => null);
  });
}
