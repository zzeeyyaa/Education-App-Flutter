import 'package:education_app/core/utils/typedefs.dart';

abstract class OnBooardingRepo {
  const OnBooardingRepo();

  ResultVoid cacheFirstTimer();
  ResultFuture<bool> checkIfUserIsFirstTimer();
}
