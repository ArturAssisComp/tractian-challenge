import 'package:asset_viewer/data/data_provider/constants.dart';
import 'package:asset_viewer/data/data_provider/locations_api.dart';
import 'package:asset_viewer/data/exceptions_and_errors.dart';
import 'package:asset_viewer/data/models/location_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../constants.dart';

class MockDio extends Mock implements Dio {}

void main() {
  const companyId = 'companyId';
  const json1 = [
    {'id': 'A', 'name': 'locationA'},
    {'id': 'B', 'name': 'locationB', 'parentId': null},
    {'id': 'C', 'name': 'locationC', 'parentId': 'B'},
  ];
  const models1 = [
    LocationModel(id: 'A', name: 'locationA'),
    LocationModel(id: 'B', name: 'locationB'),
    LocationModel(id: 'C', name: 'locationC', parentId: 'B'),
  ];
  late LocationsApi locationsApi;
  late MockDio dio;
  setUp(() {
    dio = MockDio();
    locationsApi = LocationsApi(dio: dio);
  });
  group('Class: LocationApi', () {
    group('Method: getAllLocations', () {
      test('Should return empty list', () async {
        final res =
            Response<List<dynamic>>(data: [], requestOptions: RequestOptions());
        when(() => dio.get<List<dynamic>>(kEndPoints.locations(companyId)))
            .thenAnswer((_) => Future.value(res));
        final locations =
            await locationsApi.getAllLocations(companyId: companyId);
        expect(locations, equals([]));
      });
      test('Should return a non-empty list', () async {
        final res = Response<List<dynamic>>(
            data: json1, requestOptions: RequestOptions());
        when(() => dio.get<List<dynamic>>(kEndPoints.locations(companyId)))
            .thenAnswer((_) => Future.value(res));
        final locations =
            await locationsApi.getAllLocations(companyId: companyId);
        expect(locations, equals(models1));
      });
      test('Should throw HttpDataException', () async {
        when(() => dio.get<List<dynamic>>(kEndPoints.locations(companyId)))
            .thenAnswer(
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
          () => locationsApi.getAllLocations(companyId: companyId),
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
        when(() => dio.get<List<dynamic>>(kEndPoints.locations(companyId)))
            .thenAnswer(
          (_) => Future.error(
            DioException(
              requestOptions: RequestOptions(),
            ),
          ),
        );
        expect(
          () => locationsApi.getAllLocations(companyId: companyId),
          throwsA(
            isA<DataAccessException>(),
          ),
        );
      });

      test('Should not intercept errors', () async {
        when(() => dio.get<List<dynamic>>(kEndPoints.locations(companyId)))
            .thenAnswer(
          (_) => Future.error(Error()),
        );
        expect(
          () => locationsApi.getAllLocations(companyId: companyId),
          throwsA(isA<Error>()),
        );
      });
    });
  });
}
