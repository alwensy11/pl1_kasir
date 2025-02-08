import 'package:flutter/material.dart'; // Paket Flutter untuk membangun UI.
import 'package:supabase_flutter/supabase_flutter.dart'; // Paket Supabase untuk berinteraksi dengan backend.

// Halaman StatefulWidget untuk mengedit produk.
class AdminEditProductPage extends StatefulWidget {
  final String nama_produk; // Nama produk yang akan diedit.
  final double harga; // Harga produk yang akan diedit.
  final int stok; // Stok produk yang akan diedit.

  // Konstruktor untuk menerima data produk.
  const AdminEditProductPage({
    Key? key,
    required this.nama_produk,
    required this.harga,
    required this.stok,
  }) : super(key: key);

  @override
  _AdminEditProductPageState createState() => _AdminEditProductPageState(); // Membuat State terkait.
}

// State dari EditProductPage.
class _AdminEditProductPageState extends State<AdminEditProductPage> {
  final _formKey = GlobalKey<FormState>(); // Kunci global untuk validasi form.

  late TextEditingController _nama_produkController; // Controller untuk input nama produk.
  late TextEditingController _hargaController; // Controller untuk input harga produk.
  late TextEditingController _stokController; // Controller untuk input stok produk.

  @override
  void initState() {
    super.initState();
    // Menginisialisasi controller dengan data yang diterima dari widget.
    _nama_produkController = TextEditingController(text: widget.nama_produk);
    _hargaController = TextEditingController(text: widget.harga.toString());
    _stokController = TextEditingController(text: widget.stok.toString());
  }

  @override
  void dispose() {
    // Membersihkan controller untuk mencegah kebocoran memori.
    _nama_produkController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  // Fungsi untuk memperbarui data produk ke database.
  Future<void> _updateProduct() async {
    final response = await Supabase.instance.client
        .from('produk') // Nama tabel di Supabase.
        .update({
          // Data yang akan diperbarui.
          'nama_produk': _nama_produkController.text,
          'harga': double.parse(_hargaController.text),
          'stok': int.parse(_stokController.text),
        })
        .eq('nama_produk', widget.nama_produk) // Menentukan produk berdasarkan nama (atau ID jika ada).
        .select(); // Memilih data untuk memastikan operasi berhasil.

    // Jika tidak ada error, tampilkan pesan sukses.
    if (response.error == null) {
      print('Produk berhasil diperbarui');
    } else {
      // Jika ada error, tampilkan pesan error.
      print('Gagal memperbarui produk: ${response.error!.message}');
    }
  }

  // Fungsi untuk menyimpan perubahan produk.
  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      await _updateProduct(); // Memanggil fungsi untuk memperbarui produk.

      // Kembali ke halaman sebelumnya dengan data yang diperbarui.
      Navigator.pop(context, {
        'nama_produk': _nama_produkController.text,
        'harga': double.parse(_hargaController.text),
        'stok': int.parse(_stokController.text),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Produk'), // Judul halaman.
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding di sekitar konten.
        child: Form(
          key: _formKey, // Menghubungkan form dengan kunci validasi.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Menjadikan elemen memenuhi lebar.
            children: [
              // Input untuk nama produk.
              TextFormField(
                controller: _nama_produkController, // Controller untuk nama produk.
                decoration: const InputDecoration(labelText: 'Nama Produk'), // Label input.
                validator: (value) {
                  // Validasi input nama produk.
                  if (value == null || value.isEmpty) {
                    return 'Nama produk tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0), // Spasi antar elemen.
              // Input untuk harga produk.
              TextFormField(
                controller: _hargaController, // Controller untuk harga produk.
                decoration: const InputDecoration(labelText: 'Harga'), // Label input.
                keyboardType: TextInputType.number, // Input tipe angka.
                validator: (value) {
                  // Validasi input harga.
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0), // Spasi antar elemen.
              // Input untuk stok produk.
              TextFormField(
                controller: _stokController, // Controller untuk stok produk.
                decoration: const InputDecoration(labelText: 'Stok'), // Label input.
                keyboardType: TextInputType.number, // Input tipe angka.
                validator: (value) {
                  // Validasi input stok.
                  if (value == null || value.isEmpty) {
                    return 'Stok tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Stok harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0), // Spasi antar elemen.
              // Tombol untuk menyimpan data.
              ElevatedButton(
                onPressed: _saveProduct, // Fungsi yang dipanggil saat tombol ditekan.
                child: const Text('Simpan'), // Label pada tombol.
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Ekstensi untuk menangani error pada PostgrestList (jika digunakan).
extension on PostgrestList {
  get error => null;
}
