import 'package:flutter/material.dart';

import '../models/mahasiswa.dart';
import 'detail_mahasiswa_page.dart';
import 'form_mahasiswa_page.dart';

class ListMahasiswaPage extends StatefulWidget {
  const ListMahasiswaPage({super.key});

  @override
  State<ListMahasiswaPage> createState() => _ListMahasiswaPageState();
}

class _ListMahasiswaPageState extends State<ListMahasiswaPage> {
  final _search = TextEditingController();
  final _mahasiswa = <Mahasiswa>[
    const Mahasiswa(
      nim: '2026001',
      nama: 'Andi Pratama',
      panggilan: 'Andi',
      prodi: 'Teknik Informatika',
      email: 'andi@gmail.com',
      noHp: '085918006667',
      jenisKelamin: 'Laki-laki',
      tempatLahir: 'Bogor',
      tanggalLahir: '15 september 1992',
      agama: 'Islam',
      semester: '5',
      kelas: 'A',
      status: 'Aktif',
      ipk: '3.50',
      penerimabeasiswa: 'Tidak',
      bersediamagang: 'Ya',
      minat: 'Pemrograman, Multimedia',
      alamat: 'Jl. Merdeka No. 10',
      provinsi: 'Jawa Barat',
      kota: 'Bogor',
      fotoprofil: '',
      dokumen: '',
      warnaprofil: '1E3A5F',
      persetujuandata: 'Ya',
    ),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Set<String> _nimTerpakai([Mahasiswa? except]) => _mahasiswa
      .where((item) => item != except)
      .map((item) => item.nim.toLowerCase())
      .toSet();

  void _pesan(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  String _inisial(String nama) {
    final parts = nama
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  Future<void> _tambah() async {
    final result = await Navigator.push<Mahasiswa>(
      context,
      MaterialPageRoute(
        builder: (_) => FormMahasiswaPage(nimTerpakai: _nimTerpakai()),
      ),
    );
    if (!mounted || result == null) return;
    setState(() => _mahasiswa.add(result));
    _pesan('Data mahasiswa berhasil ditambahkan');
  }

  Future<void> _detail(Mahasiswa mahasiswa) async {
    final result = await Navigator.push<DetailResult>(
      context,
      MaterialPageRoute(
        builder: (_) => DetailMahasiswaPage(
          mahasiswa: mahasiswa,
          nimLain: _nimTerpakai(mahasiswa),
        ),
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      final index = _mahasiswa.indexOf(mahasiswa);
      if (result.mahasiswa == null) {
        _mahasiswa.removeAt(index);
      } else {
        _mahasiswa[index] = result.mahasiswa!;
      }
    });
    _pesan(
      result.mahasiswa == null
          ? 'Data mahasiswa berhasil dihapus'
          : 'Data mahasiswa berhasil diperbarui',
    );
  }

  Widget _kartu(Mahasiswa m) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _detail(m),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.6)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: cs.primaryContainer,
                child: Text(
                  _inisial(m.nama),
                  style: text.titleMedium?.copyWith(
                    color: cs.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      m.prodi,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: cs.secondaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  m.nim,
                  style: text.labelMedium?.copyWith(
                    color: cs.onSecondaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded, color: cs.outline),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final keyword = _search.text.trim().toLowerCase();
    final filtered = _mahasiswa
        .where(
          (item) =>
              item.nama.toLowerCase().contains(keyword) ||
              item.panggilan.toLowerCase().contains(keyword) ||
              item.nim.toLowerCase().contains(keyword) ||
              item.prodi.toLowerCase().contains(keyword) ||
              item.email.toLowerCase().contains(keyword) ||
              item.noHp.toLowerCase().contains(keyword) ||
              item.jenisKelamin.toLowerCase().contains(keyword) ||
              item.tempatLahir.toLowerCase().contains(keyword) ||
              item.tanggalLahir.toLowerCase().contains(keyword) ||
              item.agama.toLowerCase().contains(keyword),
        )
        .toList();

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(
          'Data Mahasiswa',
          style: text.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        backgroundColor: cs.surfaceContainerLowest,
        scrolledUnderElevation: 0,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 150,
                padding: const EdgeInsets.all(24),
                alignment: Alignment.bottomLeft,
                color: cs.primaryContainer,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.school_rounded,
                      size: 36,
                      color: cs.onPrimaryContainer,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Manajemen Mahasiswa',
                      style: text.titleMedium?.copyWith(
                        color: cs.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.people_outline),
                title: const Text('Daftar Mahasiswa'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.person_add_outlined),
                title: const Text('Tambah Mahasiswa'),
                onTap: () {
                  Navigator.pop(context);
                  _tambah();
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                child: TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Cari nama, NIM, atau program studi',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Hapus pencarian',
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => setState(_search.clear),
                          ),
                    filled: true,
                    fillColor: cs.surfaceContainerHigh,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${filtered.length} dari ${_mahasiswa.length} mahasiswa',
                    style: text.labelLarge?.copyWith(
                      color: cs.onSurfaceVariant,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _mahasiswa.isEmpty
                                  ? Icons.group_add_outlined
                                  : Icons.person_search_outlined,
                              size: 56,
                              color: cs.outline,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _mahasiswa.isEmpty
                                  ? 'Belum ada mahasiswa. Tambahkan data baru.'
                                  : 'Mahasiswa tidak ditemukan.',
                              style: text.bodyLarge?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) =>
                            _kartu(filtered[index]),
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambah,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Mahasiswa'),
      ),
    );
  }
}
