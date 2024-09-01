import 'package:equatable/equatable.dart';

final class Company extends Equatable {
  const Company({
    required this.id,
    required this.name,
  });
  final String name;
  final String id;

  // Normally, I would implement this in the model, but in this project, given
  // the simplicity, I will implement fromJson directly from the entity.
  /// Factory to build a [Company] from a json. The [json] must have the
  /// following fields:
  /// - 'id' as String
  /// - 'name' as String
  factory Company.fromJson(Map<String, dynamic> json) =>
      Company(id: json['id'] as String, name: json['name'] as String);

  @override
  List<Object?> get props => [id, name];
}
