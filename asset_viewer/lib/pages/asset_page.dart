import 'package:asset_viewer/data/data_provider/assets_and_components_api.dart';
import 'package:asset_viewer/data/data_provider/constants.dart';
import 'package:asset_viewer/data/data_provider/locations_api.dart';
import 'package:asset_viewer/data/repository/resources_repository.dart';
import 'package:asset_viewer/domain/use_cases/get_resources_use_case.dart';
import 'package:asset_viewer/widgets/resource_presentation_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AssetPage extends StatelessWidget {
  static const path = 'assetPage';
  static const url = '/assetPage';
  const AssetPage({
    required this.companyId,
    super.key,
  });
  final String companyId;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder(
          future: GetResourcesUseCase(
              resourcesRepositoryInterface: ResourcesRepository(
                  locationsApi: LocationsApi(dio: Dio(kDioOptions)),
                  assetsAndComponentsApi: AssetsAndComponentsApi(
                      dio: Dio(kDioOptions))))(companyId: companyId),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final resources = snapshot.data!;
            return ListView.builder(
              itemCount: resources.length,
              itemBuilder: (context, index) =>
                  ResourcePresentationWidget(resource: resources[index]),
            );
          },
        ),
      );
}
