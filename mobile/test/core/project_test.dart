import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/models/project.dart';

void main() {
  test('project fromJson handles missing fields', () {
    final project = Project.fromJson({'name': 'Alpha'});

    expect(project.name, 'Alpha');
    expect(project.status, 'active');
    expect(project.id, isNotNull);
  });
}
