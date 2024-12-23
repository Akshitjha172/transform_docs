/**
 * @author Akshit Jha
 * Creation Date: 11-12-2024
 */
import 'dart:developer';
import 'package:get/get.dart';
import 'package:transform_docs/local_services/local_auth_service/local_auth_service.dart';
import 'package:transform_docs/main.dart';
import 'package:transform_docs/repo/preferences/preference_keys.dart';

class LocalAuthViewmodel extends GetxController {
  bool isAuthEnabled = false;
  bool isAuthenticated = false;

  @override
  void onInit() {
    super.onInit();
    bool value =
        preferences.getBool(PreferenceKeys.LOCAL_AUTH_ENABLED) ?? false;
    isAuthEnabled = value;
    log("Local Auth Enabled: $value");
  }

  void authenticated(bool newValue) async {
    isAuthenticated = newValue;
    log("User Authentication Value: $isAuthenticated");
    log("Is Auth Enabled: $isAuthEnabled");
  }

  void enableAuthLock(bool newValue, LocalAuthService localAuthService) async {
    log("Enable Auth Lock Function called from : $newValue");
    if (newValue == true) {
      bool value = await localAuthService.authenticate();
      if (value == true) {
        await preferences
            .setBool(PreferenceKeys.LOCAL_AUTH_ENABLED, true)
            .then((value) {
          isAuthEnabled = true;
          log("True Value saved in shared preferences: $value");
        });
      } else {
        isAuthEnabled = false;
      }
    } else {
      bool value = await localAuthService.authenticate();
      if (value == true) {
        await preferences
            .setBool(PreferenceKeys.LOCAL_AUTH_ENABLED, false)
            .then((value) {
          isAuthEnabled = false;
          log("False Value saved in shared preferences: $value");
        });
      } else {
        isAuthEnabled = true;
      }
    }
    update();
  }
}
