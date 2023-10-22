// ignore_for_file: prefer_const_constructors

import 'package:fintechbeemo/features/user_flow.dart';
import 'package:fintechbeemo/features/form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<bool> checkProfile() async {
      final response = await http.get(
        Uri.parse('http://45.55.39.250/get-profile'),
      );
      return response.statusCode == 404;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'File Upload UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: (userFlowPage()), // Use the AiChatbotPage as the home page
      home: FutureBuilder<bool>(
        future: checkProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    CircularProgressIndicator()); // Show a loading spinner while waiting for the response
          } else if (snapshot.hasError) {
            return Text(
                'Error: ${snapshot.error}'); // Show an error message if something went wrong
          } else if (snapshot.hasData && snapshot.data!) {
            return UserProfileForm(); // Render UserProfileForm if the response was 404
          } else {
            return userFlowPage(); // Render userFlowPage otherwise
          }
        },
      ),
      // Use the AiChatbotPage as the home page
    );
  }
}
