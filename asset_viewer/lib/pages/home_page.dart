import 'package:asset_viewer/constants.dart';
import 'package:asset_viewer/domain/use_cases/get_companies_use_case.dart';
import 'package:asset_viewer/pages/asset_page.dart';
import 'package:asset_viewer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  static const path = '/';
  static const url = '/';
  const HomePage({super.key});

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
            //ignore: discarded_futures
            future: getIt<GetCompaniesUseCase>()(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
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
                    '${companies[index].name} Unit',
                    style: const TextStyle(fontSize: 18),
                  ),
                  onTap: () =>
                      context.go(AssetPage.url, extra: companies[index].id),
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
