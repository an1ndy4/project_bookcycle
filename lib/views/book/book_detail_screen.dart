import 'package:flutter/material.dart';
import '../../models/book_model.dart';

class BookDetailScreen extends StatelessWidget {
  final BookModel book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Buku'),
        backgroundColor: const Color(0xFF087F3E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: book.fotoBuku != null
                  ? Image.network(
                      book.fotoBuku!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.book, size: 100),
                    )
                  : const Icon(Icons.book, size: 100, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              book.judulBuku,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF092B8F),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Penulis: ${book.penulis ?? "-"}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Penerbit: ${book.penerbit ?? "-"}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Kondisi: ${book.kondisiBuku}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              book.jenisTransaksi == 'Jual'
                  ? 'Harga: Rp ${book.harga ?? 0}'
                  : 'Tipe: Tukar Buku',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF087F3E),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Deskripsi:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              book.deskripsi ?? 'Tidak ada deskripsi',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement add to cart or exchange request
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur akan segera hadir')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF087F3E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  book.jenisTransaksi == 'Jual' ? 'Beli Buku' : 'Ajukan Tukar',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}