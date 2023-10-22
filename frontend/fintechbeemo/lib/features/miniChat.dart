// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'dart:convert';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class MiniChat extends StatefulWidget {
  const MiniChat({super.key});

  @override
  State<MiniChat> createState() => _MiniChatState();
}

class _MiniChatState extends State<MiniChat> {
  final List<BubbleSpecialThree> _messages = [];
  final TextEditingController _controller = TextEditingController();

  var isStatementQuesiton = false;

  String getTextBefore(String text) {
    // Split the text at "###"
    List<String> parts = text.split('###');

    // Return the text before "###", or the entire text if "###" is not found
    return parts.isNotEmpty ? parts[0] : text;
  }

  Future<void> postQuestion() async {
    final url = isStatementQuesiton
        ? 'http://45.55.39.250/statement-question'
        : 'http://45.55.39.250/profile-question';

    final headers = {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    };
    final body = jsonEncode({'question': _controller.text});

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the JSON
      print('Response data: ${response.body}');

      setState(() {
        _messages.add(
          BubbleSpecialThree(
            text: getTextBefore(response.body),
            color: const Color.fromRGBO(1, 150, 255, 1),
            tail: true,
            isSender: false,
            textStyle: TextStyle(
                color: Colors.white,
                fontSize: 17), // Increase the fontSize here
          ),
        );
      });
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to post question');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.38,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                color: Colors.grey[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: _messages[index].isSender
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Flexible(child: _messages[index]),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isStatementQuesiton = !isStatementQuesiton;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        side: BorderSide(
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
                      child: Text(
                        !isStatementQuesiton
                            ? 'Inlcude Statement'
                            : 'Uninlcude Statement',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.grey[100],
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Type your message here...',
                ),
                onSubmitted: (value) {
                  postQuestion();
                  setState(
                    () {
                      _messages.add(
                        BubbleSpecialThree(
                          text: value,
                          color: const Color.fromRGBO(0, 191, 100, 1),
                          tail: true,
                          isSender: true,
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 17), // Increase the fontSize here
                        ),
                      );
                    },
                  );
                  _controller.clear();
                },
              ),
            ),
          ],
        ));
  }
}
