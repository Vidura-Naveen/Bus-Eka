import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class TimeTablePage extends StatelessWidget {
  final String routeId;

  TimeTablePage({
    required this.routeId,
  });

  Future<File> getFileFromUrl() async {
    try {
      // Get the download URL from Firebase Storage
      String url = await firebase_storage.FirebaseStorage.instance
          .ref('MyPdf/$routeId.pdf')
          .getDownloadURL();

      print('PDF URL: $url');

      final response = await http.get(Uri.parse(url));
      final filename = '$routeId.pdf';
      var bytes = response.bodyBytes;
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = new File('$dir/$filename');
      await file.writeAsBytes(bytes);

      print('PDF File Path: ${file.path}');
      return file;
    } catch (e) {
      print('Error downloading file: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timetable'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<File>(
          future: getFileFromUrl(),
          builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.error != null) {
                print('Error: ${snapshot.error}');
                return Text('Error: ${snapshot.error}');
              } else {
                return PDFView(
                  filePath: snapshot.data!.path,
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
