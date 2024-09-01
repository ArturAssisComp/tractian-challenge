import 'package:asset_viewer/data/data_provider/companies_api.dart';
import 'package:asset_viewer/data/data_provider/constants.dart';
import 'package:asset_viewer/data/repository/companies_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CompaniesRepository companiesRepository;
  CompaniesApi companiesApi;

  setUp(() {
    companiesApi = CompaniesApi(dio: Dio(kDioOptions));
    companiesRepository = CompaniesRepository(companiesApi: companiesApi);
  });
  group('Class: CompaniesRepository', () {
    group('Method: getAllCompanies', () {
      test('sanity', () async {
        final result = await companiesRepository.getAllCompanies();
        print(result);
      });
    });
  });
}
