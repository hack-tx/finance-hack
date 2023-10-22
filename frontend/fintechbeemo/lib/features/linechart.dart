import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartBalance extends StatelessWidget {
  final List<dynamic> transactions;
  final Color mainLineColor;
  final Color belowLineColor;
  final Color aboveLineColor;

  LineChartBalance({
    required this.transactions,
    this.mainLineColor = Colors.black,
    this.belowLineColor = Colors.blue,
    this.aboveLineColor = Colors.orange,
    Key? key,
  }) : super(key: key);

  List<double> processTransactions() {
    final incomeByMonth = List.filled(12, 0.0);
    final spendingByMonth = List.filled(12, 0.0);

    for (var transaction in transactions) {
      final date = DateTime.parse(transaction['Date']);
      final amount = transaction['Amount'];
      final index = date.month - 1;
      if (transaction['Category'] == 'Income') {
        incomeByMonth[index] += amount;
      } else {
        spendingByMonth[index] -=
            amount; // Negate to get positive spending amount
      }
    }

    final totalIncome = incomeByMonth.reduce((a, b) => a + b);
    final averageIncome = totalIncome / 2;
    return spendingByMonth.map((spending) => spending / averageIncome).toList();
  }

  @override
  Widget build(BuildContext context) {
    final spendingVsIncome = processTransactions();
    final spots = spendingVsIncome.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();

    const cutOffYValue = 5.0;

    return AspectRatio(
      aspectRatio: 2,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 28,
          top: 22,
          bottom: 12,
        ),
        child: LineChart(
          LineChartData(
            lineTouchData: const LineTouchData(enabled: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: 2,
                color: mainLineColor,
                belowBarData: BarAreaData(
                  show: true,
                  color: belowLineColor,
                  cutOffY: cutOffYValue,
                  applyCutOffY: true,
                ),
                aboveBarData: BarAreaData(
                  show: true,
                  color: aboveLineColor,
                  cutOffY: cutOffYValue,
                  applyCutOffY: true,
                ),
                dotData: const FlDotData(
                  show: false,
                ),
              ),
            ],
            minY: 0,
            titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                axisNameWidget: Text(
                  '2019',
                  style: TextStyle(
                    fontSize: 10,
                    color: mainLineColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                sideTitles: SideTitles(
                  showTitles: false,
                  reservedSize: 18,
                  interval: 1,
                  // getTitlesWidget: bottomTitleWidgets,
                  // getTitles: (value) => Month(value.toInt() + 1).toString(),
                ),
              ),
              leftTitles: AxisTitles(
                axisNameSize: 20,
                axisNameWidget: const Text(
                  'Value',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                sideTitles: SideTitles(
                  showTitles: false,
                  interval: 1,
                  reservedSize: 40,
                  // getTitlesWidget: leftTitleWidgets,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: false,
              border: Border.all(
                color: Colors.black,
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              checkToShowHorizontalLine: (double value) {
                return value == 1 || value == 6 || value == 4 || value == 5;
              },
            ),
          ),
        ),
      ),
    );
  }
}
