import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/chat/domain/entities/group.dart';

class GroupModel extends Group {
  const GroupModel({
    required super.id,
    required super.name,
    required super.courseId,
    required super.members,
    super.groupImageUrl,
    super.lastMessage,
    super.lastMessageSenderName,
    super.lastMessageTimestamp,
  });

  GroupModel.empty()
      : this(
          id: '',
          name: '',
          courseId: '',
          members: const [],
          groupImageUrl: '',
          lastMessage: null,
          lastMessageSenderName: '',
          lastMessageTimestamp: DateTime.now(),
        );

  GroupModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          name: map['name'] as String,
          courseId: map['courseId'] as String,
          members: List<String>.from(map['members'] as List<dynamic>),

          /// or
          /// members: (map['members] as List<dynamic>).cast<String>(),
          /// or
          /// members: (map['members] as List<dynamic>.map((e)=>e as String)
          /// .toList(),
          lastMessage: map['lastMessage'] as String?,
          lastMessageSenderName: map['LastMessageSender'] as String?,
          lastMessageTimestamp:
              (map['lastMessageTimestamp'] as Timestamp?)?.toDate(),
          groupImageUrl: map['groupImageUrl'] as String?,
        );

  GroupModel copyWith({
    String? id,
    String? name,
    String? courseId,
    List<String>? members,
    DateTime? lastMessageTimestamp,
    String? lastMessageSenderName,
    String? lastMessage,
    String? groupImageUrl,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      courseId: courseId ?? this.courseId,
      members: members ?? this.members,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      lastMessageSenderName: lastMessageSenderName ?? lastMessageSenderName,
      lastMessage: lastMessage ?? this.lastMessage,
      groupImageUrl: groupImageUrl ?? groupImageUrl,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'name': name,
      'courseId': courseId,
      'members': members,
      'lastMessageTimestamp': lastMessageTimestamp,
      'lastMessageSenderName': lastMessageSenderName,
      'lastMessage': lastMessage == null ? null : FieldValue.serverTimestamp(),
      'groupImageUrl': groupImageUrl,
    };
  }
}
