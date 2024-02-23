import 'package:education_app/core/utils/typedefs.dart';
import 'package:flutter/material.dart';

abstract class NotificationRepo {
  const NotificationRepo();

  ResultVoid markAsRead(String notificationId);

  ResultVoid clearAll();

  ResultVoid clear(String notificationId);

  ResultVoid sendNotification(Notification notification);

  ResultStream<List<Notification>> getNotifications();
}
