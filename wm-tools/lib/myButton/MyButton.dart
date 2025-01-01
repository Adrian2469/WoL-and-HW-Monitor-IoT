import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyButton extends StatefulWidget {
  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool isStart = false; // Status awal untuk tombol "Start"

  Future<void> _temporarySetTrue(String field) async {
    final docRef = FirebaseFirestore.instance.collection('cmd').doc('button');
    try {
      // Set value to true
      await docRef.update({field: true});

      await Future.delayed(const Duration(seconds: 5));

      // Set value back to false
      await docRef.update({field: false});
    } catch (e) {
      print('Error updating $field temporarily: $e');
    }
  }

  Future<void> _startMonitor() async {
    setState(() {
      isStart = !isStart; // Toggle status
    });

    try {
      // Update status "start" di Firestore
      await FirebaseFirestore.instance.collection('cmd').doc('button').update({
        'start': isStart, // Set value start ke true atau false sesuai status
      });
    } catch (e) {
      print('Error updating start status: $e');
    }

    // Optionally, print status untuk debugging
    print("Start status: $isStart");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(180, 114, 145, 231),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.red,
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                _temporarySetTrue('wol');
              },
              child: Ink(
                width: 90,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 247, 242, 249),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text("Wake",
                      style: TextStyle(
                          color: Color.fromARGB(255, 102, 80, 159),
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.red,
              borderRadius: BorderRadius.circular(20),
              onTap: _startMonitor, // Panggil fungsi toggle saat tombol ditekan
              child: Ink(
                width: 90,
                height: 40,
                decoration: BoxDecoration(
                  color: isStart
                      ? Colors.red // Warna merah ketika status "Start" aktif
                      : const Color.fromARGB(
                          255, 247, 242, 249), // Warna default
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    isStart ? "Stop" : "Start", // Teks sesuai status
                    style: TextStyle(
                      color: isStart
                          ? Colors.white // Teks putih saat status aktif
                          : const Color.fromARGB(
                              255, 102, 80, 159), // Teks default
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.red,
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                _temporarySetTrue('reboot');
              },
              child: Ink(
                width: 90,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 247, 242, 249),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text("Reset",
                      style: TextStyle(
                          color: Color.fromARGB(255, 102, 80, 159),
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
