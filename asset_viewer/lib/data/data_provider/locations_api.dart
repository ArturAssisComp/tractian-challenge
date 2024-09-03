import 'package:asset_viewer/data/data_provider/constants.dart';
import 'package:asset_viewer/data/exceptions_and_errors.dart';
import 'package:asset_viewer/data/models/models.dart';
import 'package:dio/dio.dart';

class LocationsApi {
  final Dio _dio;
  const LocationsApi({required Dio dio}) : _dio = dio;

  Future<List<LocationModel>> getAllLocations({
    required String companyId,
  }) async {
    try {
      final response =
          await _dio.get<List<dynamic>>(kEndPoints.locations(companyId));
      return (response.data ?? [])
          .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw HttpDataException(
          'Unable to load locations for companyId: $companyId',
          statusCode: e.response?.statusCode,
          statusMessage: e.response?.statusMessage,
        );
      }
      throw DataAccessException(
        'Unable to load locations for companyId: $companyId (${e.message})',
      );
    }
  }
}
