import 'package:dio/dio.dart';

final kEndPoints = (
  companies: '/companies',
  locations: (String companyId) => '/companies/$companyId/locations',
  assetsAndComponents: (String companyId) => '/companies/$companyId/assets',
);

final kDioOptions = BaseOptions(
  baseUrl: 'https://fake-api.tractian.com',
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 8),
);
