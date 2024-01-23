import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/common/features/course/domain/entities/course.dart';
import 'package:education_app/core/utils/typedefs.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.title,
    required super.numberOfExams,
    required super.numberOfMaterials,
    required super.numberOfVideos,
    required super.groupId,
    required super.createdAt,
    required super.updatedAt,
    super.description,
    super.image,
    super.imageIsFile = false,
  });

  CourseModel.empty()
      : this(
          id: '',
          title: '',
          description: '',
          numberOfExams: 0,
          numberOfMaterials: 0,
          numberOfVideos: 0,
          groupId: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

//download
  CourseModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          title: map['title'] as String,
          description: map['description'] as String?,
          groupId: map['groupId'] as String,
          numberOfExams: (map['numberOfExams'] as num).toInt(),
          numberOfMaterials: (map['numberOfMaterials'] as num).toInt(),
          numberOfVideos: (map['numberOfVideos'] as num).toInt(),
          createdAt: (map['createdAt'] as Timestamp).toDate(),
          updatedAt: (map['updatedAt'] as Timestamp).toDate(),
          image: map['image'] as String?,
        );

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    String? groupId,
    int? numberOfExams,
    int? numberOfMaterials,
    int? numberOfVideos,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? image,
    bool? imageIsFile,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      groupId: groupId ?? this.groupId,
      numberOfExams: numberOfExams ?? this.numberOfExams,
      numberOfMaterials: numberOfMaterials ?? this.numberOfMaterials,
      numberOfVideos: numberOfVideos ?? this.numberOfVideos,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      image: image ?? this.image,
      imageIsFile: imageIsFile ?? this.imageIsFile,
    );
  }

//upload
  DataMap toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'groupId': groupId,
        'numberOfExams': numberOfExams,
        'numberOfMaterials': numberOfMaterials,
        'numberOfVideos': numberOfVideos,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'image': image,
      };
}
