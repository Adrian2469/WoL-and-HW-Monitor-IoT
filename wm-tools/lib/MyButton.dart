import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyButton extends StatelessWidget {
  Future<void> _setOffline(String field) async {
    final docRef =
        FirebaseFirestore.instance.collection('devices').doc('esp8266');
    try {
      // Set nilai langsung ke offline
      await docRef.update({'status': false});
    } catch (e) {
      print('Error setting $field to offline: $e');
    }
  }

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
          // ElevatedButton(
          //   onPressed: () {
          //     _temporarySetTrue('wol');
          //   },
          //   child: const Text('Wake'),
          // ),
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
                  color: Color.fromARGB(255, 247, 242, 249),
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
              onTap: () {
                _setOffline('status');
              },
              child: Ink(
                width: 90,
                height: 40,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 247, 242, 249),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text("Status",
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
              onTap: () {
                _temporarySetTrue('reboot');
              },
              child: Ink(
                width: 90,
                height: 40,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 247, 242, 249),
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
