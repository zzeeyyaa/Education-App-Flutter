import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo.mock.dart';

void main() {
  late CacheFirstTimer usecase;
  late OnBooardingRepo repo;

  setUp(() {
    repo = MockOnBoardingRepo();
    usecase = CacheFirstTimer(repo);
  });
  test('should call [OnBoardingRepo.cacheFirstTimer] return the right data',
      () async {
    //arrange
    when(
      () => repo.cacheFirstTimer(),
    ).thenAnswer(
      (_) async => Left(
        ServerFailure(message: 'Unknown Error Occured', statusCode: 500),
      ),
    );
    //act
    final result = await usecase();

    expect(
      result,
      equals(
        Left<Failure, dynamic>(
          ServerFailure(message: 'Unknown Error Occured', statusCode: 500),
        ),
      ),
    );

    //assert
    verify(
      () => repo.cacheFirstTimer(),
    ).called(1);

    verifyNoMoreInteractions(repo);
  });
}
