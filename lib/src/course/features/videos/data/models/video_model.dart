import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';

class VideoModel extends Video {
  const VideoModel({
    required super.id,
    required super.videoURL,
    required super.courseId,
    required super.uploadDate,
    super.thumbnailIsFile = false,
    super.thumbnail,
    super.title,
    super.tutor,
  });

  VideoModel.empty()
      : this(
          id: '',
          thumbnail: null,
          videoURL: '',
          title: null,
          tutor: null,
          courseId: '',
          uploadDate: DateTime.now(),
          thumbnailIsFile: false,
        );

  VideoModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          title: map['title'] as String?,
          thumbnail: map['thumbnail'] as String?,
          videoURL: map['videoURL'] as String,
          tutor: map['tutor'] as String?,
          courseId: map['courseId'] as String,
          uploadDate: (map['uploadDate'] as Timestamp).toDate(),
          thumbnailIsFile: map['thumbnailIsFile'] as bool,
        );

  VideoModel copyWith({
    String? id,
    String? thumbnail,
    String? videoURL,
    String? title,
    String? tutor,
    String? courseId,
    DateTime? uploadDate,
    bool? thumbnailIsFile,
  }) {
    return VideoModel(
      id: id ?? this.id,
      videoURL: videoURL ?? this.videoURL,
      courseId: courseId ?? this.courseId,
      uploadDate: uploadDate ?? this.uploadDate,
      title: title ?? this.title,
      tutor: tutor ?? this.tutor,
      thumbnail: thumbnail ?? this.thumbnail,
      thumbnailIsFile: thumbnailIsFile ?? this.thumbnailIsFile,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'videoURL': videoURL,
      'title': title,
      'courseId': courseId,
      'uploadDate': FieldValue.serverTimestamp(),
      'tutor': tutor,
      'thumbnail': thumbnail,
      'thumbnailIsFile': thumbnailIsFile,
    };
  }
}
