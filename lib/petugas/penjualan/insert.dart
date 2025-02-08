import 'package:flutter/material.dart';  // Mengimpor pustaka desain material Flutter
import 'package:intl/intl.dart';  // Mengimpor pustaka Intl untuk format tanggal
import 'package:supabase_flutter/supabase_flutter.dart';  // Mengimpor Supabase untuk operasi database
import 'package:pl1_kasir/petugas/home.dart';  // Mengimpor widget MyHomePage untuk navigasi setelah transaksi

// Widget Stateful untuk SalesPage
class SalesPage extends StatefulWidget {
  const SalesPage({super.key});  // Konstruktor untuk SalesPage

  @override
  State<SalesPage> createState() => _SalesPageState();  // Membuat state untuk SalesPage
}

class _SalesPageState extends State<SalesPage> {
  final supabase = Supabase.instance.client;  // Menginisialisasi klien Supabase
  DateTime currentDate = DateTime.now();  // Mendapatkan tanggal dan waktu saat ini

  List<Map<String, dynamic>> pelanggan = [];  // List untuk menampung data pelanggan
  List<Map<String, dynamic>> produk = [];  // List untuk menampung data produk
  Map<String, dynamic>? selectedCustomer;  // Pelanggan yang dipilih untuk transaksi
  Map<String, dynamic>? selectedProduct;  // Produk yang dipilih untuk transaksi

  TextEditingController quantityController = TextEditingController();  // Kontroler untuk input jumlah
  double subtotal = 0;  // Subtotal untuk produk yang dipilih
  double totalPrice = 0;  // Total harga dari semua item di keranjang
  List<Map<String, dynamic>> cart = [];  // List untuk menampung item yang ada di keranjang

  // Inisialisasi state dengan mengambil data pelanggan dan produk dari database
  @override
  void initState() {
    super.initState();
    fetchPelanggan();  // Mengambil data pelanggan dari database
    fetchProducts();  // Mengambil data produk dari database
  }

  // Mengambil data pelanggan dari Supabase
  Future<void> fetchPelanggan() async {
    final response = await supabase.from('pelanggan').select();  // Mengambil data dari tabel 'pelanggan'
    setState(() {
      pelanggan = List<Map<String, dynamic>>.from(response);  // Menyimpan data pelanggan ke dalam list 'pelanggan'
    });
  }

  // Mengambil data produk dari Supabase
  Future<void> fetchProducts() async {
    final response = await supabase.from('produk').select();  // Mengambil data dari tabel 'produk'
    setState(() {
      produk = List<Map<String, dynamic>>.from(response);  // Menyimpan data produk ke dalam list 'produk'
    });
  }

  // Menambahkan produk yang dipilih beserta jumlahnya ke dalam keranjang
  void addToCart() {
    if (selectedProduct != null && quantityController.text.isNotEmpty) {
      int quantity = int.parse(quantityController.text);  // Mengambil jumlah dari kontroler
      double price = selectedProduct!['harga'];  // Mengambil harga produk yang dipilih
      double itemSubtotal = price * quantity;  // Menghitung subtotal untuk item

      setState(() {
        // Menambahkan produk dan jumlah ke dalam keranjang
        cart.add({
          'produk_id': selectedProduct!['produk_id'],
          'nama_produk': selectedProduct!['nama_produk'],
          'jumlah': quantity,
          'subtotal': itemSubtotal,
        });
        totalPrice += itemSubtotal;  // Memperbarui total harga
        selectedProduct!['stok'] -= quantity;  // Memperbarui stok produk
      });
    }
  }

  // Menyimpan transaksi penjualan ke dalam database dan mengosongkan keranjang
  Future<void> submitSale() async {
    try {
      // Menyimpan data transaksi penjualan ke dalam tabel 'penjualan'
      final penjualanResponse = await supabase.from('penjualan').insert({
        'tanggal_penjualan': DateFormat('yyyy-MM-dd').format(currentDate),  // Format tanggal saat ini
        'total_harga': totalPrice,  // Menyimpan total harga transaksi
        'pelanggan_id': selectedCustomer!['pelanggan_id'],  // Menyimpan ID pelanggan yang dipilih
      }).select().single();

      final penjualanId = penjualanResponse['penjualan_id'];  // Mendapatkan ID transaksi penjualan yang baru

      // Menyimpan detail penjualan ke dalam tabel 'detail_penjualan'
      for (var item in cart) {
        await supabase.from('detail_penjualan').insert({
          'penjualan_id': penjualanId,  // ID penjualan
          'produk_id': item['produk_id'],  // ID produk
          'jumlah_produk': item['jumlah'],  // Jumlah produk
          'subtotal': item['subtotal'],  // Subtotal produk
        });

        // Memperbarui stok produk di tabel 'produk'
        await supabase.from('produk').update({
          'stok': selectedProduct!['stok'],  // Memperbarui stok setelah transaksi
        }).eq('produk_id', item['produk_id']);  // Mencocokkan produk berdasarkan ID
      }

      // Menampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaksi berhasil disimpan!'),  // Pesan sukses
            backgroundColor: Colors.pinkAccent,),  
      );
      setState(() {
        cart.clear();  // Mengosongkan keranjang setelah transaksi berhasil
        totalPrice = 0;  // Mengatur ulang total harga
      });
    } catch (error) {
      // Menampilkan pesan kesalahan jika transaksi gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $error'),  // Pesan kesalahan
            backgroundColor: Colors.pinkAccent,),  
      );
    }

    // Mengarahkan kembali ke halaman utama setelah transaksi
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),  // Arahkan ke MyHomePage
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,  // Set warna ikon dan judul menjadi putih
        title: Text('Transaksi Penjualan', style: TextStyle(color: Colors.white),),  // Judul aplikasi
        backgroundColor: Colors.pinkAccent,  // Warna latar belakang AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),  // Menambahkan padding di sekitar konten body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,  // Menyusun widget ke kiri
          children: [
            // Dropdown untuk memilih pelanggan
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: 'Pilih Pelanggan'),  // Label untuk dropdown pelanggan
              items: pelanggan.map((customer) {
                return DropdownMenuItem(
                  value: customer,
                  child: Text(customer['nama_pelanggan']),  // Menampilkan nama pelanggan di dropdown
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCustomer = value as Map<String, dynamic>;  // Menyimpan pelanggan yang dipilih
                });
              },
            ),
            SizedBox(height: 16.0),  // Menambahkan jarak antar widget
            // Dropdown untuk memilih produk
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: 'Pilih Produk'),  // Label untuk dropdown produk
              items: produk.map((product) {
                return DropdownMenuItem(
                  value: product,
                  child: Text(product['nama_produk']),  // Menampilkan nama produk di dropdown
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProduct = value as Map<String, dynamic>;  // Menyimpan produk yang dipilih
                  subtotal = selectedProduct!['harga'] *
                      (quantityController.text.isEmpty
                          ? 0
                          : int.parse(quantityController.text));  // Menghitung subtotal
                });
              },
            ),
            SizedBox(height: 16.0),
            // Input untuk jumlah produk
            TextField(
              controller: quantityController,  // Menghubungkan dengan kontroler jumlah
              decoration: InputDecoration(labelText: 'Jumlah Produk'),  // Label untuk input jumlah
              keyboardType: TextInputType.number,  // Tipe input untuk angka
              onChanged: (value) {
                setState(() {
                  subtotal = selectedProduct != null
                      ? selectedProduct!['harga'] * int.parse(value)  // Memperbarui subtotal ketika jumlah berubah
                      : 0;
                });
              },
            ),
            SizedBox(height: 16.0),
            // Tombol untuk menambahkan produk ke keranjang
            ElevatedButton(
              onPressed: addToCart,  // Memanggil fungsi addToCart saat tombol ditekan
              child: Text('Tambahkan ke Keranjang', style: TextStyle(color: Colors.pinkAccent)),  // Teks tombol
            ),
            Divider(),  // Pembatas antar bagian
            Expanded(
              // List view untuk menampilkan item di keranjang
              child: ListView.builder(
                itemCount: cart.length,  // Jumlah item dalam keranjang
                itemBuilder: (context, index) {
                  final item = cart[index];  // Mengambil item keranjang saat ini
                  return ListTile(
                    title: Text(item['nama_produk']),  // Menampilkan nama produk
                    subtitle: Text('Jumlah: ${item['jumlah']} - Subtotal: Rp ${item['subtotal']}'),  // Menampilkan jumlah dan subtotal produk
                  );
                },
              ),
            ),
            Divider(),  // Pembatas antara keranjang dan total harga
            Text('Total Harga: Rp $totalPrice',
                style: TextStyle(fontWeight: FontWeight.bold)),  // Menampilkan total harga
            SizedBox(height: 16.0),
            // Tombol untuk menyimpan transaksi
            ElevatedButton(
              onPressed: submitSale,  // Memanggil fungsi submitSale saat tombol ditekan
              child: Text('Simpan Transaksi', style: TextStyle(color: Colors.pinkAccent),),  // Teks tombol
            ),
          ],
        ),
      ),
    );
  }
}
