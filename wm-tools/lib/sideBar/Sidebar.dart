import 'package:flutter/material.dart';
import 'package:wm_tools/HwData/HwData.dart';
import 'package:wm_tools/HwData/HwData1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Sidebar extends StatefulWidget {
  @override
  State<Sidebar> createState() => _SidebarState();
}

class HardwareData {
  final String mobo;
  final String proc;
  final String ram;
  final String gpu;
  final String disk0;
  final String disk1;

  HardwareData({
    required this.mobo,
    required this.proc,
    required this.ram,
    required this.gpu,
    required this.disk0,
    required this.disk1,
  });

  factory HardwareData.fromJson(Map<String, dynamic> json) {
    return HardwareData(
      mobo: json['mobo'],
      proc: json['proc'],
      ram: json['ram'],
      gpu: json['gpu'],
      disk0: json['disk0'],
      disk1: json['disk1'],
    );
  }
}

Future<HardwareData> fetchHardwareData() async {
  final doc =
      await FirebaseFirestore.instance.collection('spec').doc('pcrumah').get();

  if (doc.exists) {
    return HardwareData.fromJson(doc.data()!);
  } else {
    throw Exception("Document does not exist");
  }
}

class _SidebarState extends State<Sidebar> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<HardwareData>(
        future: fetchHardwareData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No Data Available'));
          }

          final hardware = snapshot.data!;
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              // Header bagian Device Manager
              Container(
                color: Color(0xFF1D2744),
                height: 30, // Menetapkan tinggi tetap untuk header
                child: Center(
                  child: const Text(
                    '',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),

              // ExpansionTile untuk bagian Devices
              Container(
                color: Color(0xFF1D2744), // Background untuk konten ini
                child: ExpansionTile(
                  title: const Text(
                    'Devices Manager',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HwData1()),
                        );
                      },
                      child: const ListTile(
                          title: Text('ACER',
                              style: TextStyle(color: Colors.white))),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HwData()),
                        );
                      },
                      child: ListTile(
                          title: Text('Desktop',
                              style: TextStyle(color: Colors.white))),
                    ),
                  ],
                ),
              ),

              // Hardware details section (Motherboard, Processor, etc.)
              ListTile(
                title: Text('Motherboard'),
                subtitle: Text(hardware.mobo),
              ),
              ListTile(
                title: Text('Processor'),
                subtitle: Text(hardware.proc),
              ),
              ListTile(
                title: Text('RAM'),
                subtitle: Text(hardware.ram),
              ),
              ListTile(
                title: Text('GPU'),
                subtitle: Text(hardware.gpu),
              ),
              ListTile(
                title: Text('Storage'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hardware.disk0), // First line
                    Text(hardware.disk1), // Second line
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
