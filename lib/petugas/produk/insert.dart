import 'package:flutter/material.dart'; // Mengimpor paket Flutter untuk membangun antarmuka pengguna.
import 'package:pl1_kasir/petugas/home.dart'; // Mengimpor halaman Home.
import 'package:supabase_flutter/supabase_flutter.dart'; // Mengimpor Supabase untuk interaksi dengan backend.

// Halaman StatefulWidget untuk menambahkan produk baru.
class AddProdukPage extends StatefulWidget {
  @override
  _AddProdukPageState createState() => _AddProdukPageState(); // Membuat State terkait.
}

// State dari AddProdukPage.
class _AddProdukPageState extends State<AddProdukPage> {
  final _formKey = GlobalKey<FormState>(); // Kunci global untuk validasi form.
  final TextEditingController _nama_produkController = TextEditingController(); // Controller untuk input nama produk.
  final TextEditingController _hargaController = TextEditingController(); // Controller untuk input harga produk.
  final TextEditingController _stokController = TextEditingController(); // Controller untuk input stok produk.

  // Fungsi untuk menambahkan produk baru ke database.
  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) {
      return; // Jika form tidak valid, hentikan proses.
    }

    // Mengambil nilai input dari controller.
    final nama_produk = _nama_produkController.text;
    final harga = _hargaController.text;
    final stok = _stokController.text;

    // Validasi tambahan untuk memastikan input tidak kosong.
    if (nama_produk.isEmpty || harga.isEmpty || stok.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua wajib diisi')), // Menampilkan pesan error.
      );
      return;
    }

    // Menambahkan data produk ke tabel 'produk' di Supabase.
    final response = await Supabase.instance.client.from('produk').insert([
      {
        'nama_produk': nama_produk, // Nama produk.
        'harga': harga, // Harga produk.
        'stok': stok, // Stok produk.
      }
    ]);

    // Mengecek apakah ada error dalam respons.
    if (response != null) {
      // Menampilkan pesan error jika ada kesalahan.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.error!.message}')),
      );
    } else {
      // Menampilkan pesan sukses jika produk berhasil ditambahkan.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk berhasil ditambahkan'),  // Pesan sukses
            backgroundColor: Colors.pinkAccent,),
      );
    }

    // Membersihkan form setelah data ditambahkan.
    _nama_produkController.clear();
    _hargaController.clear();
    _stokController.clear();

    // Kembali ke halaman sebelumnya dan mengindikasikan bahwa data telah ditambahkan.
    Navigator.pop(context, true);

    // Memuat ulang halaman Home.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Produk'), // Menampilkan judul halaman.
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Memberikan padding pada konten.
        child: Form(
          key: _formKey, // Menghubungkan form dengan kunci validasi.
          child: Column(
            children: [
              // Input untuk nama produk.
              TextFormField(
                controller: _nama_produkController, // Controller untuk nama produk.
                decoration: InputDecoration(labelText: 'Nama Produk'), // Label input.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Nama Produk'; // Validasi untuk nama produk.
                  }
                  return null;
                },
              ),
              // Input untuk harga produk.
              TextFormField(
                controller: _hargaController, // Controller untuk harga produk.
                decoration: InputDecoration(labelText: 'Harga Produk'), // Label input.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Harga Produk'; // Validasi untuk harga produk.
                  }
                  return null;
                },
              ),
              // Input untuk stok produk.
              TextFormField(
                controller: _stokController, // Controller untuk stok produk.
                decoration: InputDecoration(labelText: 'Stok Produk'), // Label input.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Stok Produk'; // Validasi untuk stok produk.
                  }
                  return null;
                },
              ),
              SizedBox(height: 20), // Spasi antara input dan tombol.
              // Tombol untuk menambahkan produk.
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addProduct(); // Memanggil fungsi untuk menambahkan produk jika form valid.
                  }
                },
                child: Text('Tambah Produk'), // Label pada tombol.
              ),
            ],
          ),
        ),
      ),
    );
  }
}
