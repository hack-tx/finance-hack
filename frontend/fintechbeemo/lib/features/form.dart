// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, sized_box_for_whitespace, sort_child_properties_last, prefer_const_declarations, use_build_context_synchronously

import 'dart:convert';

import 'package:fintechbeemo/features/user_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:http/http.dart' as http;

class UserProfileForm extends StatefulWidget {
  const UserProfileForm({super.key});

  @override
  State<UserProfileForm> createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  String getValue(List<bool> selections) {
    if (selections.length != 3) {
      throw ArgumentError('List must have exactly 3 elements');
    }
    if (selections[0]) {
      return 'low';
    } else if (selections[1]) {
      return 'medium';
    } else if (selections[2]) {
      return 'high';
    } else {
      throw ArgumentError('One of the elements in the list must be true');
    }
  }

  List<bool> _invesmentKnowledgeIsSelected = [
    true, // low
    false, // medium
    false // high
  ];
  List<bool> _riskTollerance = [
    true, // low
    false, // medium
    false // high
  ];

  final List<String> _tags = [];

  final TextEditingController yearlyIncomeController = TextEditingController();
  final TextEditingController estimatedDept = TextEditingController();
  final TextEditingController estimatedExpenses = TextEditingController();

  Future<void> postProfile() async {
    final url = 'http://45.55.39.250/profile';
    final headers = {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    };

    // var income = int.parse(yearlyIncomeController.text) / 12;
    final body = jsonEncode({
      'debt': estimatedDept.text,
      // 'income': '$income/month',
      'income': yearlyIncomeController.text,
      'expenses': estimatedExpenses.text,
      'stock_market_knowledge': getValue(_invesmentKnowledgeIsSelected),
      'investment_risk': getValue(_riskTollerance),
      'interest_sectors': _tags.toString(),
    });

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the JSON

      Navigator.of(context).pop();
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, _, __) {
            return userFlowPage();
          },
          transitionDuration: Duration(seconds: 0),
        ),
      );
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to post profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width > 1000
              ? MediaQuery.of(context).size.width * 0.5
              : MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[200],
          ),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      'Finance Profile Form',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: 500,
                    margin: EdgeInsets.all(10),
                    child: Text(
                      'The information provided will directly affect the responses of your personalized finanance assitant, for the most useful responses please be as accurate as possible',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300],
                      ),
                      padding: EdgeInsets.all(10),
                      height: 90,
                      width: 500,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Yearly Income',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Center(
                            child: TextFormField(),
                          )
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300],
                      ),
                      padding: EdgeInsets.all(10),
                      height: 90,
                      width: 500,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estimated Debt',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Center(
                            child: TextFormField(),
                          )
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300],
                      ),
                      padding: EdgeInsets.all(10),
                      height: 90,
                      width: 500,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Montly Expenses',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Center(
                            child: TextFormField(),
                          )
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300],
                      ),
                      padding: EdgeInsets.all(10),
                      height: 100,
                      width: 500,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Invesment Knowledge',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: ToggleButtons(
                              isSelected: _riskTollerance,
                              onPressed: (int index) {
                                setState(() {
                                  for (int i = 0;
                                      i < _riskTollerance.length;
                                      i++) {
                                    _riskTollerance[i] = i == index;
                                  }
                                });
                              },
                              children: <Widget>[
                                Container(
                                  width: 100,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Low'),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Medium'),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('High'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300],
                      ),
                      padding: EdgeInsets.all(10),
                      height: 100,
                      width: 500,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Risk Tolerance',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: ToggleButtons(
                              isSelected: _invesmentKnowledgeIsSelected,
                              onPressed: (int index) {
                                setState(() {
                                  for (int i = 0;
                                      i < _invesmentKnowledgeIsSelected.length;
                                      i++) {
                                    _invesmentKnowledgeIsSelected[i] =
                                        i == index;
                                  }
                                });
                              },
                              children: <Widget>[
                                Container(
                                  width: 100,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Low'),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Medium'),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('High'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300],
                      ),
                      padding: EdgeInsets.all(10),
                      height: 150,
                      width: 500,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Interested Sectors',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  setState(() {
                                    _tags.add(value);
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Enter an industry of interest',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Tags(
                            itemCount: _tags.length,
                            itemBuilder: (index) {
                              return ItemTags(
                                index: index,
                                title: _tags[index],
                                removeButton: ItemTagsRemoveButton(
                                  onRemoved: () {
                                    setState(
                                      () {
                                        _tags.removeAt(index);
                                      },
                                    );
                                    return true;
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          postProfile();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue[300],
                        ),
                        margin: EdgeInsets.only(bottom: 40),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        width: 200,
                        height: 50,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
