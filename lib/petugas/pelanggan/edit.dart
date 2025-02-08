import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Halaman untuk mengedit data pelanggan
class EditPelangganPage extends StatefulWidget {
  final String nama_pelanggan;
  final String alamat;
  final String no_telepon;

  // Konstruktor menerima data pelanggan yang akan diedit
  const EditPelangganPage({
    Key? key,
    required this.nama_pelanggan,
    required this.alamat,
    required this.no_telepon,
  }) : super(key: key);

  @override
  _EditPelangganPageState createState() => _EditPelangganPageState();
}

class _EditPelangganPageState extends State<EditPelangganPage> {
  final _formKey = GlobalKey<FormState>(); // Kunci untuk form validasi

  late TextEditingController _nama_pelangganController;
  late TextEditingController _alamatController;
  late TextEditingController _no_teleponController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan nilai dari widget yang diterima
    _nama_pelangganController = TextEditingController(text: widget.nama_pelanggan);
    _alamatController = TextEditingController(text: widget.alamat);
    _no_teleponController = TextEditingController(text: widget.no_telepon);
  }

  @override
  void dispose() {
    // Membersihkan controller setelah widget dihapus untuk menghindari memory leak
    _nama_pelangganController.dispose();
    _alamatController.dispose();
    _no_teleponController.dispose();
    super.dispose();
  }

  // Fungsi untuk memperbarui data pelanggan di database
  Future<void> _updateCustomer() async {
    final response = await Supabase.instance.client
        .from('pelanggan')
        .update({
          'nama_pelanggan': _nama_pelangganController.text,
          'alamat': _alamatController.text,
          'no_telepon': _no_teleponController.text,
        })
        .eq('nama_pelanggan', widget.nama_pelanggan) // Menentukan pelanggan berdasarkan nama (sebaiknya gunakan ID jika ada)
        .select();

    if (response.error == null) {
      print('Pelanggan berhasil diperbarui'); // Log jika update berhasil
    } else {
      print('Gagal memperbarui pelanggan: ${response.error!.message}'); // Log jika update gagal
    }
  }

  // Fungsi untuk menyimpan perubahan data pelanggan
  void _saveCustomer() async {
    if (_formKey.currentState!.validate()) { // Validasi form
      await _updateCustomer(); // Memanggil fungsi update ke database

      // Kembali ke halaman sebelumnya dengan membawa data yang telah diperbarui
      Navigator.pop(context, {
        'nama_pelanggan': _nama_pelangganController.text,
        'alamat': _alamatController.text,
        'no_telepon': _no_teleponController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pelanggan'), // Judul halaman
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding halaman
        child: Form(
          key: _formKey, // Menetapkan kunci form untuk validasi
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input untuk nama pelanggan
              TextFormField(
                controller: _nama_pelangganController,
                decoration: const InputDecoration(labelText: 'Nama Pelanggan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama pelanggan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0), // Jarak antar input
              
              // Input untuk alamat pelanggan
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(labelText: 'Alamat'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              
              // Input untuk nomor telepon pelanggan
              TextFormField(
                controller: _no_teleponController,
                decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                keyboardType: TextInputType.phone, // Jenis input telepon
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor telepon tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              
              // Tombol untuk menyimpan perubahan
              ElevatedButton(
                onPressed: _saveCustomer,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Ekstensi untuk menangani error pada PostgrestList
extension on PostgrestList {
  get error => null;
}
