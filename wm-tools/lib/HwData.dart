import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wm_tools/MyAppBar.dart';
import 'package:wm_tools/Sidebar.dart';
import 'MyButton.dart';

class HwData extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D2744),
      appBar: MyAppBar(),
      drawer: Sidebar(),
      body: Stack(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: _firestore.collection('hw').doc('hwmonitor').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text("No data available"));
              }

              final data = snapshot.data!.data() as Map<String, dynamic>;
              final cpuTemp = double.tryParse(data['one']) ?? 0;
              final cpuLoad = double.tryParse(data['two']) ?? 0;
              final memLoad = double.tryParse(data['three']) ?? 0;
              final gpuTemp = double.tryParse(data['four']) ?? 0;
              final disk0Temp = double.tryParse(data['five']) ?? 0;
              final disk1Temp = double.tryParse(data['six']) ?? 0;

              return Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Menampilkan dua gauge pertama dalam satu Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'CPU Temperature',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 189, 198, 205)),
                            ),
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    minimum: 0,
                                    maximum: 100,
                                    showLabels: false,
                                    showTicks: false,
                                    ranges: <GaugeRange>[
                                      GaugeRange(
                                        startValue: 0,
                                        endValue: cpuTemp,
                                        color: const Color.fromARGB(
                                            255, 189, 198, 205),
                                        startWidth: 10,
                                        endWidth: 10,
                                      ),
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                        widget: Text(
                                          '${cpuTemp.toStringAsFixed(0)} °C',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 189, 198, 205),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        angle: 90,
                                        positionFactor: 0.1,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            const Text(
                              'CPU Load',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 189, 198, 205)),
                            ),
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    minimum: 0,
                                    maximum: 100,
                                    showLabels: false,
                                    showTicks: false,
                                    ranges: <GaugeRange>[
                                      GaugeRange(
                                        startValue: 0,
                                        endValue: cpuLoad,
                                        color:
                                            Color.fromARGB(255, 189, 198, 205),
                                        startWidth: 10,
                                        endWidth: 10,
                                      ),
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                        widget: Text(
                                          '$cpuLoad %',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 189, 198, 205),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        angle: 90,
                                        positionFactor: 0.1,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'GPU Temperature',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 189, 198, 205),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    minimum: 0,
                                    maximum: 100,
                                    showLabels: false,
                                    showTicks: false,
                                    ranges: <GaugeRange>[
                                      GaugeRange(
                                        startValue: 0,
                                        endValue: gpuTemp,
                                        color:
                                            Color.fromARGB(255, 189, 198, 205),
                                        startWidth: 10,
                                        endWidth: 10,
                                      ),
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                        widget: Text(
                                          '${gpuTemp.toStringAsFixed(0)} °C',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 189, 198, 205),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        angle: 90,
                                        positionFactor: 0.1,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            const Text(
                              'Memory Load',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 189, 198, 205),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    minimum: 0,
                                    maximum: 100,
                                    showLabels: false,
                                    showTicks: false,
                                    ranges: <GaugeRange>[
                                      GaugeRange(
                                        startValue: 0,
                                        endValue: memLoad,
                                        color:
                                            Color.fromARGB(255, 189, 198, 205),
                                        startWidth: 10,
                                        endWidth: 10,
                                      ),
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                        widget: Text(
                                          '$memLoad %',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 189, 198, 205),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        angle: 90,
                                        positionFactor: 0.1,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Disk 1 Temperature',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 189, 198, 205),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    minimum: 0,
                                    maximum: 100,
                                    showLabels: false,
                                    showTicks: false,
                                    ranges: <GaugeRange>[
                                      GaugeRange(
                                        startValue: 0,
                                        endValue: disk0Temp,
                                        color:
                                            Color.fromARGB(255, 189, 198, 205),
                                        startWidth: 10,
                                        endWidth: 10,
                                      ),
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                        widget: Text(
                                          '${disk0Temp.toStringAsFixed(0)} °C',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 189, 198, 205),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        angle: 90,
                                        positionFactor: 0.1,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            const Text(
                              'Disk 2 Temperature',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 189, 198, 205),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    minimum: 0,
                                    maximum: 100,
                                    showLabels: false,
                                    showTicks: false,
                                    ranges: <GaugeRange>[
                                      GaugeRange(
                                        startValue: 0,
                                        endValue: disk1Temp,
                                        color:
                                            Color.fromARGB(255, 189, 198, 205),
                                        startWidth: 10,
                                        endWidth: 10,
                                      ),
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                        widget: Text(
                                          '${disk1Temp.toStringAsFixed(0)} °C',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 189, 198, 205),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        angle: 90,
                                        positionFactor: 0.1,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          // Tombol diposisikan di bawah
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
