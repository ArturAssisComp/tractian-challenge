import 'package:asset_viewer/data/exceptions_and_errors.dart';
import 'package:asset_viewer/data/repository/companies_repository.dart';
import 'package:asset_viewer/domain/entities/company.dart';
import 'package:asset_viewer/domain/exceptions_and_errors.dart';

final class GetCompaniesUseCase {
  final CompaniesRepository _companiesRepository;
  const GetCompaniesUseCase({required CompaniesRepository companiesRepository})
      : _companiesRepository = companiesRepository;
  Future<List<Company>> call() async {
    try {
      return await _companiesRepository.getAllCompanies();
    } on BaseDataException catch (e) {
      throw GetCompaniesException(e.message);
    }
  }
}
