import 'package:education_app/core/utils/typedefs.dart';

abstract class FutureUsecaseWithoutParams<Type> {
  const FutureUsecaseWithoutParams();

  ResultFuture<Type> call();
}

abstract class FutureUsecaseWithParams<Type, Params> {
  const FutureUsecaseWithParams();

  ResultFuture<Type> call(Params params);
}

abstract class StreamFutureUsecaseWithoutParams<Type> {
  const StreamFutureUsecaseWithoutParams();

  ResultStream<Type> call();
}
