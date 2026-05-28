import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SimpleBarChart extends StatelessWidget {
  final Map<String, int> data;
  final String title;

  const SimpleBarChart({super.key, required this.data, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = data.entries.toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleSmall),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: entries.asMap().entries.map((e) {
                    return BarChartGroupData(x: e.key, barRods: [
                      BarChartRodData(
                        toY: e.value.value.toDouble(),
                        color: theme.colorScheme.primary,
                        width: 20,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ]);
                  }).toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        if (v.toInt() >= entries.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(entries[v.toInt()].key, style: theme.textTheme.labelSmall, overflow: TextOverflow.ellipsis),
                        );
                      },
                    )),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
