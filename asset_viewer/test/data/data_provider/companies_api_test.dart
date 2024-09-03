import 'package:asset_viewer/data/data_provider/companies_api.dart';
import 'package:asset_viewer/data/data_provider/constants.dart';
import 'package:asset_viewer/data/exceptions_and_errors.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../constants.dart';

class MockDio extends Mock implements Dio {}

void main() {
  const list1 = [
    {'hello': '1', 'hello1': 12},
    {'other': 'other1', 'a': 123},
    {'a': 'b'},
  ];
  group('Class: CompaniesApi', () {
    late CompaniesApi companiesApi;
    late MockDio dio;

    setUp(() {
      dio = MockDio();
      companiesApi = CompaniesApi(dio: dio);
    });

    group('Method: getAllCompanies', () {
      test('Should return empty list', () async {
        final res =
            Response<List<dynamic>>(data: [], requestOptions: RequestOptions());
        when(() => dio.get<List<dynamic>>(kEndPoints.companies))
            .thenAnswer((_) => Future.value(res));
        final companies = await companiesApi.getAllCompanies();
        expect(companies, equals([]));
      });
      test('Should return non-empty list', () async {
        final res = Response<List<dynamic>>(
          data: list1,
          requestOptions: RequestOptions(),
        );
        when(() => dio.get<List<dynamic>>(kEndPoints.companies))
            .thenAnswer((_) => Future.value(res));
        final companies = await companiesApi.getAllCompanies();
        expect(companies, equals(list1));
      });
      test('Should throw HttpDataException', () async {
        when(() => dio.get<List<dynamic>>(kEndPoints.companies)).thenAnswer(
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
          () => companiesApi.getAllCompanies(),
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
        when(() => dio.get<List<dynamic>>(kEndPoints.companies)).thenAnswer(
          (_) => Future.error(
            DioException(
              requestOptions: RequestOptions(),
            ),
          ),
        );
        expect(
          () => companiesApi.getAllCompanies(),
          throwsA(
            isA<DataAccessException>(),
          ),
        );
      });

      test('Should not intercept errors', () async {
        when(() => dio.get<List<dynamic>>(kEndPoints.companies)).thenAnswer(
          (_) => Future.error(Error()),
        );
        expect(
          () => companiesApi.getAllCompanies(),
          throwsA(isA<Error>()),
        );
      });
    });
  });
}
