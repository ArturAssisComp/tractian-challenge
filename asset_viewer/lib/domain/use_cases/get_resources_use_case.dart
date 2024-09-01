import 'package:asset_viewer/data/exceptions_and_errors.dart';
import 'package:asset_viewer/domain/entities/resource.dart';
import 'package:asset_viewer/domain/exceptions_and_errors.dart';
import 'package:asset_viewer/domain/repository/resources_repository_interface.dart';

final class GetLocationsUseCase {
  final ResourcesRepositoryInterface _resourcesRepositoryInterface;
  const GetLocationsUseCase({
    required ResourcesRepositoryInterface resourcesRepositoryInterface,
  }) : _resourcesRepositoryInterface = resourcesRepositoryInterface;
  Future<List<Resource>> call({required String companyId}) async {
    try {
      return await _resourcesRepositoryInterface.getAllResources(
        companyId: companyId,
      );
    } on BaseDataException catch (e) {
      throw GetResourcesException(e.message);
    }
  }
}
