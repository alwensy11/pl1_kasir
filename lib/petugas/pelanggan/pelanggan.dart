import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pl1_kasir/petugas/pelanggan/insert.dart';
import 'package:pl1_kasir/petugas/pelanggan/edit.dart';
import 'package:pl1_kasir/petugas/penjualan/penjualan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Halaman daftar pelanggan
class PelangganPage extends StatefulWidget {
  const PelangganPage({super.key});

  @override
  State<PelangganPage> createState() => _PelangganPageState();
}

class _PelangganPageState extends State<PelangganPage> {
  List<Map<String, dynamic>> pelanggans = []; // Menyimpan daftar pelanggan

  @override
  void initState() {
    super.initState();
    fetchPelanggans(); // Mengambil data pelanggan saat halaman pertama kali dimuat
  }

  // Fungsi untuk mengambil data pelanggan dari Supabase
  Future<void> fetchPelanggans() async {
    final response = await Supabase.instance.client.from('pelanggan').select();

    setState(() {
      pelanggans = List<Map<String, dynamic>>.from(response);
    });
  }

  // Fungsi untuk menghapus pelanggan dari Supabase
  Future<void> _deletePelanggan(int id) async {
    try {
      final supabase = Supabase.instance.client;

      // Hapus dulu data terkait di tabel 'detail_penjualan'
      await supabase.from('penjualan').delete().eq('pelanggan_id', id);

      // Setelah data terkait dihapus, baru hapus di tabel 'penjualan'
      await supabase.from('pelanggan').delete().eq('pelanggan_id', id);

      fetchPelanggans(); // Memuat ulang data setelah penghapusan
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus pelanggan: $e'),
          backgroundColor: Colors.pinkAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Warna latar belakang
      body: pelanggans.isEmpty
          ? const Center(
              child:
                  CircularProgressIndicator()) // Menampilkan loading jika daftar kosong
          : ListView.builder(
              itemCount: pelanggans.length,
              itemBuilder: (context, index) {
                final pelanggann = pelanggans[index];
                return Container(
                  margin: EdgeInsets.all(10), // Jarak antar item
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        15), // Membuat sudut elemen membulat
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.pinkAccent.withOpacity(0.5), // Efek bayangan
                        blurRadius: 15,
                        offset: Offset(5, 5),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      pelanggann['nama_pelanggan'] ?? 'No nama_pelanggan',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pelanggann['alamat'] ?? 'No alamat',
                          style: GoogleFonts.roboto(fontSize: 14),
                        ),
                        Text(
                          pelanggann['no_telepon'] ?? 'No no_telepon',
                          style: GoogleFonts.roboto(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPelangganPage(
                                  nama_pelanggan: pelanggann['nama_pelanggan'],
                                  alamat: pelanggann['alamat'],
                                  no_telepon: pelanggann['no_telepon'],
                                ),
                              ),
                            );

                            // Jika data berhasil diperbarui, update daftar pelanggan di memori
                            if (result != null) {
                              setState(() {
                                pelanggans[index] = {
                                  'nama_pelanggan': result['nama_pelanggan'],
                                  'alamat': result['alamat'],
                                  'no_telepon': result['no_telepon'],
                                };
                              });
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deletePelanggan(pelanggann['pelanggan_id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            // Navigasi ke halaman tambah pelanggan dan menunggu hasilnya
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPelangganPage()),
            );

            // Jika pelanggan berhasil ditambahkan, perbarui daftar pelanggan
            if (result == true) {
              fetchPelanggans();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pinkAccent, // Warna tombol
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(360), // Membuat tombol bulat
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(Icons.add, color: Colors.white)],
          ),
        ),
      ),
    );
  }
}
