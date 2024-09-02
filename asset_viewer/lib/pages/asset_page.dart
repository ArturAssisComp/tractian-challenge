import 'package:asset_viewer/constants.dart';
import 'package:asset_viewer/data/data_provider/assets_and_components_api.dart';
import 'package:asset_viewer/data/data_provider/constants.dart';
import 'package:asset_viewer/data/data_provider/locations_api.dart';
import 'package:asset_viewer/data/repository/resources_repository.dart';
import 'package:asset_viewer/domain/use_cases/get_resources_use_case.dart';
import 'package:asset_viewer/widgets/resource_presentation_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

final _kAlertIcon = ImageIcon(
  size: 16,
  AssetImage(kAssets.alertIcon),
);
final _kEnergySensorIcon = ImageIcon(
  size: 16,
  AssetImage(kAssets.outlinedEnergySensor),
);

class AssetPage extends StatelessWidget {
  static const path = 'assetPage';
  static const url = '/assetPage';
  const AssetPage({
    required this.companyId,
    super.key,
  });
  final String companyId;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                child: SizedBox(
                  height: 36,
                  child: TextField(
                    style: TextStyle(fontSize: 14),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      filled: true,
                      prefixIcon: Icon(Icons.search, color: Color(0xFF8E98A3)),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      fillColor: Color(0xFFEAEFF3),
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Search',
                      hintStyle:
                          TextStyle(fontSize: 14, color: Color(0xFF8E98A3)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                child: Row(
                  children: [
                    OutlinedButton(
                      style: ButtonStyle(
                        fixedSize: const WidgetStatePropertyAll(Size(166, 32)),
                        padding: const WidgetStatePropertyAll(
                            EdgeInsets.only(left: 16)),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3))),
                      ),
                      onPressed: () {},
                      child: Row(
                        children: [
                          _kEnergySensorIcon,
                          const SizedBox(width: 6),
                          const Text(
                            'Sensor de energia',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      style: ButtonStyle(
                        fixedSize: const WidgetStatePropertyAll(Size(94, 32)),
                        padding: const WidgetStatePropertyAll(
                            EdgeInsets.only(left: 16)),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3))),
                      ),
                      onPressed: () {},
                      child: Row(
                        children: [
                          _kAlertIcon,
                          const SizedBox(width: 6),
                          const Text(
                            'Crítico',
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: FutureBuilder(
                  future: GetResourcesUseCase(
                    resourcesRepositoryInterface: ResourcesRepository(
                      locationsApi: LocationsApi(dio: Dio(kDioOptions)),
                      assetsAndComponentsApi: AssetsAndComponentsApi(
                        dio: Dio(kDioOptions),
                      ),
                    ),
                  )(companyId: companyId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final resources = snapshot.data!;
                    return ListView.builder(
                      itemCount: resources.length,
                      itemBuilder: (context, index) =>
                          ResourcePresentationWidget(
                        resource: resources[index],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
