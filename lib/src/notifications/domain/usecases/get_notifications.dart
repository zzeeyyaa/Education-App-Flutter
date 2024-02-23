import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/notifications/domain/repos/notification_repo.dart';
import 'package:flutter/material.dart';

class GetNotifications
    extends StreamFutureUsecaseWithoutParams<List<Notification>> {
  const GetNotifications(this._repo);

  final NotificationRepo _repo;

  @override
  ResultStream<List<Notification>> call() {
    return _repo.getNotifications();
  }
}
