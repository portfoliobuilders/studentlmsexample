class Course {
  final int id;
  final String name;
  final String description;
  final int duration;
  final String price;
  final DateTime createdOn;
  final DateTime updatedOn;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
    required this.createdOn,
    required this.updatedOn, required String imageUrl,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      duration: json['duration'],
      price: json['price'],
      createdOn: DateTime.parse(json['created_on']),
      updatedOn: DateTime.parse(json['updated_on']), imageUrl: '',
    );
  }
}
