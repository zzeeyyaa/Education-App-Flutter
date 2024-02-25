import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:education_app/src/notifications/domain/entities/notification.dart';
import 'package:education_app/src/notifications/domain/repos/notification_repo.dart';

class NotificationRepoImpl implements NotificationRepo {
  const NotificationRepoImpl(this._remoteDatasource);

  final NotificationRemoteDatasource _remoteDatasource;

  @override
  ResultFuture<void> clear(String notificationId) {
    // TODO: implement clear
    throw UnimplementedError();
  }

  @override
  ResultFuture<void> clearAll() {
    // TODO: implement clearAll
    throw UnimplementedError();
  }

  @override
  ResultStream<List<Notification>> getNotifications() {
    // TODO: implement getNotifications
    throw UnimplementedError();
  }

  @override
  ResultFuture<void> markAsRead(String notificationId) {
    // TODO: implement markAsRead
    throw UnimplementedError();
  }

  @override
  ResultFuture<void> sendNotification(Notification notification) {
    // TODO: implement sendNotification
    throw UnimplementedError();
  }
}
