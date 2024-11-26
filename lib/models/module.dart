import 'dart:convert';

class Module {
  final int id;
  final int courseId;
  final int order;
  final String name;
  final String description;
  final DateTime createdOn;
  final DateTime updatedOn;

  Module({
    required this.id,
    required this.courseId,
    required this.order,
    required this.name,
    required this.description,
    required this.createdOn,
    required this.updatedOn,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      courseId: json['course_id'],
      order: json['order'],
      name: json['name'],
      description: json['description'],
      createdOn: DateTime.parse(json['created_on']),
      updatedOn: DateTime.parse(json['updated_on']),
    );
  }

  static List<Module> fromJsonList(String jsonString) {
    final List<dynamic> jsonData = json.decode(jsonString)['data'];
    return jsonData.map((json) => Module.fromJson(json)).toList();
  }
}
