import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/notifications/domain/repos/notification_repo.dart';
import 'package:flutter/material.dart';

class SendNotification
    extends FutureFutureUsecaseWithParams<void, Notification> {
  const SendNotification(this._repo);

  final NotificationRepo _repo;

  @override
  ResultVoid call(Notification params) => _repo.sendNotification(params);
}
