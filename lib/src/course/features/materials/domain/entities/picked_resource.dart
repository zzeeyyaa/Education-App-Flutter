import 'package:equatable/equatable.dart';

class PickedResource extends Equatable {
  const PickedResource({
    required this.path,
    required this.title,
    required this.author,
    this.description = '',
    this.authorManuallySet = false,
  });

  final String path;
  final String title;
  final String author;
  final String description;
  final bool authorManuallySet;

  PickedResource copyWith({
    String? path,
    String? title,
    String? author,
    String? description,
    bool? authorManuallySet,
  }) {
    return PickedResource(
      path: path ?? this.path,
      title: title ?? this.title,
      author: author ?? this.author,
      authorManuallySet: authorManuallySet ?? this.authorManuallySet,
    );
  }

  @override
  List<Object?> get props => [path];
}
