import 'package:equatable/equatable.dart';

final class AssetModel extends Equatable {
  final String id;
  final String name;
  final String? parentId;
  final String? locationId;

  const AssetModel({
    required this.id,
    required this.name,
    this.parentId,
    this.locationId,
  }) : assert(
          !(parentId != null && locationId != null),
          'Either parentId or locationId must be provided, not both',
        );

  /// Factory to build a [AssetModel] from a json. The [json] must have the
  /// following fields:
  /// - 'id' as String
  /// - 'name' as String
  /// - 'parentId' as String?
  /// - 'locationId' as String?
  factory AssetModel.fromJson(Map<String, dynamic> json) => AssetModel(
        id: json['id'] as String,
        name: json['name'] as String,
        parentId: json['parentId'] as String?,
        locationId: json['locationId'] as String?,
      );

  @override
  List<Object?> get props => [id, name, parentId, locationId];
}
