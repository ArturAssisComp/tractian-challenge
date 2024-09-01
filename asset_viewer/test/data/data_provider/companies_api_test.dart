import 'package:asset_viewer/data/data_provider/companies_api.dart';
import 'package:asset_viewer/data/data_provider/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

// TODO(ArturAssisComp): finish implementing tests
void main() {
  group('Class: CompaniesApi', () {
    late CompaniesApi companiesApi;

    setUp(() {
      companiesApi = CompaniesApi(dio: Dio(kDioOptions));
    });

    group('Method: getAllCompanies', () {
      test('sanity', () async {
        await companiesApi.getAllCompanies();
      });
    });
  });
}
