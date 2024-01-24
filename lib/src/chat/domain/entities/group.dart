import 'package:equatable/equatable.dart';

class Group extends Equatable {
  const Group({
    required this.id,
    required this.name,
    required this.courseId,
    required this.members,
    this.lastMessage,
    this.groupImageUrl,
    this.lastMessageTimestamp,
    this.lastMessageSenderName,
  });

  Group.empty()
      : this(
          id: '',
          name: '',
          courseId: '',
          members: const [],
          lastMessage: null,
          groupImageUrl: '',
          lastMessageTimestamp: DateTime.now(),
          lastMessageSenderName: '',
        );

  final String id;
  final String name;
  final String courseId;
  final List<String> members;
  final String? lastMessage;
  final String? groupImageUrl;
  final DateTime? lastMessageTimestamp;
  final String? lastMessageSenderName;

  @override
  List<Object?> get props => [id, name, courseId];
}
