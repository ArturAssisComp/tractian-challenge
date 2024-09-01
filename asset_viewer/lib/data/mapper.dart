import 'package:asset_viewer/data/models/models.dart';
import 'package:asset_viewer/domain/entities/resource.dart';

/// This function converts the list of models into a tree structure of
/// resources.
List<Resource> fromModelsToResourceTree(
  List<LocationModel> locationModels,
  List<AssetModel> assetModels,
  List<ComponentModel> componentModels,
) {
  final aux = (
    idToLocationModel: <String, LocationModel>{},
    idToAssetModel: <String, AssetModel>{},
    idToComponentModel: <String, ComponentModel>{},
    idToSubLocationIds: <String, List<String>>{},
    idToSubAssetsIds: <String, List<String>>{},
    idToSubComponentsIds: <String, List<String>>{},
  );
  final topLevelResourceIds = <String>[];
  for (final loc in locationModels) {
    final LocationModel(id: id, parentId: parentId) = loc;
    aux.idToLocationModel[id] = loc;
    if (parentId == null) {
      topLevelResourceIds.add(id);
    } else {
      aux.idToSubLocationIds.putIfAbsent(parentId, () => []).add(id);
    }
  }
  for (final asset in assetModels) {
    final AssetModel(id: id, parentId: parentId, locationId: locationId) =
        asset;
    aux.idToAssetModel[id] = asset;
    if (parentId != null) {
      aux.idToSubAssetsIds.putIfAbsent(parentId, () => []).add(id);
    } else if (locationId != null) {
      aux.idToSubAssetsIds.putIfAbsent(locationId, () => []).add(id);
    } else {
      topLevelResourceIds.add(id);
    }
  }
  for (final component in componentModels) {
    final ComponentModel(id: id, parentId: parentId, locationId: locationId) =
        component;

    aux.idToComponentModel[id] = component;
    if (parentId != null) {
      aux.idToSubComponentsIds.putIfAbsent(parentId, () => []).add(id);
    } else if (locationId != null) {
      aux.idToSubComponentsIds.putIfAbsent(locationId, () => []).add(id);
    } else {
      topLevelResourceIds.add(id);
    }
  }

  final result = <Resource>[];
  for (final topLevelId in topLevelResourceIds) {
    if (aux.idToLocationModel.containsKey(topLevelId)) {
      result.add(locationModelToEntity(topLevelId, aux: aux));
    } else if (aux.idToAssetModel.containsKey(topLevelId)) {
      result.add(assetModelToEntity(topLevelId, aux: aux));
    } else if (aux.idToComponentModel.containsKey(topLevelId)) {
      result.add(componentModelToEntity(topLevelId, aux: aux));
    } else {
      throw StateError('Invalid top level key');
    }
  }
  return result;
}

Location locationModelToEntity(
  String id, {
  required ({
    Map<String, AssetModel> idToAssetModel,
    Map<String, ComponentModel> idToComponentModel,
    Map<String, LocationModel> idToLocationModel,
    Map<String, List<String>> idToSubAssetsIds,
    Map<String, List<String>> idToSubComponentsIds,
    Map<String, List<String>> idToSubLocationIds
  }) aux,
}) {
  final subLocations = <Location>[];
  final subAssets = <Asset>[];
  final subComponents = <Component>[];
  for (final subLocationId in aux.idToSubLocationIds[id] ?? <String>[]) {
    subLocations.add(locationModelToEntity(subLocationId, aux: aux));
  }
  for (final subAssetId in aux.idToSubAssetsIds[id] ?? <String>[]) {
    subAssets.add(assetModelToEntity(subAssetId, aux: aux));
  }
  for (final subComponentId in aux.idToSubComponentsIds[id] ?? <String>[]) {
    subComponents.add(componentModelToEntity(subComponentId, aux: aux));
  }

  final LocationModel(name: name) = aux.idToLocationModel[id]!;
  return Location(
    id: id,
    name: name,
    subAssets: subAssets.isNotEmpty ? subAssets : null,
    subComponents: subComponents.isNotEmpty ? subComponents : null,
    subLocations: subLocations.isNotEmpty ? subLocations : null,
  );
}

Asset assetModelToEntity(
  String id, {
  required ({
    Map<String, AssetModel> idToAssetModel,
    Map<String, ComponentModel> idToComponentModel,
    Map<String, LocationModel> idToLocationModel,
    Map<String, List<String>> idToSubAssetsIds,
    Map<String, List<String>> idToSubComponentsIds,
    Map<String, List<String>> idToSubLocationIds
  }) aux,
}) {
  final subAssets = <Asset>[];
  final subComponents = <Component>[];
  for (final subAssetId in aux.idToSubAssetsIds[id] ?? <String>[]) {
    subAssets.add(assetModelToEntity(subAssetId, aux: aux));
  }
  for (final subComponentId in aux.idToSubComponentsIds[id] ?? <String>[]) {
    subComponents.add(componentModelToEntity(subComponentId, aux: aux));
  }

  final AssetModel(name: name) = aux.idToAssetModel[id]!;
  return Asset(
    id: id,
    name: name,
    subAssets: subAssets.isNotEmpty ? subAssets : null,
    subComponents: subComponents.isNotEmpty ? subComponents : null,
  );
}

Component componentModelToEntity(
  String id, {
  required ({
    Map<String, AssetModel> idToAssetModel,
    Map<String, ComponentModel> idToComponentModel,
    Map<String, LocationModel> idToLocationModel,
    Map<String, List<String>> idToSubAssetsIds,
    Map<String, List<String>> idToSubComponentsIds,
    Map<String, List<String>> idToSubLocationIds
  }) aux,
}) {
  final ComponentModel(
    name: name,
    status: status,
    sensorId: sensorId,
    sensorType: sensorType,
    gatewayId: gatewayId,
  ) = aux.idToComponentModel[id]!;
  return Component(
    id: id,
    name: name,
    status: status,
    sensorType: sensorType,
    sensorId: sensorId,
    gatewayId: gatewayId,
  );
}
