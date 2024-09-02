import 'dart:math' as math;

import 'package:asset_viewer/constants.dart';
import 'package:asset_viewer/domain/entities/resource.dart';
import 'package:asset_viewer/theme.dart';
import 'package:flutter/material.dart';

const _kComponentHeight = 28.0;
const _kIconHeight = 22.0;
const _kExpandedIcon = Icon(
  Icons.expand_more,
  size: _kIconHeight,
);
const _kNonExpansibleIcon = SizedBox(
  width: _kIconHeight,
);
const _kVerticalDivider = VerticalDivider(
  width: _kIconHeight,
  thickness: 1,
  color: Colors.grey,
);
final _kCollapsedIcon = Transform.rotate(
  angle: -math.pi / 2,
  child: _kExpandedIcon,
);
final _kCriticalIcon = ImageIcon(
  color: Colors.red,
  size: _kIconHeight,
  AssetImage(kAssets.resourceWidget.critical),
);
final _kEnergyIcon = ImageIcon(
  color: Colors.green,
  size: _kIconHeight,
  AssetImage(kAssets.resourceWidget.energy),
);
final _kLocationIcon = ImageIcon(
  size: _kIconHeight,
  AssetImage(kAssets.resourceWidget.location),
  color: kPrimaryColor,
);
final _kAssetIcon = ImageIcon(
  size: _kIconHeight,
  AssetImage(kAssets.resourceWidget.asset),
  color: kPrimaryColor,
);
final _kComponentIcon = ImageIcon(
  size: _kIconHeight,
  AssetImage(kAssets.resourceWidget.component),
  color: kPrimaryColor,
);

class _ComponentPresentationWidget extends StatelessWidget {
  Set<String>? get filteredResources => null;

  final Component resource;
  final int indentCount;
  const _ComponentPresentationWidget({
    required this.resource,
    this.indentCount = 0,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          ...List.generate(indentCount, (i) => _kVerticalDivider),
          _kNonExpansibleIcon,
          _kComponentIcon,
          Text(
            resource.name,
            style: const TextStyle(fontSize: 14),
          ),
          if (resource.sensorType == kEnergySensorType) _kEnergyIcon,
          if (resource.status == kCriticalStatus) _kCriticalIcon,
        ],
      );
}

class ResourcePresentationWidget extends StatelessWidget {
  final Resource resource;
  final Set<String>? filteredResources;
  final int indentCount;
  const ResourcePresentationWidget({
    required this.resource,
    this.indentCount = 0,
    this.filteredResources,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    switch (resource) {
      case Location():
      case Asset():
        if (_isExpansible(resource, filteredResources)) {
          return SizedBox(
            child: _ExpansibleLocationOrAssetPresentationWidget(
              resource: resource,
              filteredResources: filteredResources,
              indentCount: indentCount,
            ),
          );
        }
        return SizedBox(
          height: _kComponentHeight,
          child: _NonExpansibleLocationOrAssetPresentationWidget(
            resource: resource,
            indentCount: indentCount,
          ),
        );
      case final Component c:
        return SizedBox(
          height: _kComponentHeight,
          child: _ComponentPresentationWidget(
            resource: c,
            indentCount: indentCount,
          ),
        );
    }
  }
}

class _NonExpansibleLocationOrAssetPresentationWidget extends StatelessWidget {
  final Resource resource;
  final int indentCount;
  const _NonExpansibleLocationOrAssetPresentationWidget({
    required this.resource,
    this.indentCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final leadingIcon = switch (resource) {
      Location() => _kLocationIcon,
      Asset() => _kAssetIcon,
      Component() => throw TypeError(),
    };
    return Row(
      children: [
        ...List.generate(indentCount, (i) => _kVerticalDivider),
        _kNonExpansibleIcon,
        leadingIcon,
        Text(
          resource.name,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

class _ExpansibleLocationOrAssetPresentationWidget extends StatefulWidget {
  final Resource resource;
  final Set<String>? filteredResources;
  final int indentCount;

  /// ## Parameters
  /// - Set<String>? filteredResources: Contains the ids of each children
  /// that may be printed. If this list is null, every children may be printed.
  const _ExpansibleLocationOrAssetPresentationWidget({
    required this.resource,
    this.indentCount = 0,
    this.filteredResources,
  });

  @override
  State<_ExpansibleLocationOrAssetPresentationWidget> createState() =>
      _ExpansibleLocationOrAssetPresentationWidgetState();
}

class _ExpansibleLocationOrAssetPresentationWidgetState
    extends State<_ExpansibleLocationOrAssetPresentationWidget> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    final resource = widget.resource;
    final indentCount = widget.indentCount;
    final filteredResources = widget.filteredResources;
    final leadingIcon = switch (resource) {
      Location() => _kLocationIcon,
      Asset() => _kAssetIcon,
      Component() => throw TypeError(),
    };
    final children = <ResourcePresentationWidget>[];
    switch (resource) {
      case Location():
        if (expanded) {
          for (final subLocation in resource.subLocations) {
            if (filteredResources == null ||
                filteredResources.contains(subLocation.id)) {
              children.add(
                ResourcePresentationWidget(
                  resource: subLocation,
                  filteredResources: filteredResources,
                  indentCount: indentCount + 1,
                ),
              );
            }
          }
          for (final subAsset in resource.subAssets) {
            if (filteredResources == null ||
                filteredResources.contains(subAsset.id)) {
              children.add(
                ResourcePresentationWidget(
                  resource: subAsset,
                  filteredResources: filteredResources,
                  indentCount: indentCount + 1,
                ),
              );
            }
          }
          for (final subComponent in resource.subComponents) {
            if (filteredResources == null ||
                filteredResources.contains(subComponent.id)) {
              children.add(
                ResourcePresentationWidget(
                  resource: subComponent,
                  filteredResources: filteredResources,
                  indentCount: indentCount + 1,
                ),
              );
            }
          }
        } else {}
      case Asset():
        if (expanded) {
          for (final subAsset in resource.subAssets) {
            if (filteredResources == null ||
                filteredResources.contains(subAsset.id)) {
              children.add(
                ResourcePresentationWidget(
                  resource: subAsset,
                  filteredResources: filteredResources,
                  indentCount: indentCount + 1,
                ),
              );
            }
          }
          for (final subComponent in resource.subComponents) {
            if (filteredResources == null ||
                filteredResources.contains(subComponent.id)) {
              children.add(
                ResourcePresentationWidget(
                  resource: subComponent,
                  filteredResources: filteredResources,
                  indentCount: indentCount + 1,
                ),
              );
            }
          }
        }

      case Component():
        throw TypeError();
    }
    return Column(
      children: [
        Row(
          children: [
            ...List.generate(
              indentCount,
              (i) => const SizedBox(
                  height: _kComponentHeight, child: _kVerticalDivider),
            ),
            InkWell(
              onTap: () => setState(() {
                expanded = !expanded;
              }),
              radius: 8,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SizedBox(
                  height: _kComponentHeight,
                  child: Row(
                    children: [
                      if (expanded) _kExpandedIcon else _kCollapsedIcon,
                      leadingIcon,
                      Text(
                        widget.resource.name,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (expanded) ...children,
      ],
    );
  }
}

bool _isExpansible(Resource resource, Set<String>? filteredResources) {
  switch (resource) {
    case Location():
      for (final subLocation in resource.subLocations) {
        if (filteredResources == null ||
            filteredResources.contains(subLocation.id)) {
          return true;
        }
      }
      for (final subAsset in resource.subAssets) {
        if (filteredResources == null ||
            filteredResources.contains(subAsset.id)) {
          return true;
        }
      }
      for (final subComponent in resource.subComponents) {
        if (filteredResources == null ||
            filteredResources.contains(subComponent.id)) {
          return true;
        }
      }
    case Asset():
      for (final subAsset in resource.subAssets) {
        if (filteredResources == null ||
            filteredResources.contains(subAsset.id)) {
          return true;
        }
      }
      for (final subComponent in resource.subComponents) {
        if (filteredResources == null ||
            filteredResources.contains(subComponent.id)) {
          return true;
        }
      }

    case Component():
      return false;
  }
  return false;
}
