import 'package:flutter/material.dart';
import 'package:pl1_kasir/petugas/home.dart';
import 'package:pl1_kasir/petugas/pelanggan/pelanggan.dart';
import 'package:pl1_kasir/petugas/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Halaman untuk menambahkan pelanggan baru
class AddPelangganPage extends StatefulWidget {
  @override
  _AddPelangganPageState createState() => _AddPelangganPageState();
}

class _AddPelangganPageState extends State<AddPelangganPage> {
  final _formKey = GlobalKey<FormState>(); // Kunci untuk form validasi
  final TextEditingController _nama_pelangganController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _no_teleponController = TextEditingController();

  // Method untuk menambahkan pelanggan ke Supabase
  Future<void> _addPelanggan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final nama_pelanggan = _nama_pelangganController.text;
    final alamat = _alamatController.text;
    final no_telepon = _no_teleponController.text;

    // Validasi input tidak boleh kosong
    if (nama_pelanggan.isEmpty || alamat.isEmpty || no_telepon.isEmpty) {
      // Menampilkan pesan error jika ada field yang kosong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua wajib diisi')),
      );
      return;
    }

    // Mengirim data pelanggan ke database Supabase
    final response = await Supabase.instance.client.from('pelanggan').insert([
      {
        'nama_pelanggan': nama_pelanggan,
        'alamat': alamat,
        'no_telepon': no_telepon,
      }
    ]);

    // Mengecek apakah ada error dalam response
    if (response != null) {
      // Menampilkan pesan error dari Supabase jika terjadi kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Error: ${response.error!.message}')), // Akses pesan error dengan benar
      );
    } else {
      // Menampilkan pesan sukses jika pelanggan berhasil ditambahkan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pelanggan berhasil ditambahkan'),  // Error message
            backgroundColor: Colors.pinkAccent,),
      );
    }

    // Mengosongkan form setelah data berhasil disimpan
    _nama_pelangganController.clear();
    _alamatController.clear();
    _no_teleponController.clear();

    // Kembali ke halaman sebelumnya dengan mengirimkan status sukses
    Navigator.pop(context, true);

    // Mengganti halaman saat ini dengan HomePage untuk memperbarui daftar pelanggan
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pelanggan'), // Judul halaman
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding halaman
        child: Form(
          key: _formKey, // Menetapkan kunci form untuk validasi
          child: Column(
            children: [
              // Input untuk nama pelanggan
              TextFormField(
                controller: _nama_pelangganController,
                decoration: InputDecoration(labelText: 'Nama Pelanggan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Nama Pelanggan';
                  }
                  return null;
                },
              ),
              // Input untuk alamat pelanggan
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Alamat';
                  }
                  return null;
                },
              ),
              // Input untuk nomor telepon pelanggan
              TextFormField(
                controller: _no_teleponController,
                decoration: InputDecoration(labelText: 'No Telp'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Nomor Telepon';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20), // Jarak antar elemen
              
              // Tombol untuk menambahkan pelanggan
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Menambahkan pelanggan jika form valid
                    _addPelanggan();
                  }
                },
                child: Text('Tambah Pelanggan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}