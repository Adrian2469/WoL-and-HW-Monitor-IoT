import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Fungsi untuk set perangkat ke offline di Firestore
  Future<void> _setOffline() async {
    final docRef =
        FirebaseFirestore.instance.collection('devices').doc('espAno');
    try {
      // Set status perangkat menjadi offline (false)
      await docRef.update({'status': false});
    } catch (e) {
      print('Error setting device to offline: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      // Path ke dokumen Firestore
      stream: FirebaseFirestore.instance
          .collection('devices')
          .doc('espAno') // Ganti dengan ID dokumen perangkat Anda
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
              GestureDetector(
                onTap: () {
                  // Set perangkat ke offline saat tombol diklik
                  _setOffline();
                },
                child: Container(
                  width: 30, // Ukuran tombol indikator status
                  height: 30, // Ukuran tombol indikator status
                  decoration: BoxDecoration(
                    color: deviceStatus
                        ? const Color.fromARGB(
                            255, 132, 225, 132) // Hijau untuk online
                        : const Color.fromARGB(
                            255, 207, 46, 46), // Merah untuk offline
                    shape: BoxShape.circle, // Bentuk tombol bundar
                  ),
                  child: Center(
                    child: Icon(
                      deviceStatus
                          ? Icons.check
                          : Icons.close, // Ganti dengan ikon sesuai status
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color.fromARGB(180, 114, 145, 231), // Warna latar belakang AppBar
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
