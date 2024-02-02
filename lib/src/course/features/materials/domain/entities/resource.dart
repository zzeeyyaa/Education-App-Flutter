import 'package:equatable/equatable.dart';

class Resource extends Equatable {
  const Resource({
    required this.id,
    required this.courseId,
    required this.uploadedDate,
    required this.fileURL,
    required this.isFile,
    required this.fileExtension,
    this.title,
    this.author,
    this.description,
  });

  Resource.empty([DateTime? date])
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

  final String id;
  final String courseId;
  final DateTime uploadedDate;
  final String fileURL;
  final String fileExtension;
  final bool isFile;
  final String? title;
  final String? author;
  final String? description;

  @override
  List<Object?> get props => [id, courseId];
}
