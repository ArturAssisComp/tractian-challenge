import 'package:asset_viewer/data/data_provider/data_provider.dart';
import 'package:asset_viewer/domain/repository/repository.dart';
import 'package:asset_viewer/domain/use_cases/use_cases.dart';
import 'package:asset_viewer/service_locator.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    setup();
  });
  group('Smoke tests for: Service Locator', () {
    final testCases = <({String name, dynamic getItCall})>[
      (name: 'Dio', getItCall: getIt.call<Dio>),
      (name: 'LocationsApi', getItCall: getIt.call<LocationsApi>),
      (name: 'CompaniesApi', getItCall: getIt.call<CompaniesApi>),
      (
        name: 'AssetsAndComponentsApi',
        getItCall: getIt.call<AssetsAndComponentsApi>
      ),
      (
        name: 'CompaniesRepositoryInterface',
        getItCall: getIt.call<CompaniesRepositoryInterface>
      ),
      (
        name: 'ResourcesRepositoryInterface',
        getItCall: getIt.call<ResourcesRepositoryInterface>
      ),
      (
        name: 'FilterResourcesUseCase',
        getItCall: getIt.call<FilterResourcesUseCase>
      ),
      (name: 'GetResourcesUseCase', getItCall: getIt.call<GetResourcesUseCase>),
      (name: 'GetCompaniesUseCase', getItCall: getIt.call<GetCompaniesUseCase>),
    ];
    for (final (name: name, getItCall: getItCall) in testCases) {
      test(
        name,
        () => expect(getItCall, returnsNormally),
      );
    }
  });
}
