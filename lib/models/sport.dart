class Sport {
  final String id;
  final String name;
  final String icon;
  final String description;
  final List<String> tags;

  Sport({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.tags,
  });

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String,
      tags: List<String>.from(json['tags'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
      'tags': tags,
    };
  }
}