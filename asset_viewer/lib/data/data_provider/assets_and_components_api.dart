import 'package:asset_viewer/data/data_provider/constants.dart';
import 'package:asset_viewer/data/exceptions_and_errors.dart';
import 'package:asset_viewer/data/models/models.dart';
import 'package:dio/dio.dart';

class AssetsAndComponentsApi {
  final Dio _dio;
  const AssetsAndComponentsApi({required Dio dio}) : _dio = dio;

  bool isComponent(Map<String, dynamic> json) => json['sensorType'] != null;

  Future<({List<AssetModel> assets, List<ComponentModel> components})>
      getAllAssets({required String companyId}) async {
    try {
      final response = await _dio
          .get<List<dynamic>>(kEndPoints.assetsAndComponents(companyId));
      final assets = <AssetModel>[];
      final components = <ComponentModel>[];
      for (final e in response.data ?? []) {
        e as Map<String, dynamic>;
        // check if it is component
        if (isComponent(e)) {
          components.add(ComponentModel.fromJson(e));
        } else {
          // it is expected to be an asset
          assets.add(AssetModel.fromJson(e));
        }
      }
      return (assets: assets, components: components);
    } on DioException catch (e) {
      if (e.response != null) {
        throw HttpDataException(
          'Unable to load assets for companyId: $companyId',
          statusCode: e.response?.statusCode,
          statusMessage: e.response?.statusMessage,
        );
      }
      throw DataAccessException(
        'Unable to load assets for companyId: $companyId (${e.message})',
      );
    }
  }
}
