import 'package:asset_viewer/data/data_provider/constants.dart';
import 'package:asset_viewer/data/exceptions_and_errors.dart';
import 'package:dio/dio.dart';

final class CompaniesApi {
  const CompaniesApi({required Dio dio}) : _dio = dio;
  final Dio _dio;
  Future<List<dynamic>> getAllCompanies() async {
    try {
      final response = await _dio.get<List<dynamic>>(EndPoints.companies.url);
      return response.data ?? [];
    } on DioException catch (e) {
      if (e.response != null) {
        throw HttpDataException(
          'Unable to load companies',
          statusCode: e.response?.statusCode,
          statusMessage: e.response?.statusMessage,
        );
      }
      throw DataAccessException('Unable to load companies (${e.message})');
    }
  }
}
