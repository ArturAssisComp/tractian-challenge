import 'dart:async';

import 'package:asset_viewer/constants.dart';
import 'package:asset_viewer/data/data_provider/assets_and_components_api.dart';
import 'package:asset_viewer/data/data_provider/constants.dart';
import 'package:asset_viewer/data/data_provider/locations_api.dart';
import 'package:asset_viewer/data/repository/resources_repository.dart';
import 'package:asset_viewer/domain/entities/resource.dart';
import 'package:asset_viewer/domain/use_cases/filter_resources_use_case.dart';
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
  final String companyId;
  const AssetPage({
    required this.companyId,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Assets',
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: FutureBuilder(
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
            return _AssetPage(resources: resources);
          },
        ),
      );
}

class _AssetPage extends StatefulWidget {
  final List<Resource> resources;
  const _AssetPage({
    required this.resources,
  });

  @override
  State<_AssetPage> createState() => _AssetPageState();
}

class _AssetPageState extends State<_AssetPage> {
  Set<String>? filteredEnergySensor;
  Set<String>? filteredCriticalStatus;
  Set<String>? filteredName;
  Set<String>? currentFilter;
  bool energySensorFilterIsActive = false;
  bool criticalStatusFilterIsActive = false;
  final filterResourcesUseCase = const FilterResourcesUseCase();

  void updateFilter() {
    if (!energySensorFilterIsActive &&
        !criticalStatusFilterIsActive &&
        filteredName == null) {
      filterController.add(null);
      return;
    }
    final newFilter = <String>{};
    if (energySensorFilterIsActive) {
      newFilter.addAll(filteredEnergySensor!);
    }
    if (criticalStatusFilterIsActive) {
      if (newFilter.isEmpty) {
        newFilter.addAll(filteredCriticalStatus!);
      } else {
        newFilter.intersection(filteredCriticalStatus!);
      }
    }
    if (filteredName != null) {
      if (newFilter.isEmpty) {
        newFilter.addAll(filteredName!);
      } else {
        newFilter.intersection(filteredName!);
      }
    }
    filterController.add(newFilter);
  }

  StreamController<Set<String>?> filterController =
      StreamController<Set<String>?>();

  @override
  void initState() {
    super.initState();
    filterController.add(null);
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await filterController.close();
  }

  @override
  Widget build(BuildContext context) {
    final resources = widget.resources;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
          child: SizedBox(
            height: 36,
            child: TextField(
              onChanged: (newValue) {
                if (newValue.isEmpty) {
                  filteredName = null;
                  updateFilter();
                  return;
                }
                final sanitizedNewValue = newValue.trim().toLowerCase();
                filteredName = filterResourcesUseCase(
                    resources: resources,
                    query: (e) =>
                        e.name.toLowerCase().contains(sanitizedNewValue));
                updateFilter();
              },
              style: const TextStyle(fontSize: 14),
              textAlignVertical: TextAlignVertical.center,
              decoration: const InputDecoration(
                filled: true,
                prefixIcon: Icon(Icons.search, color: Color(0xFF8E98A3)),
                border: OutlineInputBorder(borderSide: BorderSide.none),
                fillColor: Color(0xFFEAEFF3),
                contentPadding: EdgeInsets.zero,
                hintText: 'Search',
                hintStyle: TextStyle(fontSize: 14, color: Color(0xFF8E98A3)),
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
                    EdgeInsets.only(left: 16),
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
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
                    EdgeInsets.only(left: 16),
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                onPressed: () {},
                child: Row(
                  children: [
                    _kAlertIcon,
                    const SizedBox(width: 6),
                    const Text(
                      'Crítico',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: StreamBuilder(
            stream: filterController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final filteredIds = snapshot.data;
              final Iterable<Resource> filteredTopLevelResources;
              if (filteredIds == null) {
                filteredTopLevelResources = resources;
              } else {
                filteredTopLevelResources =
                    resources.where((e) => filteredIds.contains(e.id));
              }
              return ListView.builder(
                itemCount: filteredTopLevelResources.length,
                itemBuilder: (context, index) => ResourcePresentationWidget(
                  resource: filteredTopLevelResources.elementAt(index),
                  filteredResources: filteredIds,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
