// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, library_private_types_in_public_api, prefer_const_declarations, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, sort_child_properties_last, deprecated_member_use

import 'dart:convert';

import 'package:fintechbeemo/features/ai_chatbot.dart';
import 'package:fintechbeemo/features/stats.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:http/http.dart' as http;

class StatsPageScaffold extends StatefulWidget {
  @override
  _StatsPageScaffoldState createState() => _StatsPageScaffoldState();
}

class _StatsPageScaffoldState extends State<StatsPageScaffold> {
  final List<BubbleSpecialThree> _messages = [];
  final TextEditingController _controller = TextEditingController();

  var isStatementQuesiton = false;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Row(
        children: [
          if (screenSize.width > 1050) ...[
            Expanded(
              flex: 2,
              child: _buildSideMenu(),
            ),
          ],
          Expanded(
            flex: 8,
            child: StatsPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildSideMenu() {
    return Container(
      margin: const EdgeInsets.only(right: 10.0),
      child: Column(
        children: [
          const SizedBox(height: 50.0),
          _buildLogo(),
          const SizedBox(height: 20.0),
          _buildStats(false),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        // CircleAvatar(
        //   radius: 25.0,
        //   backgroundColor: Colors.white,
        //   child: Image.asset(
        //     'assets/images/money.png',
        //     width: 35.0,
        //     height: 35.0,
        //   ),
        // ),
        const SizedBox(width: 10.0),
        const Text(
          'Money Buddy',
          style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: "BebasNeue"),
        ),
      ],
    );
  }

  Widget _buildChatOption() {
    return InkWell(
      onTap: () {
        setState(() {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, _, __) {
                return AIChatBotPage();
              },
              transitionDuration: Duration(seconds: 0),
            ),
          );
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(14.0),
              child: Icon(Icons.chat_bubble, color: Colors.white),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'AI Chat',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(10.0),
        color: const Color.fromRGBO(0, 191, 100, 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(14.0),
            child: Icon(Icons.bar_chart_sharp, color: Colors.white),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Dashboard',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
