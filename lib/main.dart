/**
 * @author Akshit Jha
 * Creation Date: 11-12-2024
 */
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transform_docs/local_services/local_auth_service/local_auth_service.dart';
import 'package:transform_docs/utils/restart_widget.dart';
import 'package:transform_docs/viewmodels/local_auth_viewmodel/local_auth_viewmodel.dart';
import 'package:transform_docs/views/screens/bottom_navbar/bottom_navbar.dart';

late SharedPreferences preferences;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _init();
  // Initialize EasyLocalization
  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
    supportedLocales: const [
      Locale('en', 'US'),
      Locale('hi', 'IN'),
      Locale('kn', 'IN')
    ],
    path: 'assets/langs',
    fallbackLocale: const Locale('en', 'US'),
    child: RestartWidget(child: MyApp()),
  ));
}

Future<void> _init() async {
  // Register Preferences instance
  /// Initializing SharedPreferences Instance
  preferences = await SharedPreferences.getInstance();
  // Set the orientation to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _FileExtractionAppState();
}

class _FileExtractionAppState extends State<MyApp> with WidgetsBindingObserver {
  LocalAuthViewmodel controller = Get.put(LocalAuthViewmodel());
  LocalAuthService localAuthService = LocalAuthService();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      if (controller.isAuthenticated == false &&
          controller.isAuthEnabled == true) {
        localAuthService.authenticate().then((value) {
          log("User Authenticated: $value");
        });
      }
      // The app has come into the foreground
      log("App is in the foreground");

      // You can perform your foreground-related operations here
    } else if (state == AppLifecycleState.paused) {
      // The app is going into the background
      log("App is in the background");
      controller.authenticated(false);
      // You can perform your background-related operations here
    }
  }

  @override
  void initState() {
    super.initState();
    controller.onInit();
    // Register the observer
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Unregister the observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BottomNavBar(),
    );
  }
}
