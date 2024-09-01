import 'package:asset_viewer/data/data_provider/assets_and_components_api.dart';
import 'package:asset_viewer/data/data_provider/locations_api.dart';
import 'package:asset_viewer/data/mapper.dart';
import 'package:asset_viewer/domain/entities/resource.dart';
import 'package:asset_viewer/domain/repository/resources_repository_interface.dart';

final class ResourcesRepository implements ResourcesRepositoryInterface {
  final LocationsApi _locationsApi;
  final AssetsAndComponentsApi _assetsAndComponentsApi;
  const ResourcesRepository({
    required LocationsApi locationsApi,
    required AssetsAndComponentsApi assetsAndComponentsApi,
  })  : _assetsAndComponentsApi = assetsAndComponentsApi,
        _locationsApi = locationsApi;

  @override
  Future<List<Resource>> getAllResources({required String companyId}) async {
    final locationModels =
        await _locationsApi.getAllLocations(companyId: companyId);
    final (assets: assetModels, components: componentModels) =
        await _assetsAndComponentsApi.getAllAssets(companyId: companyId);
    return fromModelsToResourceTree(
      locationModels,
      assetModels,
      componentModels,
    );
  }
}
