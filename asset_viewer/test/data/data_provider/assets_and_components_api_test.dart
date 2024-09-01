import 'package:asset_viewer/data/data_provider/assets_and_components_api.dart';
import 'package:asset_viewer/data/data_provider/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AssetsAndComponentsApi assetsAndComponentsApi;

  setUp(() {
    assetsAndComponentsApi = AssetsAndComponentsApi(dio: Dio(kDioOptions));
  });
  group('Class: AssetsAndComponentsApi', () {
    group('Method: getAllAssets', () {
      test('sanity', () async {
        final (assets: assets, components: components) =
            await assetsAndComponentsApi.getAllAssets(
                companyId: '662fd0fab3fd5656edb39af5');
        print(assets);
        print(components);
      });
    });
  });
}
