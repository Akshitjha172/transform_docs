/**
 * @author Akshit Jha
 * Creation Date: 11-12-2024
 */
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:transform_docs/res/colors/app_colors.dart';
import 'package:transform_docs/utils/constants.dart';

class ExtractedDataScreen extends StatelessWidget {
  static const String id = 'extracted_data_screen';
  final Map extractedData;

  const ExtractedDataScreen({Key? key, required this.extractedData})
      : super(key: key);

  // Method to copy JSON to clipboard
  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(
        text: JsonEncoder.withIndent('  ').convert(extractedData)));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tr(Constants.copySuccessTitle))),
    );
  }

  // Method to save JSON as a file in internal storage
  Future<void> _saveJsonToDownloads(BuildContext context) async {
    try {
      // Get the directory for storing downloads
      final directory = await getExternalStorageDirectory();
      final downloadPath =
          directory != null ? '${directory.path}/Download' : null;

      if (downloadPath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to locate download directory.')),
        );
        return;
      }

      final fileDirectory = Directory(downloadPath);
      if (!fileDirectory.existsSync()) {
        fileDirectory.createSync(recursive: true);
      }

      // Save the JSON file
      final filePath = '${fileDirectory.path}/extracted_data.json';
      File file = File(filePath);
      await file
          .writeAsString(JsonEncoder.withIndent('  ').convert(extractedData));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File saved to: $filePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: AppColors.brandColor,
        title: Text(
          tr(Constants.extractedDataTitle),
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    JsonEncoder.withIndent('  ').convert(extractedData),
                    style: TextStyle(
                      color: Colors.green,
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: AppColors.brandColor,
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _copyToClipboard(context),
                  icon: Icon(Icons.copy, size: 20),
                  label: Text(tr(Constants.copyTitle)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                ElevatedButton.icon(
                  onPressed: () => _saveJsonToDownloads(context),
                  icon: Icon(Icons.download, size: 20),
                  label: Text(tr(Constants.downloadTitle)),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
