import 'package:flutter/material.dart';
import 'package:wm_tools/HwData.dart';
import 'package:wm_tools/HwData1.dart';

class Sidebar extends StatefulWidget {
  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: isExpanded
              ? 230
              : 120, // Sesuaikan tinggi berdasarkan status expand
          decoration: BoxDecoration(color: const Color(0xFF1D2744)),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: ExpansionTile(
                title: const Text('Device Manager',
                    style: TextStyle(color: Colors.white)),
                onExpansionChanged: (expanded) {
                  setState(() {
                    isExpanded = expanded;
                  });
                },
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HwData1()));
                    },
                    child: const ListTile(
                        title: Text('ACER',
                            style: TextStyle(color: Colors.white))),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HwData()));
                    },
                    child: ListTile(
                        title: Text('Desktop',
                            style: TextStyle(color: Colors.white))),
                  ),
                ],
              ),
            ),
          ),
        ),
        ExpansionTile(
          title: const Text('Motherboard'),
          children: [
            ListTile(title: const Text('Gigabyte A320M-S2H V2-CF')),
          ],
        ),
        ExpansionTile(
          title: const Text('Processor'),
          children: [
            ListTile(title: const Text('AMD Ryzen 3 3200G')),
          ],
        ),
        ExpansionTile(
          title: const Text('RAM'),
          children: [
            ListTile(title: const Text('16 GB DDR4 3200Mhz')),
          ],
        ),
        ExpansionTile(
          title: const Text('GPU'),
          children: [
            ListTile(title: const Text('Radeon RX 580')),
          ],
        ),
        ExpansionTile(
          title: const Text('Storage'),
          children: [
            ListTile(title: const Text('SSD NVMe 256GB')),
            ListTile(title: const Text('SSD SATA 500GB')),
            ListTile(title: const Text('HDD SATA 500GB')),
          ],
        ),
      ],
    ));
  }
}
