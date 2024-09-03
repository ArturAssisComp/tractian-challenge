import 'package:asset_viewer/pages/asset_page.dart';
import 'package:asset_viewer/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter generateRouter() => GoRouter(
      routes: [
        GoRoute(
          path: HomePage.path,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const HomePage(),
          ),
          routes: [
            GoRoute(
              path: AssetPage.path,
              pageBuilder: (context, state) {
                // TODO(ArturAssisComp): add a cache to store the company id
                // in the case extra is empty.
                final extra = state.extra! as Map<String, String>;
                final companyId = extra['id'] ?? '662fd0fab3fd5656edb39af5';
                final companyName = extra['name'] ?? 'Tobias';
                return MaterialPage(
                  key: state.pageKey,
                  child: AssetPage(
                    companyId: companyId,
                    companyName: companyName,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
