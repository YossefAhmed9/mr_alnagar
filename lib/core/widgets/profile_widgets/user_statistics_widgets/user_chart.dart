import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserChart extends StatelessWidget {
  final Map<String, dynamic> chartData;

  const UserChart({
    Key? key,
    this.chartData = const {
      'x_axis_labels': [],
      'datasets': [],
      'y_axis_labels': [0, 15, 30, 45, 60, 75, 90],
    },
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();

    // Convert chart data to FlSpots
    final List<FlSpot> spots = _convertToFlSpots(chartData);
    final List<String> xAxisLabels = _getXAxisLabels(chartData);
    final List<num> yAxisLabels = _getYAxisLabels(chartData);

    return Scrollbar(
      controller: controller,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFD7D9F2),
            borderRadius: BorderRadius.circular(16),
          ),
          width: 400.w, // Wider to better enable scrolling
          height: 400,
          child:
              spots.isEmpty
                  ? Center(child: Text('لا توجد بيانات للرسم البياني'))
                  : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        drawHorizontalLine: true,
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget:
                                (value, _) => Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, _) {
                              final index = value.toInt();
                              return Padding(
                                padding: const EdgeInsets.only(top: 8,right: 5,left: 5),
                                child: Wrap(
                                  children:[
                                    Text(
                                      index < xAxisLabels.length
                                          ? xAxisLabels[index]
                                          : '',maxLines: 4,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ]
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: (xAxisLabels.length - 1).toDouble(),
                      minY: 0,
                      maxY: yAxisLabels.last.toDouble(),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: false,
                          color: Colors.teal,
                          barWidth: 2,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }

  List<FlSpot> _convertToFlSpots(Map<String, dynamic> chartData) {
    final datasets = chartData['datasets'] ?? [];
    if (datasets.isEmpty) return [];

    final firstDataset = datasets[0];
    final data = firstDataset['data'] ?? [];

    return List.generate(
      data.length,
      (index) => FlSpot(index.toDouble(), (data[index] ?? 0).toDouble()),
    );
  }

  List<String> _getXAxisLabels(Map<String, dynamic> chartData) {
    return List<String>.from(chartData['x_axis_labels'] ?? []);
  }

  List<num> _getYAxisLabels(Map<String, dynamic> chartData) {
    return List<num>.from(
      chartData['y_axis_labels'] ?? [0, 15, 30, 45, 60, 75, 90],
    );
  }
}
