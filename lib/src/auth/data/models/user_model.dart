import 'dart:convert';

import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.uid,
    required super.email,
    required super.points,
    required super.fullName,
    super.bio,
    super.enrolledCourseIds,
    super.followers,
    super.following,
    super.groupIds,
    super.profilePic,
  });

  const LocalUserModel.empty()
      : this(
          uid: '',
          email: '',
          points: 0,
          fullName: '',
        );

  LocalUserModel.fromMap(DataMap map)
      : this(
          uid: map['uid'] as String,
          email: map['email'] as String,
          points: (map['points'] as num).toInt(),
          fullName: map['fullName'] as String,
          bio: map['bio'] as String?,
          profilePic: map['profilePic'] as String?,
          enrolledCourseIds:
              (map['enrolledCourseIds'] as List<dynamic>).cast<String>(),
          groupIds: (map['groupIds'] as List<dynamic>).cast<String>(),
          following: (map['following'] as List<dynamic>).cast<String>(),
          followers: (map['followers'] as List<dynamic>).cast<String>(),
        );

  // factory LocalUserModel.fromJson(String source) =>
  //     LocalUserModel.fromMap(jsonEncode(source) as DataMap);

  LocalUserModel copyWith({
    String? uid,
    String? email,
    int? points,
    String? fullName,
    String? bio,
    String? profilePic,
    List<String>? groupIds,
    List<String>? enrolledCourseIds,
    List<String>? following,
    List<String>? followers,
  }) {
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      points: points ?? this.points,
      fullName: fullName ?? this.fullName,
      bio: bio ?? this.bio,
      profilePic: profilePic ?? this.profilePic,
      groupIds: groupIds ?? this.groupIds,
      enrolledCourseIds: enrolledCourseIds ?? this.enrolledCourseIds,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }

  DataMap toMap() => {
        'uid': uid,
        'email': email,
        'points': points,
        'fullName': fullName,
        'bio': bio,
        'profilePic': profilePic,
        'enrolledCourseIds': enrolledCourseIds,
        'groupIds': groupIds,
        'following': following,
        'followers': followers,
      };
}
