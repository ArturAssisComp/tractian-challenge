import 'dart:collection';

import 'package:equatable/equatable.dart';

sealed class Resource extends Equatable {
  final String id;
  final String name;
  const Resource({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

final class Location extends Resource {
  final List<Asset>? _subAssets;
  final List<Component>? _subComponents;
  final List<Location>? _subLocations;
  UnmodifiableListView<Asset> get subAssets =>
      UnmodifiableListView(_subAssets ?? []);
  UnmodifiableListView<Component> get subComponents =>
      UnmodifiableListView(_subComponents ?? []);
  UnmodifiableListView<Location> get subLocations =>
      UnmodifiableListView(_subLocations ?? []);
  const Location({
    required super.id,
    required super.name,
    List<Asset>? subAssets,
    List<Component>? subComponents,
    List<Location>? subLocations,
  })  : _subComponents = subComponents,
        _subAssets = subAssets,
        _subLocations = subLocations;

  @override
  List<Object?> get props => [
        id,
        name,
        subAssets,
        subComponents,
        subLocations,
      ];
}

final class Asset extends Resource {
  final List<Asset>? _subAssets;
  final List<Component>? _subComponents;
  UnmodifiableListView<Asset> get subAssets =>
      UnmodifiableListView(_subAssets ?? []);
  UnmodifiableListView<Component> get subComponents =>
      UnmodifiableListView(_subComponents ?? []);
  const Asset({
    required super.id,
    required super.name,
    List<Asset>? subAssets,
    List<Component>? subComponents,
  })  : _subComponents = subComponents,
        _subAssets = subAssets;

  @override
  List<Object?> get props => [
        id,
        name,
        subAssets,
        subComponents,
      ];
}

final class Component extends Resource {
  final String status;
  final String sensorType;
  final String sensorId;
  final String gatewayId;
  const Component({
    required super.id,
    required super.name,
    required this.status,
    required this.sensorType,
    required this.sensorId,
    required this.gatewayId,
  });
}
