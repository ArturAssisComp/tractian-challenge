import 'package:asset_viewer/data/data_provider/companies_api.dart';
import 'package:asset_viewer/domain/entities/company.dart';
import 'package:asset_viewer/domain/repository/companies_repository_interface.dart';

final class CompaniesRepository implements CompaniesRepositoryInterface {
  final CompaniesApi _companiesApi;
  const CompaniesRepository({required CompaniesApi companiesApi})
      : _companiesApi = companiesApi;
  @override
  Future<List<Company>> getAllCompanies() async {
    final companies = (await _companiesApi.getAllCompanies())
        .map((e) => Company.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return companies;
  }
}
