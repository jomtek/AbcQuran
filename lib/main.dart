import 'package:abc_quran/providers/settings/settings_provider.dart';
import 'package:abc_quran/ui/app/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

import 'localization/app_localization.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final settings = ref.watch(settingsProvider);

        return ScreenUtilInit(
          builder: (BuildContext context, Widget? child) {
            return MaterialApp.router(
              routerDelegate: _appRouter.delegate(),
              routeInformationParser: _appRouter.defaultRouteParser(),
              debugShowCheckedModeBanner: false,
              locale: Locale(settings.languageId),
              localizationsDelegates: const [
                // Provides custom localized strings
                AppLocalizationDelegate(),
                // Provides basic localized strings
                GlobalMaterialLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('ar'),
                Locale('fr'),
                Locale('es'),
              ],
            );
          },
        );
      },
    );
  }
}
