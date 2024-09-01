import 'package:equatable/equatable.dart';

final class LocationModel extends Equatable {
  final String id;
  final String name;
  final String? parentId;

  const LocationModel({required this.id, required this.name, this.parentId});

  /// Factory to build a [LocationModel] from a json. The [json] must have the
  /// following fields:
  /// - 'id' as String
  /// - 'name' as String
  /// - 'parentId' as String?
  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        id: json['id'] as String,
        name: json['name'] as String,
        parentId: json['parentId'] as String?,
      );

  @override
  List<Object?> get props => [id, name, parentId];
}
