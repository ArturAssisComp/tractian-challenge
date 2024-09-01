import 'package:asset_viewer/data/data_provider/constants.dart';
import 'package:asset_viewer/data/data_provider/locations_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LocationsApi locationsApi;
  setUp(() {
    locationsApi = LocationsApi(dio: Dio(kDioOptions));
  });
  group('Class: LocationApi', () {
    group('Method: getAllLocations', () {
      test('sanity', () async {
        final locations = await locationsApi.getAllLocations(
            companyId: '662fd0fab3fd5656edb39af5');
        print(locations);
      });
    });
  });
}
