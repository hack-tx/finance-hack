// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, camel_case_types, unused_local_variable

import 'package:fintechbeemo/features/statsPage.dart';
import 'package:flutter/material.dart';
import 'package:another_dashed_container/another_dashed_container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'ai_chatbot.dart';

class userFlowPage extends StatefulWidget {
  @override
  _UserFlowPageState createState() => _UserFlowPageState();
}

class _UserFlowPageState extends State<userFlowPage> {
  Future<FilePickerResult>? _fileUploadFuture;

  void _browseFiles(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      _fileUploadFuture = Future.value(result);

      // File file = File(result.files.single.path!);
      final fileBytes = result.files.first.bytes;
      final fileName = result.files.first.name;

      // Send the file to the FastAPI endpoint
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://45.55.39.250/upload-csv'));
      request.files.add(http.MultipartFile.fromBytes(
          'file', fileBytes!.toList(),
          filename: fileName));
      var response = await request.send();
      if (response.statusCode == 200) {
        print('File uploaded successfully!');
      } else {
        print('Failed to upload file.');
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<FilePickerResult>(
          future: _fileUploadFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              PlatformFile file = snapshot.data!.files.first;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(file.name),
                      Icon(Icons.check, color: Colors.green),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StatsPageScaffold()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      side: const BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: const Text('Start Analysis'),
                  ),
                ],
              );
            } else {
              return DashedContainer(
                dashColor: Colors.black,
                dashedLength: 10.0,
                blankLength: 2.0,
                strokeWidth: 2.0,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(20), // Reduced margin
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width:
                      MediaQuery.of(context).size.width * 0.7, // Adjusted width
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Drag and drop your transaction CSV here to start uploading',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18, // Increased font size
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.1, // Adjust the width as needed
                            child: Divider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'OR',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.1, // Adjust the width as needed
                            child: Divider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () => _browseFiles(context),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          side: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: const Text('Start Analysis'),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
