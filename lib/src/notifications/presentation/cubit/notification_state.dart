part of 'notification_cubit.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

final class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

//*clear & clearAll
class ClearingNotifications extends NotificationState {
  const ClearingNotifications();
}

//*getNotification
class GettingNotifications extends NotificationState {
  const GettingNotifications();
}

class NotificationsLoaded extends NotificationState {
  const NotificationsLoaded(this.notifications);

  final List<Notification> notifications;

  @override
  List<Object> get props => notifications;
}

//*sendNotification
class SendingNotification extends NotificationState {
  const SendingNotification();
}

class NotificationSent extends NotificationState {
  const NotificationSent();
}

//*error
class NotificationError extends NotificationState {
  const NotificationError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
