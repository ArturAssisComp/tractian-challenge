import 'package:equatable/equatable.dart';

final class ComponentModel extends Equatable {
  final String id;
  final String name;
  final String sensorId;
  final String sensorType;
  final String status;
  final String gatewayId;
  final String? parentId;
  final String? locationId;

  const ComponentModel({
    required this.id,
    required this.name,
    required this.gatewayId,
    required this.sensorId,
    required this.sensorType,
    required this.status,
    this.parentId,
    this.locationId,
  }) : assert(
          !(parentId != null && locationId != null),
          'Either parentId or locationId must be provided, not both',
        );

  /// Factory to build a [ComponentModel] from a json. The [json] must have the
  /// following fields:
  /// - 'id' as String
  /// - 'name' as String
  /// - 'gatewayId' as String,
  /// - 'sensorId' as String,
  /// - 'sensorType' as String,
  /// - 'status' as String,
  /// - 'parentId' as String?
  /// - 'locationId' as String?
  factory ComponentModel.fromJson(Map<String, dynamic> json) => ComponentModel(
        id: json['id'] as String,
        name: json['name'] as String,
        gatewayId: json['gatewayId'] as String,
        sensorId: json['sensorId'] as String,
        sensorType: json['sensorType'] as String,
        status: json['status'] as String,
        parentId: json['parentId'] as String?,
        locationId: json['locationId'] as String?,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        gatewayId,
        sensorId,
        sensorType,
        status,
        parentId,
        locationId,
      ];
}
