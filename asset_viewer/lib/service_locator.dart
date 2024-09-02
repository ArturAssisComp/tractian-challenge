import 'package:asset_viewer/data/data_provider/constants.dart';
import 'package:asset_viewer/data/data_provider/data_provider.dart';
import 'package:asset_viewer/data/repository/repositories.dart';
import 'package:asset_viewer/domain/repository/companies_repository_interface.dart';
import 'package:asset_viewer/domain/repository/resources_repository_interface.dart';
import 'package:asset_viewer/domain/use_cases/use_cases.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

/// Instance of class GetIt used to retrieve and initialize the dependencies.
final getIt = GetIt.instance;

/// Setup for the service locator. Instantiate and initialize any dependency
/// that will be used in the application.
void setup() {
  getIt
    ..registerLazySingleton<Dio>(() => Dio(kDioOptions))
    // apis
    ..registerFactory<LocationsApi>(() => LocationsApi(dio: getIt<Dio>()))
    ..registerFactory<CompaniesApi>(() => CompaniesApi(dio: getIt<Dio>()))
    ..registerFactory<AssetsAndComponentsApi>(
        () => AssetsAndComponentsApi(dio: getIt<Dio>()))
    // repositories
    ..registerFactory<CompaniesRepositoryInterface>(
      () => CompaniesRepository(companiesApi: getIt<CompaniesApi>()),
    )
    ..registerFactory<ResourcesRepositoryInterface>(
      () => ResourcesRepository(
        locationsApi: getIt<LocationsApi>(),
        assetsAndComponentsApi: getIt<AssetsAndComponentsApi>(),
      ),
    )
    // use cases
    ..registerFactory<FilterResourcesUseCase>(
      FilterResourcesUseCase.new,
    )
    ..registerFactory<GetResourcesUseCase>(() => GetResourcesUseCase(
        resourcesRepositoryInterface: getIt<ResourcesRepositoryInterface>()))
    ..registerFactory<GetCompaniesUseCase>(() => GetCompaniesUseCase(
        companiesRepository: getIt<CompaniesRepositoryInterface>()));
}
