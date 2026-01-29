class Project {
  final String id;
  final String name;
  final String status;
  final DateTime updatedAt;

  const Project({
    required this.id,
    required this.name,
    required this.status,
    required this.updatedAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      status: json['status']?.toString() ?? 'active',
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
        'updatedAt': updatedAt.toIso8601String(),
      };
}
