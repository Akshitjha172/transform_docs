// ignore_for_file: unused_element, prefer_const_constructors, deprecated_member_use, use_build_context_synchronously
/**
 * @author Akshit Jha
 * Creation Date: 11-12-2024
 */
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:transform_docs/local_services/local_auth_service/local_auth_service.dart';
import 'package:transform_docs/main.dart';
import 'package:transform_docs/repo/preferences/preference_keys.dart';
import 'package:transform_docs/viewmodels/local_auth_viewmodel/local_auth_viewmodel.dart';
import 'package:transform_docs/views/screens/bottom_navbar/bottom_navbar.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LockScreen> {
  late BuildContext context;
  LocalAuthService localAuthService = LocalAuthService();
  LocalAuthViewmodel localAuthViewModel = Get.put(LocalAuthViewmodel());
  void checkIfLockAvailable(BuildContext context) async {
    log("Checking if lock is available, Method called");
    final isEnabled = preferences.getBool(PreferenceKeys.PIN_LOCK_ENABLED);
    final lockPin = preferences.getString(PreferenceKeys.PIN_LOCK);

    /// When the lock is enabled then show the lock screen.
    if (isEnabled == true && isEnabled != null && lockPin != null) {
      screenLock(
          context: context,
          correctString: lockPin,
          canCancel: false,
          cancelButton: const Icon(
            Icons.clear,
            size: 30,
            color: Colors.white,
          ),
          onCancelled: () {
            Navigator.pop(context);
          },
          useBlur: false,
          customizedButtonChild: localAuthViewModel.isAuthEnabled == true
              ? const Icon(
                  Icons.fingerprint,
                  color: Colors.white,
                )
              : const SizedBox(),
          customizedButtonTap: localAuthViewModel.isAuthEnabled == true
              ? () async {
                  bool authValue =
                      await localAuthService.authenticate(canCancel: true);
                  if (authValue) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNavBar()));
                  }
                }
              : () {},
          onOpened: () async {
            bool authValue =
                await localAuthService.authenticate(canCancel: true);
            if (authValue) {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BottomNavBar()));
            }
          },
          onUnlocked: () {
            Navigator.pop(context);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const BottomNavBar()));
          },
          title: const Text(
            "Enter your PIN",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          config: ScreenLockConfig(
            backgroundColor: Colors.black,
            buttonStyle: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              foregroundColor: MaterialStateProperty.all(Colors.black),
            ),
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ));

      /// When the lock is not enabled make user to setup pin.
    } else {
      screenLockCreate(
        context: context,
        canCancel: false,
        onCancelled: () {
          Navigator.pop(context);
        },
        useBlur: false,
        config: ScreenLockConfig(
          backgroundColor: Colors.black,
          buttonStyle: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(Colors.black),
          ),
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        title: const Text(
          "Create your PIN",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cancelButton: const Icon(
          Icons.clear,
          size: 30,
          color: Colors.white,
        ),
        onConfirmed: (value) {
          preferences.setBool(PreferenceKeys.PIN_LOCK_ENABLED, true);
          preferences.setString(PreferenceKeys.PIN_LOCK, value);
          Navigator.pop(context);

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const BottomNavBar()));
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    localAuthViewModel.onInit();
    Future.delayed(const Duration(milliseconds: 500), () {
      checkIfLockAvailable(context);
    });
  }

  @override
  Widget build(BuildContext context2) {
    context = context2;
    return const Scaffold(
        body: Padding(
      padding: EdgeInsets.all(16),
      child: Center(),
    ));
  }
}
