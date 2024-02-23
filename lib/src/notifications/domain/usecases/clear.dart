import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/notifications/domain/repos/notification_repo.dart';

class Clear extends FutureFutureUsecaseWithParams<void, String> {
  const Clear(this._repo);

  final NotificationRepo _repo;

  @override
  ResultVoid call(String params) => _repo.clear(params);
}
