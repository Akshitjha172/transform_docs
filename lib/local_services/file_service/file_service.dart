/**
 * @author Akshit Jha
 * Creation Date: 11-12-2024
 */
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';

class FileService {
  // Pick a file from device storage
  Future<File?> pickFile({required String fileType}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'xlsx', 'docx'],
    );

    return result != null ? File(result.files.single.path!) : null;
  }

  // Determine file type based on extension
  String getFileType(File file) {
    return file.path.split('.').last.toLowerCase();
  }

  // Parse PDF file
  Future<Map<String, dynamic>> parsePdfFile(File file) async {
    try {
      String text = await _readPdfContent(file);
      return {
        'file_type': 'PDF',
        'text_content': text,
      };
    } catch (e) {
      return {
        'file_type': 'PDF',
        'error': 'Could not parse PDF file',
      };
    }
  }

  // Parse Excel file
  Map<String, dynamic> parseExcelFile(File file) {
    try {
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      Map<String, dynamic> excelData = {};

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table];
        excelData[table] = sheet!.rows
            .map((row) => row.map((cell) => cell?.value.toString()).toList())
            .toList();
      }

      return {'file_type': 'Excel', 'sheets': excelData};
    } catch (e) {
      return {
        'file_type': 'Excel',
        'error': 'Could not parse Excel file',
      };
    }
  }

  // Parse DOCX file
  Map<String, dynamic> parseDocxFile(File file) {
    try {
      String text = _readDocxContent(file);
      return {
        'file_type': 'DOCX',
        'text_content': text,
      };
    } catch (e) {
      return {
        'file_type': 'DOCX',
        'error': 'Could not parse DOCX file',
      };
    }
  }

  // Internal method to read PDF content
  Future<String> _readPdfContent(File pdfFile) async {
    try {
      return await pdfFile.readAsString();
    } catch (e) {
      return 'Unable to extract text from PDF';
    }
  }

  // Internal method to read DOCX content
  String _readDocxContent(File docxFile) {
    try {
      return docxFile.readAsStringSync();
    } catch (e) {
      return 'Unable to extract text from DOCX';
    }
  }
}
