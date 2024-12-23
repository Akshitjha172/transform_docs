/**
 * @author Akshit Jha
 * Creation Date: 12-12-2024
 */

import 'package:transform_docs/views/screens/bottom_navbar/bottom_navbar.dart';
import 'package:transform_docs/views/screens/extracted_data_screen/extracted_data_screen.dart';
import 'package:transform_docs/views/screens/home/home_screen.dart';
import 'package:transform_docs/views/screens/recents_screen/recents_screen.dart';
import 'package:transform_docs/views/screens/settings/settings_screen.dart';

var routes = {
  // Add your routes here
  BottomNavBar.id: (context) => const BottomNavBar(),
  HomePage.id: (context) => HomePage(),
  SettingsScreen.id: (context) => SettingsScreen(),
  RecentDocumentsScreen.id: (context) =>
      RecentDocumentsScreen(documentHistory: []),
  ExtractedDataScreen.id: (context) => ExtractedDataScreen(extractedData: {}),
};
