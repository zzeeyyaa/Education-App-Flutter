import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/features/materials/domain/entities/resource.dart';

class ResourceModel extends Resource {
  const ResourceModel({
    required super.id,
    required super.courseId,
    required super.uploadedDate,
    required super.fileURL,
    required super.isFile,
    required super.fileExtension,
    super.title,
    super.author,
    super.description,
  });

  ResourceModel.empty([DateTime? date])
      : this(
          id: '',
          title: '',
          description: '',
          uploadedDate: date ?? DateTime.now(),
          fileExtension: '',
          isFile: true,
          courseId: '',
          fileURL: '',
          author: '',
        );
  ResourceModel.fromMap(DataMap map)
      : super(
          id: map['id'] as String,
          title: map['title'] as String?,
          description: map['description'] as String?,
          uploadedDate: (map['uploadedDate'] as Timestamp).toDate(),
          fileExtension: map['fileExtension'] as String,
          isFile: map['isFile'] as bool,
          courseId: map['courseId'] as String,
          fileURL: map['fileURL'] as String,
          author: map['author'] as String?,
        );

  ResourceModel copyWith({
    String? id,
    String? courseId,
    DateTime? uploadedDate,
    String? fileURL,
    bool? isFile,
    String? fileExtension,
    String? title,
    String? author,
    String? description,
  }) {
    return ResourceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      courseId: courseId ?? this.courseId,
      uploadedDate: uploadedDate ?? this.uploadedDate,
      fileURL: fileURL ?? this.fileURL,
      isFile: isFile ?? this.isFile,
      author: author ?? this.author,
      fileExtension: fileExtension ?? this.fileExtension,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'title': title,
      'courseId': courseId,
      'description': description,
      'uploadedDate': uploadedDate,
      'isFile': isFile,
      'fileURL': fileURL,
      'fileExtension': fileExtension,
      'author': author,
    };
  }
}
