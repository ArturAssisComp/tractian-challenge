import 'dart:async';

import 'package:asset_viewer/constants.dart';
import 'package:asset_viewer/domain/entities/company.dart';
import 'package:asset_viewer/domain/exceptions_and_errors.dart';
import 'package:asset_viewer/domain/use_cases/get_companies_use_case.dart';
import 'package:asset_viewer/l10n/l10n.dart';
import 'package:asset_viewer/pages/asset_page.dart';
import 'package:asset_viewer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  static const path = '/';
  static const url = '/';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Company>> futureCompanies;
  bool failed = false;

  Future<void> _updateCompanies() async {
    try {
      setState(() {
        futureCompanies = getIt<GetCompaniesUseCase>()();
        failed = false;
      });
    } on GetCompaniesException {
      setState(() {
        failed = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    unawaited(_updateCompanies());
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Image.asset(
              kAssets.tractianLogo,
              width: 126,
              height: 17,
            ),
          ),
          body: FutureBuilder(
            future: futureCompanies,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data == null || failed) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.l10n.retryFetchCompaniesMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _updateCompanies,
                        child: Text(
                          context.l10n.retry,
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              final companies = snapshot.data!;
              return ListView.separated(
                padding: const EdgeInsets.only(top: 30, left: 21, right: 22),
                itemCount: companies.length,
                itemBuilder: (context, index) => ListTile(
                  horizontalTitleGap: 16,
                  contentPadding:
                      const EdgeInsets.only(left: 32, top: 24, bottom: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  leading: ImageIcon(
                    AssetImage(kAssets.companyIcon),
                    size: 24,
                  ),
                  title: Text(
                    context.l10n.companyUnit(companies[index].name),
                    style: const TextStyle(fontSize: 18),
                  ),
                  onTap: () => context.go(
                    AssetPage.url,
                    extra: {
                      'id': companies[index].id,
                      'name': companies[index].name,
                    },
                  ),
                ),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 40,
                ),
              );
            },
          ),
        ),
      );
}
