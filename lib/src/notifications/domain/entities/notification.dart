// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:education_app/core/enums/notification_enum.dart';
import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  const Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.categiry,
    required this.sentAt,
    this.seen = false,
  });

  final String id;
  final String title;
  final String body;
  final NotificationCategory categiry;
  final bool seen;
  final DateTime sentAt;

  @override
  List<Object?> get props => [id];
}
