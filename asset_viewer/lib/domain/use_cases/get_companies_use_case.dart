import 'package:asset_viewer/data/exceptions_and_errors.dart';
import 'package:asset_viewer/domain/entities/company.dart';
import 'package:asset_viewer/domain/exceptions_and_errors.dart';
import 'package:asset_viewer/domain/repository/companies_repository_interface.dart';

final class GetCompaniesUseCase {
  final CompaniesRepositoryInterface _companiesRepository;
  const GetCompaniesUseCase({
    required CompaniesRepositoryInterface companiesRepository,
  }) : _companiesRepository = companiesRepository;
  Future<List<Company>> call() async {
    try {
      return await _companiesRepository.getAllCompanies();
    } on BaseDataException catch (e) {
      throw GetCompaniesException(e.message);
    }
  }
}
