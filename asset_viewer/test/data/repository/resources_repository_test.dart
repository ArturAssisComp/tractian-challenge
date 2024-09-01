import 'package:asset_viewer/data/data_provider/assets_and_components_api.dart';
import 'package:asset_viewer/data/data_provider/constants.dart';
import 'package:asset_viewer/data/data_provider/locations_api.dart';
import 'package:asset_viewer/data/repository/resources_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ResourcesRepository resourcesRepository;
  LocationsApi locationsApi;
  AssetsAndComponentsApi assetsAndComponentsApi;
  setUp(() {
    final dio = Dio(kDioOptions);
    locationsApi = LocationsApi(dio: dio);
    assetsAndComponentsApi = AssetsAndComponentsApi(dio: dio);

    resourcesRepository = ResourcesRepository(
      locationsApi: locationsApi,
      assetsAndComponentsApi: assetsAndComponentsApi,
    );
  });
  group('Class: ResourcesRepository', () {
    group('Method: getAllResources', () {
      test('Jaguar company', () async {
        final result = await resourcesRepository.getAllResources(
            companyId: '662fd0ee639069143a8fc387');
        print(result);
      });
      test('Tobias company', () async {
        final result = await resourcesRepository.getAllResources(
            companyId: '662fd0fab3fd5656edb39af5');
        print(result);
      });
      test('Apex company', () async {
        final result = await resourcesRepository.getAllResources(
            companyId: '662fd100f990557384756e58');
        print(result);
      });
    });
  });
}
