import 'package:flutter/material.dart'; // Mengimpor paket Flutter untuk membangun antarmuka pengguna.
import 'package:google_fonts/google_fonts.dart'; // Mengimpor paket Google Fonts untuk menggunakan font khusus.
import 'package:pl1_kasir/admin/produk/insert.dart'; // Mengimpor halaman untuk menambahkan produk.
import 'package:pl1_kasir/admin/produk/edit.dart'; // Mengimpor halaman untuk mengedit produk.
import 'package:supabase_flutter/supabase_flutter.dart'; // Mengimpor Supabase untuk interaksi dengan database.

// Widget utama untuk halaman produk.
class AdminProdukPage extends StatefulWidget {
  const AdminProdukPage({super.key}); // Constructor dengan key opsional.

  @override
  State<AdminProdukPage> createState() => _AdminProdukPageState(); // Membuat state dari ProdukPage.
}

// State untuk ProdukPage.
class _AdminProdukPageState extends State<AdminProdukPage> {
  List<Map<String, dynamic>> product = []; // Variabel untuk menyimpan daftar produk.

  @override
  void initState() {
    super.initState(); // Memanggil fungsi initState bawaan.
    fetchProducts(); // Memanggil fungsi untuk mengambil data produk saat widget diinisialisasi.
  }

  // Fungsi untuk mengambil data produk dari tabel 'produk' di Supabase.
  Future<void> fetchProducts() async {
    final response = await Supabase.instance.client.from('produk').select(); // Query data produk dari database.

    setState(() {
      product = List<Map<String, dynamic>>.from(response); // Menyimpan hasil query ke variabel `product`.
    });
  }

  // Fungsi untuk menghapus produk berdasarkan ID.
  Future<void> _deleteProduct(int id) async {
    try {
      final supabase = Supabase.instance.client;

      // Hapus dulu data terkait di tabel 'detail_penjualan'
      await supabase.from('detail_penjualan').delete().eq('produk_id', id);

      // Setelah data terkait dihapus, baru hapus di tabel 'produk'
      await supabase.from('produk').delete().eq('produk_id', id);

      fetchProducts(); // Memuat ulang data setelah penghapusan
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus produk: $e'),
          backgroundColor: Colors.pinkAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Mengatur warna latar belakang halaman.
      body: product.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Menampilkan loader jika produk belum dimuat.
          : ListView.builder(
              itemCount: product.length, // Jumlah item berdasarkan daftar produk.
              itemBuilder: (context, index) {
                final products = product[index]; // Mengambil produk pada indeks tertentu.
                return Container(
                  margin: const EdgeInsets.all(10), // Memberikan margin di sekitar item.
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna latar belakang item.
                    borderRadius: BorderRadius.circular(15), // Membuat sudut membulat.
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pinkAccent.withOpacity(0.5), // Warna bayangan.
                        blurRadius: 15, // Radius blur untuk bayangan.
                        offset: const Offset(5, 5), // Posisi bayangan.
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      products['nama_produk'] ?? 'No nama_produk', // Menampilkan nama produk.
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold, // Gaya huruf tebal.
                        fontSize: 18, // Ukuran font.
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Menyusun teks subtitle di kiri.
                      children: [
                        Text(
                          'Harga: Rp ${products['harga']}', // Menampilkan harga produk.
                          style: GoogleFonts.roboto(fontSize: 14), // Gaya teks harga.
                        ),
                        Text(
                          'Stok: ${products['stok']}', // Menampilkan stok produk.
                          style: GoogleFonts.roboto(fontSize: 12), // Gaya teks stok.
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min, // Mengatur ukuran minimum trailing.
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue), // Ikon edit dengan warna biru.
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminEditProductPage(
                                  nama_produk: products['nama_produk'], // Mengirim nama produk ke halaman edit.
                                  harga: products['harga'].toDouble(), // Mengirim harga produk ke halaman edit.
                                  stok: products['stok'], // Mengirim stok produk ke halaman edit.
                                ),
                              ),
                            );

                            // Jika data berhasil diperbarui, update daftar produk di memori.
                            if (result != null) {
                              setState(() {
                                product[index] = {
                                  'nama_produk': result['nama_produk'],
                                  'harga': result['harga'],
                                  'stok': result['stok'],
                                }; // Memperbarui produk pada indeks tertentu.
                              });
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red), // Ikon delete dengan warna merah.
                          onPressed: () {
                            _deleteProduct(products['produk_id']); // Memanggil fungsi hapus produk.
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0), // Memberikan padding pada tombol.
        child: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminAddProdukPage()), // Navigasi ke halaman tambah produk.
            );

            // Jika produk berhasil ditambahkan, refresh daftar produk.
            if (result == true) {
              fetchProducts(); // Memperbarui data produk.
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pinkAccent, // Warna latar tombol.
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Membuat sudut membulat.
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding dalam tombol.
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min, // Ukuran tombol minimum.
            children: [
              Icon(Icons.add, color: Colors.white), // Ikon tambah.
            ],
          ),
        ),
      ),
    );
  }
}
