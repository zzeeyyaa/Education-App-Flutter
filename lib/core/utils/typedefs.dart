import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef ResultVoid = ResultFuture<void>;

typedef DataMap = Map<String, dynamic>;
