import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      // Path ke dokumen Firestore
      stream: FirebaseFirestore.instance
          .collection('devices')
          .doc('esp8266') // Ganti 'esp8266' dengan ID dokumen Anda
          .snapshots(),
      builder: (context, snapshot) {
        // Default nilai deviceStatus jika data belum tersedia
        bool deviceStatus = false;

        // Periksa status snapshot
        if (snapshot.hasData && snapshot.data?.data() != null) {
          // Mendapatkan data dari Firestore
          var data = snapshot.data!.data() as Map<String, dynamic>;
          deviceStatus = data['status'] ?? false; // Default ke false jika null
        }

        return AppBar(
          title: Row(
            children: [
              // Judul di tengah
              Expanded(
                child: Text(
                  'WM Tools',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center, // Membuat teks di tengah
                ),
              ),
              // Spacer untuk memisahkan judul dengan indikator
              const SizedBox(width: 8),
              // Indikator status di pinggir kanan
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: deviceStatus
                      ? const Color.fromARGB(255, 132, 225, 132)
                      : const Color.fromARGB(255, 207, 46, 46),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          backgroundColor: const Color.fromARGB(
              180, 114, 145, 231), // Warna latar belakang AppBar
          elevation: 0, // Menghapus bayangan bawah AppBar
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white, // Warna ikon AppBar
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Menyediakan ukuran yang tepat
}
