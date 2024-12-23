/**
 * @author Akshit Jha
 * Creation Date: 11-12-2024
 */
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:transform_docs/utils/constants.dart';
import 'package:transform_docs/viewmodels/home_screen_viewmodel/home_screen_viewmodel.dart';
import 'package:transform_docs/views/screens/extracted_data_screen/extracted_data_screen.dart';
import 'package:transform_docs/views/screens/recents_screen/recents_screen.dart';
import 'package:transform_docs/views/widgets/custom_appbar.dart';
import 'package:transform_docs/views/widgets/custom_button.dart';

class HomePage extends StatelessWidget {
  static const String id = 'home_page';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeScreenViewModel(),
      child: HomePageContent(),
    );
  }
}

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeScreenViewModel>();

    return Scaffold(
      appBar: CustomAppBar(
        title: tr(Constants.appName),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => viewModel.pickFile('xlsx'),
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload, color: Colors.white, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          tr(Constants.uploadTitle),
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (viewModel.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              viewModel.errorMessage!,
                              style: TextStyle(color: Colors.red.shade900),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: viewModel.clearError,
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                _buildSelectedFileCard(context, viewModel),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tr(Constants.recentFilesTitle),
                      style: GoogleFonts.roboto(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () =>
                          _navigateToRecentDocumentsScreen(context, viewModel),
                      child: Text(
                        tr(Constants.viewAllTitle),
                        style: GoogleFonts.roboto(
                            fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.documentHistory.length.clamp(0, 2),
                    itemBuilder: (context, index) {
                      final doc = viewModel.documentHistory[index];
                      return GestureDetector(
                        onTap: () => _navigateToExtractedDataScreen(
                            context, viewModel.extractedData),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 3,
                          child: ListTile(
                            leading: viewModel.getFileIcon(doc['type']),
                            title: Text(doc['name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Uploaded on: ${doc['time']}"),
                                Text("Type: ${doc['type']}"),
                                Text("Size: ${doc['size']}")
                              ],
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (viewModel.isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSelectedFileCard(
      BuildContext context, HomeScreenViewModel viewModel) {
    if (viewModel.selectedFile != null) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: viewModel.getFileIcon(viewModel.fileType),
              title: Text(viewModel.selectedFileName),
              subtitle: Text(
                  "Type: ${viewModel.fileType}\nSize: ${viewModel.fileSize}"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: CustomButton(
                text: tr(Constants.viewJsonDataTitle),
                onPressed: () => _navigateToExtractedDataScreen(
                    context, viewModel.extractedData),
              ),
            ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => viewModel.pickFile('xlsx'),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: Center(
            child: Icon(Icons.add, size: 50, color: Colors.grey[600]),
          ),
        ),
      );
    }
  }

  void _navigateToExtractedDataScreen(
      BuildContext context, Map<String, dynamic> extractedData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExtractedDataScreen(extractedData: extractedData),
      ),
    );
  }

  void _navigateToRecentDocumentsScreen(
      BuildContext context, HomeScreenViewModel viewModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RecentDocumentsScreen(documentHistory: viewModel.documentHistory),
      ),
    );
  }
}
