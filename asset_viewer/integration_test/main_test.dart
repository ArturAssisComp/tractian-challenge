import 'package:asset_viewer/constants.dart';
import 'package:asset_viewer/main.dart' as main_app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  const companyName = 'Jaguar';
  const topLevelAssets = [
    'Empty Machine house',
    'Machinery house',
    'PRODUCTION AREA - RAW MATERIAL',
    'Fan - External',
  ];

  const machineryHouse1 = 'Machinery house';
  const machineryHouse2 = 'Motors H12D';
  const expectedMachineryHouseComponents = [
    'Motor H12D- Stage 1',
    'Motor H12D-Stage 2',
    'Motor H12D-Stage 3',
  ];

  const fanExternal = 'Fan - External';

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test for the Jaguar company', (tester) async {
    main_app.main();
    await tester.pumpAndSettle();
    final companyButton = find.textContaining(companyName);
    expect(companyButton, findsOneWidget);

    await tester.tap(companyButton);
    await tester.pumpAndSettle();

    // finders
    final searchFinder = find.byType(TextField);

    final criticalFilterFinder = find.byWidgetPredicate(
      (widget) =>
          widget is ImageIcon &&
          widget.image is AssetImage &&
          (widget.image! as AssetImage).assetName == kAssets.alertIcon,
    );
    final energyFilterFinder = find.byWidgetPredicate(
      (widget) =>
          widget is ImageIcon &&
          widget.image is AssetImage &&
          (widget.image! as AssetImage).assetName ==
              kAssets.outlinedEnergySensor,
    );
    final locationIconFinder = find.byWidgetPredicate(
      (widget) =>
          widget is ImageIcon &&
          widget.image is AssetImage &&
          (widget.image! as AssetImage).assetName ==
              kAssets.resourceWidget.location,
    );
    final componentIconFinder = find.byWidgetPredicate(
      (widget) =>
          widget is ImageIcon &&
          widget.image is AssetImage &&
          (widget.image! as AssetImage).assetName ==
              kAssets.resourceWidget.component,
    );
    final energyIconFinder = find.byWidgetPredicate(
      (widget) =>
          widget is ImageIcon &&
          widget.image is AssetImage &&
          (widget.image! as AssetImage).assetName ==
              kAssets.resourceWidget.energy,
    );
    final criticalIconFinder = find.byWidgetPredicate(
      (widget) =>
          widget is ImageIcon &&
          widget.image is AssetImage &&
          (widget.image! as AssetImage).assetName ==
              kAssets.resourceWidget.critical,
    );

    // Initial check
    for (final topLevel in topLevelAssets) {
      expect(find.text(topLevel), findsOneWidget);
    }
    expect(criticalFilterFinder, findsOneWidget);
    expect(energyFilterFinder, findsOneWidget);
    expect(locationIconFinder, findsExactly(3));
    expect(componentIconFinder, findsOneWidget);
    expect(energyIconFinder, findsOneWidget);
    expect(criticalIconFinder, findsNothing);

    // act1 - filter for 'fan -'
    await tester.enterText(searchFinder, 'fan -');
    await tester.pumpAndSettle();

    // check 1
    expect(find.text(fanExternal), findsOneWidget);
    expect(energyIconFinder, findsOneWidget);

    // act2 - erase the text, and filter by energy sensor
    await tester.enterText(searchFinder, '');
    await tester.tap(energyFilterFinder);
    await tester.pumpAndSettle();

    // check 2
    expect(find.text(fanExternal), findsOneWidget);
    expect(energyIconFinder, findsOneWidget);

    // act3 - deactivate the filter by energy sensor, activate the filter for
    // critical, and expand machinery house
    await tester.tap(energyFilterFinder);
    await tester.tap(criticalFilterFinder);
    await tester.pumpAndSettle();
    await tester.tap(find.text(machineryHouse1));
    await tester.pumpAndSettle();
    await tester.tap(find.text(machineryHouse2));
    await tester.pumpAndSettle();

    // check 3
    for (final machineryComponent in expectedMachineryHouseComponents) {
      expect(find.text(machineryComponent), findsOneWidget);
    }
    expect(locationIconFinder, findsOneWidget);
    expect(componentIconFinder, findsExactly(3));
    expect(energyIconFinder, findsNothing);
    expect(criticalIconFinder, findsExactly(3));
  });
}

/*
  // Those are the company's data
  "662fd0ee639069143a8fc387": {
    "assets": [
      {
        "id": "656a07bbf2d4a1001e2144c2",
        "locationId": "656a07b3f2d4a1001e2144bf",
        "name": "CONVEYOR BELT ASSEMBLY",
        "parentId": null,
        "sensorType": null,
        "status": null
      },
      {
        "gatewayId": "QHI640",
        "id": "656734821f4664001f296973",
        "locationId": null,
        "name": "Fan - External",
        "parentId": null,
        "sensorId": "MTC052",
        "sensorType": "energy",
        "status": "operating"
      },
      {
        "id": "656734448eb037001e474a62",
        "locationId": "656733b1664c41001e91d9ed",
        "name": "Fan H12D",
        "parentId": null,
        "sensorType": null,
        "status": null
      },
      {
        "gatewayId": "FRH546",
        "id": "656a07cdc50ec9001e84167b",
        "locationId": null,
        "name": "MOTOR RT COAL AF01",
        "parentId": "656a07c3f2d4a1001e2144c5",
        "sensorId": "FIJ309",
        "sensorType": "vibration",
        "status": "operating"
      },
      {
        "id": "656a07c3f2d4a1001e2144c5",
        "locationId": null,
        "name": "MOTOR TC01 COAL UNLOADING AF02",
        "parentId": "656a07bbf2d4a1001e2144c2",
        "sensorType": null,
        "status": null
      },
      {
        "gatewayId": "QBK282",
        "id": "6567340c1f4664001f29622e",
        "locationId": null,
        "name": "Motor H12D- Stage 1",
        "parentId": "656734968eb037001e474d5a",
        "sensorId": "CFX848",
        "sensorType": "vibration",
        "status": "alert"
      },
      {
        "gatewayId": "VHS387",
        "id": "6567340c664c41001e91dceb",
        "locationId": null,
        "name": "Motor H12D-Stage 2",
        "parentId": "656734968eb037001e474d5a",
        "sensorId": "GYB119",
        "sensorType": "vibration",
        "status": "alert"
      },
      {
        "gatewayId": "VZO694",
        "id": "656733921f4664001f295e9b",
        "locationId": null,
        "name": "Motor H12D-Stage 3",
        "parentId": "656734968eb037001e474d5a",
        "sensorId": "SIF016",
        "sensorType": "vibration",
        "status": "alert"
      },
      {
        "id": "656734968eb037001e474d5a",
        "locationId": "656733b1664c41001e91d9ed",
        "name": "Motors H12D",
        "parentId": null,
        "sensorType": null,
        "status": null
      }
    ],
    "locations": [
      {
        "id": "656a07b3f2d4a1001e2144bf",
        "name": "CHARCOAL STORAGE SECTOR",
        "parentId": "65674204664c41001e91ecb4"
      },
      {
        "id": "656733611f4664001f295dd0",
        "name": "Empty Machine house",
        "parentId": null
      },
      {
        "id": "656733b1664c41001e91d9ed",
        "name": "Machinery house",
        "parentId": null
      },
      {
        "id": "65674204664c41001e91ecb4",
        "name": "PRODUCTION AREA - RAW MATERIAL",
        "parentId": null
      }
    ]
  },
*/
