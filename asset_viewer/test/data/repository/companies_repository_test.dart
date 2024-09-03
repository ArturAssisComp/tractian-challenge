import 'package:asset_viewer/data/data_provider/companies_api.dart';
import 'package:asset_viewer/data/repository/companies_repository.dart';
import 'package:asset_viewer/domain/entities/company.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCompaniesApi extends Mock implements CompaniesApi {}

void main() {
  late CompaniesRepository companiesRepository;
  late MockCompaniesApi companiesApi;

  final json = [
    {'id': 'id3', 'name': 'name3'},
    {'id': 'id1', 'name': 'name1'},
    {'id': 'id2', 'name': 'name2'},
    {'id': 'id4', 'name': 'name4'},
  ];
  const expectedCompanies = [
    Company(id: 'id1', name: 'name1'),
    Company(id: 'id2', name: 'name2'),
    Company(id: 'id3', name: 'name3'),
    Company(id: 'id4', name: 'name4'),
  ];

  setUp(() {
    companiesApi = MockCompaniesApi();
    companiesRepository = CompaniesRepository(companiesApi: companiesApi);
  });
  group('Class: CompaniesRepository', () {
    group('Method: getAllCompanies', () {
      test('Should return empty companies', () async {
        when(() => companiesApi.getAllCompanies())
            .thenAnswer((_) => Future.value([]));
        final result = await companiesRepository.getAllCompanies();
        expect(result, isEmpty);
      });
      test('Should return a non-empty companies', () async {
        when(() => companiesApi.getAllCompanies())
            .thenAnswer((_) => Future.value(json));
        final result = await companiesRepository.getAllCompanies();
        expect(result, expectedCompanies);
      });
      test('Should throw an Exception when companies Api fails', () async {
        when(() => companiesApi.getAllCompanies())
            .thenAnswer((_) => Future.error(Exception()));
        expect(() => companiesRepository.getAllCompanies(), throwsException);
      });
    });
  });
}
