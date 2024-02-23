import 'package:education_app/core/utils/typedefs.dart';

abstract class FutureFutureUsecaseWithoutParams<Type> {
  const FutureFutureUsecaseWithoutParams();

  ResultFuture<Type> call();
}

abstract class FutureFutureUsecaseWithParams<Type, Params> {
  const FutureFutureUsecaseWithParams();

  ResultFuture<Type> call(Params params);
}

abstract class StreamFutureUsecaseWithoutParams<Type> {
  const StreamFutureUsecaseWithoutParams();

  ResultStream<Type> call();
}
