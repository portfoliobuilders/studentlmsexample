import 'dart:convert';

class Project {
  final int id;
  final String name;
  final String description;
  final DateTime deadline;
  final List<Lesson> lessonsToUnlock;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.deadline,
    required this.lessonsToUnlock,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    var list = json['lessons_to_unlock'] as List;
    List<Lesson> lessonsList = list.map((i) => Lesson.fromJson(i)).toList();

    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      deadline: DateTime.parse(json['deadline']),
      lessonsToUnlock: lessonsList,
    );
  }
}

class Lesson {
  final int id;
  final String url;
  final String docUrls;
  final int order;
  final String name;
  final String description;

  Lesson({
    required this.id,
    required this.url,
    required this.docUrls,
    required this.order,
    required this.name,
    required this.description,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      url: json['url'],
      docUrls: json['doc_urls'],
      order: json['order'],
      name: json['name'],
      description: json['description'],
    );
  }
}
