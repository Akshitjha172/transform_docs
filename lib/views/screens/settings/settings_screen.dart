/**
 * @author Akshit Jha
 * Creation Date: 11-12-2024
 */
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transform_docs/local_services/local_auth_service/local_auth_service.dart';
import 'package:transform_docs/main.dart';
import 'package:transform_docs/repo/preferences/preference_keys.dart';
import 'package:transform_docs/res/colors/app_colors.dart';
import 'package:transform_docs/res/image/app_image.dart';
import 'package:transform_docs/utils/constants.dart';
import 'package:transform_docs/utils/restart_widget.dart';
import 'package:transform_docs/viewmodels/local_auth_viewmodel/local_auth_viewmodel.dart';
import 'package:transform_docs/views/screens/settings/widgets/custom_bottom_sheet.dart';
import 'package:transform_docs/views/screens/settings/widgets/preferences_card.dart';
import 'package:transform_docs/views/widgets/custom_appbar.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'settings';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<SettingsScreen> {
  final LocalAuthViewmodel localAuthViewmodel = Get.put(LocalAuthViewmodel());
  LocalAuthService localAuthService = LocalAuthService();
  String selectedLanguage = "";
  String? storedLang;

  final List<String> languages = [
    'English',
    'हिंदी',
    'ಕನ್ನಡ',
  ];

  @override
  void initState() {
    super.initState();
    getLangValues();
  }

  getLangValues() async {
    storedLang = await preferences.getString(PreferenceKeys.SELECTED_LANG);
    selectedLanguage = storedLang ?? "English";
    log("Selected language $selectedLanguage");
    localAuthViewmodel.isAuthEnabled =
        await preferences.getBool(PreferenceKeys.LOCAL_AUTH_ENABLED) ?? false;
    log("Profile Screen InitState - Local Auth Enabled: ${localAuthViewmodel.isAuthEnabled}");
    setState(() {});
  }

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: Constants.settingsTitle),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  // const SizedBox(height: 100),
                  Padding(
                    padding:
                        EdgeInsets.all(8.0), // Adjust the padding as needed
                    child: CircleAvatar(
                      radius: 40, // Circle radius
                      backgroundImage:
                          AssetImage(AppImages.appIcon), // Set the image
                    ),
                  ),
                  Text(
                    tr(Constants.settingsTitle),
                    style: TextStyle(fontSize: 34),
                  ),
                  _buildPreferencesSection(size),
                  SizedBox(height: 20),
                  Text(
                    tr(Constants.appVersion),
                    style: TextStyle(fontSize: 14),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build the preferences section
  Widget _buildPreferencesSection(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${tr(Constants.preferencesTitle)}:',
          style: GoogleFonts.roboto(
            color: AppColors.tertiaryTextIconColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        // Language Preference
        _buildPreferenceCard(
          title: tr(Constants.langText),
          value: selectedLanguage,
          items: languages,
          onItemSelected: (String selected) {
            setState(() {
              selectedLanguage = selected;
            });
            _changeLanguage(selected);
          },
        ),
        SizedBox(height: 10),
        // Notification Preference
        // _buildPreferenceCard(
        //   title: tr(Constants.notificationTitle),
        //   value: selectedNotification,
        //   items: [tr(Constants.onTitle), tr(Constants.offTitle)],
        //   onItemSelected: (selected) {
        //     setState(() {
        //       selectedNotification = selected;
        //     });
        //   },
        // ),

        SizedBox(height: 10),

        // Biometric Lock toggle button

        GetBuilder<LocalAuthViewmodel>(builder: (controller) {
          return _buildPreferenceCard(
            title: tr(Constants.enableAppLock),
            value: localAuthViewmodel.isAuthEnabled == true
                ? tr(Constants.onTitle)
                : tr(Constants.offTitle),
            items: [tr(Constants.onTitle), tr(Constants.offTitle)],
            onItemSelected: (selected) async {
              /// Enabling the App Lock
              if (selected == tr(Constants.onTitle)) {
                localAuthViewmodel.enableAuthLock(true, localAuthService);
              } else {
                localAuthViewmodel.enableAuthLock(false, localAuthService);
              }
              log("Bool Value from OnSelected Method -:  ${localAuthViewmodel.isAuthEnabled}");
              setState(() {});
            },
          );
        })

        // SizedBox(height: 50.h),
      ],
    );
  }

  // Widget to build a single preference card
  Widget _buildPreferenceCard({
    required String title,
    required String value,
    required List<String> items,
    required Function(String) onItemSelected,
  }) {
    return InkWell(
      onTap: () {
        _showBottomSheet(context, title, items, onItemSelected, value);
      },
      child: PreferencesCard(
        title: title,
        value: value,
      ),
    );
  }

  // Function to show bottom sheet for selecting preference options
  void _showBottomSheet(
    BuildContext context,
    String title,
    List<String> items,
    Function(String) onItemSelected,
    String initialSelection,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CustomProfileBottomSheet(
        size: MediaQuery.of(context).size,
        title: title,
        items: items,
        onItemSelected: onItemSelected,
        selectedItem: initialSelection,
      ),
    );
  }

  Future<void> _changeLanguage(String? newValue) async {
    if (newValue == null) return;

    // Storing the selected value
    await preferences.setString(PreferenceKeys.SELECTED_LANG, newValue);

    // Execute the asynchronous work outside of setState()
    if (newValue == Constants.hindiTitle) {
      // ignore: use_build_context_synchronously
      await context.setLocale(const Locale('hi', 'IN'));
    }
    if (newValue == Constants.englishTitle) {
      // ignore: use_build_context_synchronously
      await context.setLocale(const Locale('en', 'US'));
    }
    if (newValue == Constants.kannadaTitle) {
      // ignore: use_build_context_synchronously
      await context.setLocale(const Locale('kn', 'IN'));
    }

    // Now, update the state synchronously
    setState(() {
      selectedLanguage = newValue;
    });

    // Optionally, trigger a hard refresh
    await forceAppUpdate();
  }

  forceAppUpdate() async {
    RestartWidget.restartApp(context);
  }
}
