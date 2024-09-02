import 'dart:async';
import 'package:asset_viewer/constants.dart';
import 'package:asset_viewer/domain/entities/resource.dart';
import 'package:asset_viewer/domain/use_cases/filter_resources_use_case.dart';
import 'package:asset_viewer/domain/use_cases/get_resources_use_case.dart';
import 'package:asset_viewer/l10n/l10n.dart';
import 'package:asset_viewer/service_locator.dart';
import 'package:asset_viewer/theme.dart';
import 'package:asset_viewer/widgets/resource_presentation_widget.dart';
import 'package:flutter/material.dart';

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
            context.l10n.assets,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        body: FutureBuilder(
          // ignore: discarded_futures
          future: getIt<GetResourcesUseCase>()(companyId: companyId),
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
  String stringToFilter = '';
  bool energySensorFilterIsActive = false;
  bool criticalStatusFilterIsActive = false;
  final filterResourcesUseCase = getIt<FilterResourcesUseCase>();

  bool stringFilter(Resource r) =>
      r.name.toLowerCase().contains(stringToFilter);
  bool criticalStatusFilter(Resource r) =>
      r is Component && r.status == kCriticalStatus;
  bool energySensorFilter(Resource r) =>
      r is Component && r.sensorType == kEnergySensorType;

  void updateFilter() {
    if (!energySensorFilterIsActive &&
        !criticalStatusFilterIsActive &&
        stringToFilter.isEmpty) {
      filterController.add(null);
      return;
    }
    filterController.add(
      filterResourcesUseCase(
        resources: widget.resources,
        query: (e) {
          if (energySensorFilterIsActive && !energySensorFilter(e)) {
            return false;
          }
          if (criticalStatusFilterIsActive && !criticalStatusFilter(e)) {
            return false;
          }
          if (!stringFilter(e)) {
            return false;
          }
          return true;
        },
      ),
    );
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
                stringToFilter = newValue.trim().toLowerCase();
                updateFilter();
              },
              style: const TextStyle(fontSize: 14),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                filled: true,
                prefixIcon: const Icon(Icons.search, color: Color(0xFF8E98A3)),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                fillColor: const Color(0xFFEAEFF3),
                contentPadding: EdgeInsets.zero,
                hintText: context.l10n.search,
                hintStyle:
                    const TextStyle(fontSize: 14, color: Color(0xFF8E98A3)),
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
                  backgroundColor: WidgetStateProperty.resolveWith((_) {
                    if (energySensorFilterIsActive) {
                      return kPrimaryColor;
                    }
                    return null;
                  }),
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
                onPressed: () {
                  setState(() {
                    energySensorFilterIsActive = !energySensorFilterIsActive;
                  });
                  updateFilter();
                },
                child: Row(
                  children: [
                    ImageIcon(
                      size: 16,
                      AssetImage(kAssets.outlinedEnergySensor),
                      color: energySensorFilterIsActive ? Colors.white : null,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      context.l10n.energySensor,
                      style: TextStyle(
                        fontSize: 14,
                        color: energySensorFilterIsActive ? Colors.white : null,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((_) {
                    if (criticalStatusFilterIsActive) {
                      return kPrimaryColor;
                    }
                    return null;
                  }),
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
                onPressed: () {
                  setState(() {
                    criticalStatusFilterIsActive =
                        !criticalStatusFilterIsActive;
                  });
                  updateFilter();
                },
                child: Row(
                  children: [
                    ImageIcon(
                      size: 16,
                      AssetImage(kAssets.alertIcon),
                      color: criticalStatusFilterIsActive ? Colors.white : null,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      context.l10n.critical,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            criticalStatusFilterIsActive ? Colors.white : null,
                      ),
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
