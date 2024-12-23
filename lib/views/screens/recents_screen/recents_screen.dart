/**
 * @author Akshit Jha
 * Creation Date: 11-12-2024
 */
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transform_docs/utils/constants.dart';
import 'package:transform_docs/views/widgets/custom_appbar.dart';

class RecentDocumentsScreen extends StatelessWidget {
  static const String id = 'recent_documents_screen';
  final List<Map<String, dynamic>> documentHistory;

  RecentDocumentsScreen({required this.documentHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: tr(Constants.recentFilesTitle),
      ),
      body: ListView.builder(
        itemCount: documentHistory.length,
        itemBuilder: (context, index) {
          final doc = documentHistory[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 3,
            child: ListTile(
              leading: _getFileIcon(doc['type']),
              title: Text(doc['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Uploaded on: ${doc['time']}"),
                  Text("Type: ${doc['type']}"),
                  Text("Size: ${doc['size']}")
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getFileIcon(String type) {
    Color iconColor;
    IconData icon;

    switch (type.toLowerCase()) {
      case 'pdf':
        iconColor = Colors.red;
        icon = Icons.picture_as_pdf;
        break;
      case 'xlsx':
        iconColor = Colors.green;
        icon = Icons.table_chart;
        break;
      case 'docx':
        iconColor = Colors.blue;
        icon = Icons.description;
        break;
      default:
        iconColor = Colors.grey;
        icon = Icons.insert_drive_file;
    }

    return Icon(
      icon,
      size: 40,
      color: iconColor,
    );
  }
}
