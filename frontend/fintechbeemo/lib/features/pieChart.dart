// ignore_for_file: prefer_const_constructors

import 'package:fintechbeemo/features/indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartTransactions extends StatefulWidget {
  final Map<String, dynamic> summaryData;

  const PieChartTransactions({required this.summaryData, super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartTransactions> {
  int touchedIndex = -1;
  final colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.summaryData.keys
                .take(5)
                .toList()
                .asMap()
                .entries
                .map<Widget>((entry) {
              int index = entry.key;
              String category = entry.value;
              Color color = colors[index]; // Access color using index
              return Indicator(
                color: color,
                text: category,
                isSquare: true,
              );
            }).followedBy([
              if (widget.summaryData.keys.length > 5)
                SizedBox(
                    height:
                        4), // Add spacing if there are more than 5 categories
            ]).toList(),
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final sortedEntries = widget.summaryData.entries.toList()
      ..sort(
          (a, b) => b.value['Total'].abs().compareTo(a.value['Total'].abs()));
    final topCategories = sortedEntries.take(5).toList();

    final totalSum = topCategories
        .map<double>((e) => e.value['Total'].abs())
        .reduce((value, element) => value + element);

    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.purple
    ];

    return List.generate(topCategories.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final categoryData = topCategories[i].value;
      final categoryValue = categoryData['Total'].abs();
      final percentage = (categoryValue / totalSum) * 100;

      return PieChartSectionData(
        color: colors[i],
        value: categoryValue,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
        ),
      );
    });
  }
}
