import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manajemen Data Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MahasiswaListScreen(),
    );
  }
}

// Model Data Mahasiswa
class Mahasiswa {
  String id;
  String nim;
  String nama;
  String prodi;
  String kelas;

  Mahasiswa({
    required this.id,
    required this.nim,
    required this.nama,
    required this.prodi,
    required this.kelas,
  });
}

// ==========================================
// 1. HALAMAN DAFTAR MAHASISWA (MAIN SCREEN)
// ==========================================
class MahasiswaListScreen extends StatefulWidget {
  const MahasiswaListScreen({super.key});

  @override
  State<MahasiswaListScreen> createState() => _MahasiswaListScreenState();
}

class _MahasiswaListScreenState extends State<MahasiswaListScreen> {
  // Data Awal Minimal 5 Mahasiswa (Tahap 1)
  final List<Mahasiswa> _listMahasiswa = [
    Mahasiswa(id: '1', nim: '231001', nama: 'Mutiara', prodi: 'Informatika', kelas: 'TI-3A'),
    Mahasiswa(id: '2', nim: '231002', nama: 'Wahyuni', prodi: 'Informatika', kelas: 'TI-3A'),
    Mahasiswa(id: '3', nim: '231003', nama: 'Mumut', prodi: 'Sistem Informasi', kelas: 'SI-3B'),
    Mahasiswa(id: '4', nim: '231004', nama: 'Muti', prodi: 'Teknik Komputer', kelas: 'TK-3A'),
    Mahasiswa(id: '5', nim: '231005', nama: 'Mtirwhy', prodi: 'Informatika', kelas: 'TI-3B'),
  ];

  String _searchQuery = '';
  String _selectedProdiFilter = 'Semua';

  final List<String> _prodiOptions = [
    'Semua',
    'Informatika',
    'Sistem Informasi',
    'Teknik Komputer',
  ];

  // Fungsi Tambah Data
  void _addMahasiswa(Mahasiswa m) {
    setState(() {
      _listMahasiswa.add(m);
    });
  }

  // Fungsi Update Data
  void _updateMahasiswa(Mahasiswa updatedM) {
    setState(() {
      final index = _listMahasiswa.indexWhere((m) => m.id == updatedM.id);
      if (index != -1) {
        _listMahasiswa[index] = updatedM;
      }
    });
  }

  // Fungsi Hapus Data (Tahap 6)
  void _deleteMahasiswa(String id) {
    setState(() {
      _listMahasiswa.removeWhere((m) => m.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fitur Pencarian (Tahap 7) & Filter Prodi (Tantangan 1)
    final filteredList = _listMahasiswa.where((m) {
      final matchesQuery = m.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.nim.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesProdi = _selectedProdiFilter == 'Semua' || m.prodi == _selectedProdiFilter;
      return matchesQuery && matchesProdi;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Mahasiswa'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Counter Mahasiswa (Tantangan 2)
          Container(
            padding: const EdgeInsets.all(12.0),
            color: Colors.blue.shade50,
            width: double.infinity,
            child: Text(
              'Total Mahasiswa: ${_listMahasiswa.length}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          
          // Field Pencarian (Tahap 7)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Cari nama atau NIM...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),

          // Filter Dropdown Prodi (Tantangan 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                const Text('Filter Prodi: '),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedProdiFilter,
                    isExpanded: true,
                    items: _prodiOptions.map((prodi) {
                      return DropdownMenuItem(value: prodi, child: Text(prodi));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedProdiFilter = val;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          // Daftar Mahasiswa / Empty State (Tantangan 3)
          Expanded(
            child: filteredList.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada data mahasiswa',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(item.nim, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(width: 16),
                              Expanded(child: Text(item.nama)),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.prodi),
                                Text(item.kelas),
                              ],
                            ),
                          ),
                          onTap: () async {
                            // Pindah ke Detail (Tahap 4)
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MahasiswaDetailScreen(
                                  mahasiswa: item,
                                  onUpdate: _updateMahasiswa,
                                  onDelete: _deleteMahasiswa,
                                ),
                              ),
                            );
                            setState(() {}); // refresh screen
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      // Tombol Tambah Data (Tahap 2)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FormMahasiswaScreen(
                onSave: (newMahasiswa) {
                  _addMahasiswa(newMahasiswa);
                },
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Mahasiswa'),
      ),
    );
  }
}

// ==========================================
// 2. HALAMAN FORM TAMBAH / EDIT MAHASISWA
// ==========================================
class FormMahasiswaScreen extends StatefulWidget {
  final Mahasiswa? mahasiswa; // null jika Tambah, terisi jika Edit
  final Function(Mahasiswa) onSave;

  const FormMahasiswaScreen({
    super.key,
    this.mahasiswa,
    required this.onSave,
  });

  @override
  State<FormMahasiswaScreen> createState() => _FormMahasiswaScreenState();
}

class _FormMahasiswaScreenState extends State<FormMahasiswaScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nimController;
  late TextEditingController _namaController;
  late TextEditingController _prodiController;
  late TextEditingController _kelasController;

  @override
  void initState() {
    super.initState();
    // Autofill data lama jika posisi Edit (Tahap 5)
    _nimController = TextEditingController(text: widget.mahasiswa?.nim ?? '');
    _namaController = TextEditingController(text: widget.mahasiswa?.nama ?? '');
    _prodiController = TextEditingController(text: widget.mahasiswa?.prodi ?? '');
    _kelasController = TextEditingController(text: widget.mahasiswa?.kelas ?? '');
  }

  @override
  void dispose() {
    _nimController.dispose();
    _namaController.dispose();
    _prodiController.dispose();
    _kelasController.dispose();
    super.dispose();
  }

  void _submit() {
    // Validasi Form (Tahap 3)
    if (_formKey.currentState!.validate()) {
      final m = Mahasiswa(
        id: widget.mahasiswa?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        nim: _nimController.text,
        nama: _namaController.text,
        prodi: _prodiController.text,
        kelas: _kelasController.text,
      );
      widget.onSave(m);
      Navigator.pop(context, m);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.mahasiswa != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Form Edit Mahasiswa' : 'Form Tambah Mahasiswa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nimController,
                decoration: const InputDecoration(labelText: 'NIM', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'NIM wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _prodiController,
                decoration: const InputDecoration(labelText: 'Program Studi', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Program Studi wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _kelasController,
                decoration: const InputDecoration(labelText: 'Kelas', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Kelas wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(isEdit ? 'Simpan Perubahan' : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3. HALAMAN DETAIL MAHASISWA
// ==========================================
class MahasiswaDetailScreen extends StatefulWidget {
  final Mahasiswa mahasiswa;
  final Function(Mahasiswa) onUpdate;
  final Function(String) onDelete;

  const MahasiswaDetailScreen({
    super.key,
    required this.mahasiswa,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<MahasiswaDetailScreen> createState() => _MahasiswaDetailScreenState();
}

class _MahasiswaDetailScreenState extends State<MahasiswaDetailScreen> {
  late Mahasiswa _currentData;

  @override
  void initState() {
    super.initState();
    _currentData = widget.mahasiswa;
  }

  // Dialog Konfirmasi Hapus (Tahap 6)
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              widget.onDelete(_currentData.id);
              Navigator.pop(ctx); // Tutup Dialog
              Navigator.pop(context); // Kembali ke list
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Mahasiswa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('NIM', style: TextStyle(color: Colors.grey, fontSize: 14)),
            Text(_currentData.nim, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            const Text('Nama', style: TextStyle(color: Colors.grey, fontSize: 14)),
            Text(_currentData.nama, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            const Text('Program Studi', style: TextStyle(color: Colors.grey, fontSize: 14)),
            Text(_currentData.prodi, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            const Text('Kelas', style: TextStyle(color: Colors.grey, fontSize: 14)),
            Text(_currentData.kelas, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Spacer(),

            // Tombol Edit & Hapus
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    onPressed: () async {
                      // Buka Form Edit (Tahap 5)
                      final result = await Navigator.push<Mahasiswa>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FormMahasiswaScreen(
                            mahasiswa: _currentData,
                            onSave: (updated) {
                              widget.onUpdate(updated);
                            },
                          ),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          _currentData = result;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100),
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text('Hapus', style: TextStyle(color: Colors.red)),
                    onPressed: _confirmDelete,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}