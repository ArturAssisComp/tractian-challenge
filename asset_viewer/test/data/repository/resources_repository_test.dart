import 'package:asset_viewer/data/data_provider/assets_and_components_api.dart';
import 'package:asset_viewer/data/data_provider/locations_api.dart';
import 'package:asset_viewer/data/models/models.dart';
import 'package:asset_viewer/data/repository/resources_repository.dart';
import 'package:asset_viewer/domain/entities/resource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocationsApi extends Mock implements LocationsApi {}

class MockAssetsAndComponentsApi extends Mock
    implements AssetsAndComponentsApi {}

const d = (
  locations: (
    la: (id: 'LA', name: 'locationA'),
    sla1: (id: 'SLA1', name: 'subLocationA1', parentId: 'LA'),
    sla2: (id: 'SLA2', name: 'subLocationA2', parentId: 'LA'),
  ),
  assets: (
    a1: (id: 'A1', name: 'asset1', locationId: 'SLA2'),
    a2: (id: 'A2', name: 'asset2'),
  ),
  components: (
    c1: (
      id: 'C1',
      name: 'comp1',
      gatewayId: 'abc',
      sensorId: 'cde',
      sensorType: 'energy',
      status: 'operating',
      parentId: 'A1',
    ),
    c2: (
      id: 'C2',
      name: 'comp2',
      gatewayId: 'abc e',
      sensorId: 'ce',
      sensorType: 'vibration',
      status: 'alert',
      locationId: 'SLA2',
    ),
    c3: (
      id: 'C3',
      name: 'comp3',
      gatewayId: 'a e',
      sensorId: 'cefsjlk',
      sensorType: 'vibration',
      status: 'operating',
      parentId: 'A2',
    ),
    c4: (
      id: 'C4',
      name: 'comp4',
      gatewayId: 'a dflahsle',
      sensorId: 'cefsjafsdlk',
      sensorType: 'energy',
      status: 'alert',
    ),
  ),
);

final locationModels = [
  LocationModel(
    id: d.locations.sla2.id,
    name: d.locations.sla2.name,
    parentId: d.locations.sla2.parentId,
  ),
  LocationModel(
    id: d.locations.la.id,
    name: d.locations.la.name,
  ),
  LocationModel(
    id: d.locations.sla1.id,
    name: d.locations.sla1.name,
    parentId: d.locations.sla1.parentId,
  ),
];
final assetModels = <AssetModel>[
  AssetModel(id: d.assets.a2.id, name: d.assets.a2.name),
  AssetModel(
    id: d.assets.a1.id,
    name: d.assets.a1.name,
    locationId: d.assets.a1.locationId,
  )
];
final componentModels = <ComponentModel>[
  ComponentModel(
    id: d.components.c1.id,
    name: d.components.c1.name,
    gatewayId: d.components.c1.gatewayId,
    sensorId: d.components.c1.sensorId,
    sensorType: d.components.c1.sensorType,
    status: d.components.c1.status,
    parentId: d.components.c1.parentId,
  ),
  ComponentModel(
    id: d.components.c3.id,
    name: d.components.c3.name,
    gatewayId: d.components.c3.gatewayId,
    sensorId: d.components.c3.sensorId,
    sensorType: d.components.c3.sensorType,
    status: d.components.c3.status,
    parentId: d.components.c3.parentId,
  ),
  ComponentModel(
    id: d.components.c2.id,
    name: d.components.c2.name,
    gatewayId: d.components.c2.gatewayId,
    sensorId: d.components.c2.sensorId,
    sensorType: d.components.c2.sensorType,
    status: d.components.c2.status,
    locationId: d.components.c2.locationId,
  ),
  ComponentModel(
    id: d.components.c4.id,
    name: d.components.c4.name,
    gatewayId: d.components.c4.gatewayId,
    sensorId: d.components.c4.sensorId,
    sensorType: d.components.c4.sensorType,
    status: d.components.c4.status,
  ),
];

final expectedResources = [
  Location(
    id: d.locations.la.id,
    name: d.locations.la.name,
    subLocations: [
      Location(
        id: d.locations.sla1.id,
        name: d.locations.sla1.name,
      ),
      Location(
        id: d.locations.sla2.id,
        name: d.locations.sla2.name,
        subAssets: [
          Asset(
            id: d.assets.a1.id,
            name: d.assets.a1.name,
            subComponents: [
              Component(
                id: d.components.c1.id,
                name: d.components.c1.name,
                gatewayId: d.components.c1.gatewayId,
                sensorId: d.components.c1.sensorId,
                sensorType: d.components.c1.sensorType,
                status: d.components.c1.status,
              ),
            ],
          ),
        ],
        subComponents: [
          Component(
            id: d.components.c2.id,
            name: d.components.c2.name,
            gatewayId: d.components.c2.gatewayId,
            sensorId: d.components.c2.sensorId,
            sensorType: d.components.c2.sensorType,
            status: d.components.c2.status,
          ),
        ],
      ),
    ],
  ),
  Asset(
    id: d.assets.a2.id,
    name: d.assets.a2.name,
    subComponents: [
      Component(
        id: d.components.c3.id,
        name: d.components.c3.name,
        gatewayId: d.components.c3.gatewayId,
        sensorId: d.components.c3.sensorId,
        sensorType: d.components.c3.sensorType,
        status: d.components.c3.status,
      ),
    ],
  ),
  Component(
    id: d.components.c4.id,
    name: d.components.c4.name,
    gatewayId: d.components.c4.gatewayId,
    sensorId: d.components.c4.sensorId,
    sensorType: d.components.c4.sensorType,
    status: d.components.c4.status,
  ),
];

void main() {
  const companyId = 'companyId';
  late ResourcesRepository resourcesRepository;
  late MockLocationsApi locationsApi;
  late MockAssetsAndComponentsApi assetsAndComponentsApi;
  setUp(() {
    locationsApi = MockLocationsApi();
    assetsAndComponentsApi = MockAssetsAndComponentsApi();

    resourcesRepository = ResourcesRepository(
      locationsApi: locationsApi,
      assetsAndComponentsApi: assetsAndComponentsApi,
    );
  });
  group('Class: ResourcesRepository', () {
    group('Method: getAllResources', () {
      test('Should return empty resources', () async {
        when(() => locationsApi.getAllLocations(companyId: companyId))
            .thenAnswer((_) => Future.value([]));
        when(() => assetsAndComponentsApi.getAllAssets(companyId: companyId))
            .thenAnswer(
          (_) => Future.value(
            (assets: <AssetModel>[], components: <ComponentModel>[]),
          ),
        );
        final result =
            await resourcesRepository.getAllResources(companyId: companyId);
        expect(result, isEmpty);
      });

      test('Should return a non-empty resources', () async {
        when(() => locationsApi.getAllLocations(companyId: companyId))
            .thenAnswer((_) => Future.value(locationModels));
        when(() => assetsAndComponentsApi.getAllAssets(companyId: companyId))
            .thenAnswer(
          (_) => Future.value(
            (assets: assetModels, components: componentModels),
          ),
        );
        final result =
            await resourcesRepository.getAllResources(companyId: companyId);
        expect(result, expectedResources);
      });

      test('Should throw an Exception when locations Api fails', () async {
        when(() => locationsApi.getAllLocations(companyId: companyId))
            .thenAnswer((_) => Future.error(Exception()));
        when(() => assetsAndComponentsApi.getAllAssets(companyId: companyId))
            .thenAnswer(
          (_) => Future.value(
            (assets: assetModels, components: componentModels),
          ),
        );
        expect(() => resourcesRepository.getAllResources(companyId: companyId),
            throwsException);
      });

      test('Should throw an Error when assets and components Api fails',
          () async {
        when(() => locationsApi.getAllLocations(companyId: companyId))
            .thenAnswer((_) => Future.value(locationModels));
        when(() => assetsAndComponentsApi.getAllAssets(companyId: companyId))
            .thenAnswer(
          (_) => Future.error(Error()),
        );
        expect(() => resourcesRepository.getAllResources(companyId: companyId),
            throwsA(isA<Error>()));
      });
    });
  });
}
