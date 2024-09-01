import 'package:asset_viewer/domain/entities/resource.dart';

// ignore: one_member_abstracts
abstract interface class ResourcesRepositoryInterface {
  Future<List<Resource>> getAllResources({required String companyId});
}
