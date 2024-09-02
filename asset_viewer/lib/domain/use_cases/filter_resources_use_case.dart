import 'package:asset_viewer/domain/entities/resource.dart';

final class FilterResourcesUseCase {
  const FilterResourcesUseCase();

  Set<String>? call(
      {required List<Resource> resources,
      required bool Function(Resource) query}) {
    final result = <String>{};
    for (final resource in resources) {
      result.addAll(filterResource(resource, query));
    }
    return result;
  }
}

Set<String> filterResource(Resource r, bool Function(Resource) query) {
  final result = <String>{};
  // children first
  switch (r) {
    case Location():
      for (final subLocation in r.subLocations) {
        final auxResult = filterResource(subLocation, query);
        if (auxResult.isNotEmpty) {
          result
            ..add(r.id)
            ..addAll(auxResult);
        }
      }
      for (final subAsset in r.subAssets) {
        final auxResult = filterResource(subAsset, query);
        if (auxResult.isNotEmpty) {
          result
            ..add(r.id)
            ..addAll(auxResult);
        }
      }
      for (final subComponent in r.subComponents) {
        if (query(subComponent)) {
          result
            ..add(r.id)
            ..add(subComponent.id);
        }
      }
    case Asset():
      for (final subAsset in r.subAssets) {
        final auxResult = filterResource(subAsset, query);
        if (auxResult.isNotEmpty) {
          result
            ..add(r.id)
            ..addAll(auxResult);
        }
      }
      for (final subComponent in r.subComponents) {
        if (query(subComponent)) {
          result
            ..add(r.id)
            ..add(subComponent.id);
        }
      }
    case Component():
      break;
  }
  // check the current node
  if (query(r)) {
    result.add(r.id);
  }
  return result;
}
