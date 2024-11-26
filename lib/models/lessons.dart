import 'dart:convert';

class Lesson {
  final int id;
  final String name;
  final String description;
  final String url;
  final int order;
  final List<String> docUrls;

  Lesson({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.order,
    required this.docUrls,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      url: json['url'],
      order: json['order'],
      docUrls: List<String>.from(json['doc_urls'] != null ? json['doc_urls'].split(',') : []),
    );
  }

  static List<Lesson> fromJsonList(String str) {
    final jsonData = json.decode(str);
    final lessonsData = jsonData['data'];
    return List<Lesson>.from(lessonsData.map((x) => Lesson.fromJson(x)));
  }
}
