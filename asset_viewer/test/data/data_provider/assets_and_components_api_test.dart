import 'package:asset_viewer/data/data_provider/assets_and_components_api.dart';
import 'package:asset_viewer/data/data_provider/constants.dart';
import 'package:asset_viewer/data/exceptions_and_errors.dart';
import 'package:asset_viewer/data/models/models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../constants.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late AssetsAndComponentsApi assetsAndComponentsApi;
  late MockDio dio;

  const companyId = 'companyId';
  final componentModels = <ComponentModel>[
    const ComponentModel(
      id: 'c1',
      name: 'comp1',
      gatewayId: 'abc',
      sensorId: 'cde',
      sensorType: 'type1',
      status: 'status1',
      locationId: 'loc1',
    ),
    const ComponentModel(
      id: 'c2',
      name: 'comp2',
      gatewayId: 'abc e',
      sensorId: 'ce',
      sensorType: 'type2',
      status: 'status2',
      parentId: 'abc',
    ),
  ];
  final assetModels = <AssetModel>[
    const AssetModel(
      id: 'a1',
      name: 'asset1',
      locationId: 'loc1',
    ),
    const AssetModel(
      id: 'a2',
      name: 'asset2',
      parentId: 'c',
    ),
    const AssetModel(
      id: 'a3',
      name: 'asset3',
      parentId: 'a2',
    ),
  ];

  final json = <dynamic>[
    for (final component in componentModels)
      {
        'id': component.id,
        'name': component.name,
        'gatewayId': component.gatewayId,
        'sensorId': component.sensorId,
        'sensorType': component.sensorType,
        'status': component.status,
        'locationId': component.locationId,
        'parentId': component.parentId,
      },
    for (final asset in assetModels)
      {
        'id': asset.id,
        'name': asset.name,
        'locationId': asset.locationId,
        'parentId': asset.parentId,
      },
  ];

  setUp(() {
    dio = MockDio();
    assetsAndComponentsApi = AssetsAndComponentsApi(dio: dio);
  });
  group('Class: AssetsAndComponentsApi', () {
    group('Method: getAllAssets', () {
      test('Should return empty list', () async {
        final res =
            Response<List<dynamic>>(data: [], requestOptions: RequestOptions());
        when(
          () =>
              dio.get<List<dynamic>>(kEndPoints.assetsAndComponents(companyId)),
        ).thenAnswer((_) => Future.value(res));
        final (assets: assets, components: components) =
            await assetsAndComponentsApi.getAllAssets(companyId: companyId);
        expect(assets, equals([]));
        expect(components, equals([]));
      });

      test('Should return a non-empty list', () async {
        final res = Response<List<dynamic>>(
          data: json,
          requestOptions: RequestOptions(),
        );
        when(
          () =>
              dio.get<List<dynamic>>(kEndPoints.assetsAndComponents(companyId)),
        ).thenAnswer((_) => Future.value(res));
        final (assets: assets, components: components) =
            await assetsAndComponentsApi.getAllAssets(companyId: companyId);
        expect(assets, equals(assetModels));
        expect(components, equals(componentModels));
      });
      test('Should throw HttpDataException', () async {
        when(
          () => dio.get<List<dynamic>>(
            kEndPoints.assetsAndComponents(companyId),
          ),
        ).thenAnswer(
          (_) => Future.error(
            DioException(
              requestOptions: RequestOptions(),
              response: Response(
                requestOptions: RequestOptions(),
                statusCode: kInternalServerErrorStatusCode,
                statusMessage: kInternalServerErrorStatusMessage,
              ),
            ),
          ),
        );
        expect(
          () => assetsAndComponentsApi.getAllAssets(companyId: companyId),
          throwsA(
            isA<HttpDataException>().having(
              (e) => (e.statusCode, e.statusMessage),
              'Should have the expected status code and message',
              equals(
                (
                  kInternalServerErrorStatusCode,
                  kInternalServerErrorStatusMessage
                ),
              ),
            ),
          ),
        );
      });

      test('Should throw DataAccessException', () async {
        when(
          () => dio.get<List<dynamic>>(
            kEndPoints.assetsAndComponents(companyId),
          ),
        ).thenAnswer(
          (_) => Future.error(
            DioException(
              requestOptions: RequestOptions(),
            ),
          ),
        );
        expect(
          () => assetsAndComponentsApi.getAllAssets(companyId: companyId),
          throwsA(
            isA<DataAccessException>(),
          ),
        );
      });

      test('Should not intercept errors', () async {
        when(
          () => dio.get<List<dynamic>>(
            kEndPoints.assetsAndComponents(companyId),
          ),
        ).thenAnswer(
          (_) => Future.error(Error()),
        );
        expect(
          () => assetsAndComponentsApi.getAllAssets(companyId: companyId),
          throwsA(isA<Error>()),
        );
      });
    });
  });
}
