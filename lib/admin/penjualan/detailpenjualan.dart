import 'package:flutter/material.dart'; // Paket untuk membangun UI dengan Flutter.
import 'package:google_fonts/google_fonts.dart'; // Paket untuk menggunakan font khusus dari Google Fonts.
import 'package:supabase_flutter/supabase_flutter.dart'; // Paket untuk berinteraksi dengan Supabase (backend).

// Deklarasi class DetailPenjualanPage sebagai StatefulWidget.
class AdminDetailPenjualanPage extends StatefulWidget {
  const AdminDetailPenjualanPage({super.key}); // Konstruktor default.

  @override
  State<AdminDetailPenjualanPage> createState() =>
      _AdminDetailPenjualanPageState(); // Membuat State terkait.
}

// State dari DetailPenjualanPage.
class _AdminDetailPenjualanPageState extends State<AdminDetailPenjualanPage> {
  // Daftar untuk menyimpan data detail_penjualans.
  List<Map<String, dynamic>> detail_penjualans = [];
  List<Map<String, dynamic>> penjualans =
      []; // Tidak digunakan, bisa dihapus jika tidak diperlukan.

  @override
  void initState() {
    super.initState();
    fetchDetailPenjualans(); // Memanggil fungsi untuk mengambil data dari Supabase saat halaman diinisialisasi.
  }

  // Fungsi untuk mengambil data detail_penjualan dari Supabase.
  Future<void> fetchDetailPenjualans() async {
    try {
      final response = await Supabase.instance.client
          .from(
              'detail_penjualan') // Mengambil data dari tabel 'detail_penjualan'.
          .select(
              '*,penjualan(*,pelanggan(*)),produk(*)'); // Mengambil data relasi dari tabel 'penjualan', 'pelanggan', dan 'produk'.
      setState(() {
        // Memperbarui state dengan data yang diterima.
        detail_penjualans = List<Map<String, dynamic>>.from(response ?? []);
      });
    } catch (e) {
      // Menampilkan pesan error jika gagal mengambil data.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat data penjualan: $e'), // Error message
          backgroundColor: Colors.pinkAccent,
        ),
      );
    }
  }

  // Fungsi untuk menghapus data detail_penjualans berdasarkan ID.
  Future<void> _deletePenjualans(int id) async {
    try {
      await Supabase.instance.client
          .from('detail_penjualan')
          .delete()
          .eq('detail_id', id);

      fetchDetailPenjualans(); // Memuat ulang data setelah penghapusan
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus penjualan: $e'),
          backgroundColor: Colors.pinkAccent,
        ),
      );
    }
  }

  // Fungsi untuk mengambil nama produk berdasarkan ID produk.
  Future<String> _getNamaProduk(int produkId) async {
    try {
      final response = await Supabase.instance.client
          .from('produk') // Mengambil data dari tabel 'produk'.
          .select('nama_produk') // Hanya mengambil kolom 'nama_produk'.
          .eq('produk_id', produkId) // Filter berdasarkan ID produk.
          .maybeSingle(); // Mengambil satu data jika ada.

      if (response != null && response['nama_produk'] != null) {
        return response['nama_produk']; // Mengembalikan nama produk.
      }
      return 'Nama produk tidak ditemukan'; // Jika data tidak ditemukan.
    } catch (e) {
      return 'Error: $e'; // Jika terjadi kesalahan.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Warna latar belakang putih.
      body: detail_penjualans
              .isEmpty // Jika data kosong, tampilkan indikator loading.
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: detail_penjualans
                  .length, // Jumlah item yang akan ditampilkan.
              itemBuilder: (context, index) {
                final detail_penjualann =
                    detail_penjualans[index]; // Ambil data berdasarkan index.
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
                        // Menampilkan nama pelanggan.
                        'Nama : ${detail_penjualann['penjualan']['pelanggan']['nama_pelanggan']}',
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Menampilkan nama produk.
                        Text(
                            'Nama Produk : ${detail_penjualann['produk']['nama_produk']}',
                            style: GoogleFonts.roboto(fontSize: 14)),
                        // Menampilkan jumlah produk.
                        Text(
                          'Jumlah Produk : ${detail_penjualann['jumlah_produk'] ?? 'Jumlah Produk tidak tersedia'}',
                          style: GoogleFonts.roboto(fontSize: 14),
                        ),
                        // Menampilkan subtotal.
                        Text(
                          'Subtotal : Rp ${detail_penjualann['subtotal'] ?? 'Subtotal tidak tersedia'}',
                          style: GoogleFonts.roboto(fontSize: 14),
                        ),
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
                          onPressed: () => _deletePenjualans(detail_penjualann[
                              'penjualan_id']), // Memanggil fungsi hapus dengan ID penjualan.
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
