import 'package:dio/dio.dart';

enum EndPoints {
  companies('/companies');

  final String url;
  const EndPoints(this.url);
}

final kDioOptions = BaseOptions(
  baseUrl: 'https://fake-api.tractian.com',
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 8),
);
