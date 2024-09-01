import 'package:asset_viewer/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter generateRouter() => GoRouter(routes: [
      GoRoute(
          path: '/',
          pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: HomePage(),
              )),
    ]);
