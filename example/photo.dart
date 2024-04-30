import 'dart:convert';

final class Photo {
  final int id;
  final String title;
  final String thumbnailUrl;

  const Photo({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
  });

  factory Photo.initial() {
    return const Photo(
      id: 1,
      title: 'title',
      thumbnailUrl: 'thumbnailUrl',
    );
  }

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as int,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }

  @override
  String toString() =>
      'Photo(id: $id, title: $title, thumbnailUrl: $thumbnailUrl)';
}

extension PhotoExtension on Photo {
  static List<Photo> parsePhotos(String responseBody) {
    final jsonObject = jsonDecode(responseBody) as Iterable;
    return jsonObject
        .map<Photo>(
          (json) => Photo.fromJson(
            Map<String, dynamic>.from(json as Map<String, dynamic>),
          ),
        )
        .toList();
  }
}
