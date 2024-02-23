import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/notifications/domain/repos/notification_repo.dart';

class ClearAll extends FutureFutureUsecaseWithoutParams<void> {
  const ClearAll(this._repo);

  final NotificationRepo _repo;

  @override
  ResultVoid call() => _repo.clearAll();
}
