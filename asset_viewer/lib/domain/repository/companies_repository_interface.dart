import 'package:asset_viewer/domain/entities/company.dart';

// ignore: one_member_abstracts
abstract interface class CompaniesRepositoryInterface {
  Future<List<Company>> getAllCompanies();
}
