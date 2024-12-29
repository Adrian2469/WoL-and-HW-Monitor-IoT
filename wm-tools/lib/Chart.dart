import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

class CpuTemperatureChart extends StatefulWidget {
  @override
  _CpuTemperatureChartState createState() => _CpuTemperatureChartState();
}

class _CpuTemperatureChartState extends State<CpuTemperatureChart> {
  List<FlSpot> _dataPoints = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeData() {
    _dataPoints = [];

    _timer = Timer.periodic(Duration(minutes: 5), (timer) {
      setState(() {
        final now = DateTime.now();
        double timestamp = now.millisecondsSinceEpoch.toDouble();
        double cpuTemp = _getCpuTemperature(); // Simulasi data suhu CPU
        _dataPoints.add(FlSpot(timestamp, cpuTemp));

        _dataPoints = _dataPoints.where((point) {
          return point.x >
              now
                  .subtract(Duration(hours: 1))
                  .millisecondsSinceEpoch
                  .toDouble();
        }).toList();
      });
    });
  }

  double _getCpuTemperature() {
    return (20 + (80 * (DateTime.now().second / 60))).clamp(0, 100).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("CPU Temperature Chart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: screenHeight * 0.25,
          width: double.infinity,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: false, // Menonaktifkan garis grid
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value % 20 == 0) {
                        return Text("${value.toInt()}°C"); // Hilangkan .0
                      }
                      return Container();
                    },
                    reservedSize: 28,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      DateTime dateTime =
                          DateTime.fromMillisecondsSinceEpoch(value.toInt());
                      return Text(
                          "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}");
                    },
                    reservedSize: 22,
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: false), // Nonaktifkan angka di atas
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: false), // Nonaktifkan angka di kanan
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.black),
              ),
              minX: DateTime.now()
                  .subtract(Duration(hours: 1))
                  .millisecondsSinceEpoch
                  .toDouble(),
              maxX: DateTime.now().millisecondsSinceEpoch.toDouble(),
              minY: 0,
              maxY: 100,
              lineBarsData: [
                LineChartBarData(
                  spots: _dataPoints,
                  isCurved: true,
                  barWidth: 4,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.withOpacity(0.4), // Hijau (0-50)
                        Colors.yellow.withOpacity(0.4), // Kuning (51-75)
                        Colors.red.withOpacity(0.4), // Merah (76-100)
                      ],
                      stops: [0.5, 0.75, 1.0],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  dotData: FlDotData(show: true),
                  isStrokeCapRound: true,
                  color: (Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
