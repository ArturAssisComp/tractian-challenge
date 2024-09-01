import 'package:asset_viewer/data/data_provider/companies_api.dart';
import 'package:asset_viewer/data/data_provider/constants.dart';
import 'package:asset_viewer/data/repository/companies_repository.dart';
import 'package:asset_viewer/domain/use_cases/get_companies_use_case.dart';
import 'package:asset_viewer/pages/asset_page.dart';
import 'package:asset_viewer/routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  static const path = '/';
  static const url = '/';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder(
          future: GetCompaniesUseCase(
              companiesRepository: CompaniesRepository(
                  companiesApi: CompaniesApi(dio: Dio(kDioOptions))))(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
            }
            final companies = snapshot.data!;
            return ListView.builder(
              itemCount: companies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(companies[index].name),
                  onTap: () =>
                      context.go(AssetPage.url, extra: companies[index].id),
                );
              },
            );
          },
        ),
      );
}
