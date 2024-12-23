/**
 * @author Akshit Jha
 * Creation Date: 11-12-2024
 */
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transform_docs/local_services/file_service/file_service.dart';

class HomeScreenViewModel extends ChangeNotifier {
  final FileService _fileService = FileService();

  File? selectedFile;
  String selectedFileName = '';
  String fileType = '';
  String fileSize = '';
  bool isLoading = false;
  String? errorMessage;
  Map<String, dynamic> extractedData = {};
  List<Map<String, dynamic>> documentHistory = [];

  Future<void> pickFile(String expectedType) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      File? pickedFile = await _fileService.pickFile(fileType: expectedType);

      if (pickedFile != null) {
        String fileType = _fileService.getFileType(pickedFile).toLowerCase();

        if (fileType == 'xlsx') {
          String uploadTime =
              DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
          String fileSize = _getFileSize(pickedFile);

          await _parseFile(pickedFile, fileType);

          selectedFile = pickedFile;
          selectedFileName = pickedFile.path.split('/').last;
          this.fileType = fileType;
          this.fileSize = fileSize;

          documentHistory.add({
            'name': selectedFileName,
            'type': fileType,
            'time': uploadTime,
            'size': fileSize,
            'path': pickedFile.path,
            'data': extractedData,
          });
        } else {
          errorMessage =
              'Please select an Excel (.xlsx) file. Other file types are not supported.';
          selectedFile = null;
          selectedFileName = '';
          this.fileType = '';
          this.fileSize = '';
          extractedData = {};
        }
      }
    } catch (e) {
      errorMessage =
          'An error occurred while processing the file. Please try again.';
      selectedFile = null;
      selectedFileName = '';
      fileType = '';
      fileSize = '';
      extractedData = {};
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _parseFile(File file, String fileType) async {
    try {
      switch (fileType) {
        case 'xlsx':
          extractedData = _fileService.parseExcelFile(file);
          break;
        default:
          extractedData = {};
          errorMessage = 'Unsupported file type. Please select an Excel file.';
      }
    } catch (e) {
      errorMessage =
          'Error parsing file. Please make sure it\'s a valid Excel file.';
      extractedData = {};
    }
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  String _getFileSize(File file) {
    final bytes = file.lengthSync();
    return bytes >= 1024 * 1024
        ? '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB'
        : '${(bytes / 1024).toStringAsFixed(2)} KB';
  }

  Widget getFileIcon(String type) {
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
