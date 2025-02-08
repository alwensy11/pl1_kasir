import 'package:flutter/material.dart'; // Paket untuk membangun UI dengan Flutter.
import 'package:pl1_kasir/admin/penjualan/insert.dart'; // Mengimpor halaman untuk menambahkan data penjualan.
import 'package:google_fonts/google_fonts.dart'; // Paket untuk menggunakan font khusus dari Google Fonts.
import 'package:supabase_flutter/supabase_flutter.dart'; // Paket untuk berinteraksi dengan Supabase (backend).

// Deklarasi class PenjualanPage sebagai StatefulWidget.
class AdminPenjualanPage extends StatefulWidget {
  const AdminPenjualanPage({super.key}); // Konstruktor default.

  @override
  State<AdminPenjualanPage> createState() =>
      _AdminPenjualanPageState(); // Membuat State terkait.
}

// State dari PenjualanPage.
class _AdminPenjualanPageState extends State<AdminPenjualanPage> {
  // List untuk menyimpan data penjualan yang diambil dari database.
  List<Map<String, dynamic>> penjualans = [];

  @override
  void initState() {
    super.initState();
    fetchPenjualans(); // Memanggil fungsi untuk mengambil data dari Supabase saat halaman diinisialisasi.
  }

  // Fungsi untuk mengambil data penjualan dari Supabase.
  Future<void> fetchPenjualans() async {
    try {
      final response = await Supabase.instance.client
          .from('penjualan') // Mengambil data dari tabel 'penjualan'.
          .select(
              '*,pelanggan(*)'); // Mengambil data relasi dengan tabel 'pelanggan'.
      setState(() {
        penjualans = List<Map<String, dynamic>>.from(
            response ?? []); // Memperbarui state dengan data yang diterima.
      });
    } catch (e) {
      // Menampilkan pesan error jika gagal mengambil data.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data penjualan: $e')),
      );
    }
  }

  // Fungsi untuk menghapus data penjualan berdasarkan ID.
  Future<void> _deletePenjualans(int id) async {
    try {
      final supabase = Supabase.instance.client;

      // Hapus dulu data terkait di tabel 'detail_penjualan'
      await supabase.from('detail_penjualan').delete().eq('penjualan_id', id);

      // Setelah data terkait dihapus, baru hapus di tabel 'penjualan'
      await supabase.from('penjualan').delete().eq('penjualan_id', id);

      fetchPenjualans(); // Memuat ulang data setelah penghapusan
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus penjualan: $e'),
          backgroundColor: Colors.pinkAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Warna latar belakang putih.
      body: penjualans.isEmpty // Jika data kosong, tampilkan indikator loading.
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount:
                  penjualans.length, // Jumlah item yang akan ditampilkan.
              itemBuilder: (context, index) {
                final penjualann =
                    penjualans[index]; // Ambil data berdasarkan index.

                return Container(
                  margin: const EdgeInsets.all(10), // Margin di sekitar item.
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna latar belakang item.
                    borderRadius: BorderRadius.circular(15), // Sudut membulat.
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pinkAccent
                            .withOpacity(0.5), // Bayangan dengan warna pink.
                        blurRadius: 15, // Radius blur untuk bayangan.
                        offset: const Offset(5, 5), // Posisi bayangan.
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      // Menampilkan tanggal penjualan.
                      'Tanggal : ${penjualann['tanggal_penjualan']}' ??
                          'Tanggal tidak tersedia',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Menyelaraskan teks ke kiri.
                      children: [
                        // Menampilkan total harga penjualan.
                        Text(
                          'Total Harga : Rp ${penjualann['total_harga'] ?? 'Total harga tidak tersedia'}',
                          style: GoogleFonts.roboto(fontSize: 14),
                        ),
                        // Menampilkan nama pelanggan yang terkait.
                        Text(
                            'Nama : ${penjualann['pelanggan']['nama_pelanggan']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize
                          .min, // Menyusutkan ukuran trailing agar sesuai isi.
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors
                                  .red), // Tombol hapus dengan ikon berwarna merah.
                          onPressed: () => _deletePenjualans(penjualann[
                              'penjualan_id']), // Memanggil fungsi hapus dengan ID penjualan.
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(
            16.0), // Memberikan padding di sekitar tombol aksi.
        child: ElevatedButton(
          onPressed: () async {
            // Navigasi ke halaman tambah data dan menunggu hasilnya.
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AdminSalesPage()), // Menuju halaman SalesPage.
            );

            // Jika hasil navigasi bernilai true, muat ulang data penjualan.
            if (result == true) {
              fetchPenjualans();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pinkAccent, // Warna latar belakang tombol.
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(360), // Membuat tombol berbentuk bulat.
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 15), // Padding tombol.
          ),
          child: const Icon(Icons.add,
              color: Colors.white), // Ikon tambah dengan warna putih.
        ),
      ),
    );
  }
}
