import 'package:flutter/material.dart';

// ✅ PASTIKAN NAMA CLASS INI ADALAH SellBookScreen (huruf besar di setiap awal kata)
class SellBookScreen extends StatelessWidget {
  const SellBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jual / Tukar Buku'),
        backgroundColor: const Color(0xFF087F3E),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Halaman Jual / Tukar Buku\n(Akan segera dilengkapi)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}