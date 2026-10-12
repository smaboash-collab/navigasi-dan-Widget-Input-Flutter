import 'package:flutter/material.dart';

import '../models/mahasiswa.dart';
import 'form_mahasiswa_page.dart';

class DetailResult {
  final Mahasiswa? mahasiswa;
  const DetailResult.updated(Mahasiswa this.mahasiswa);
  const DetailResult.deleted() : mahasiswa = null;
}

class DetailMahasiswaPage extends StatefulWidget {
  final Mahasiswa mahasiswa;
  final Set<String> nimLain;

  const DetailMahasiswaPage({
    super.key,
    required this.mahasiswa,
    required this.nimLain,
  });

  @override
  State<DetailMahasiswaPage> createState() => _DetailMahasiswaPageState();
}

class _DetailMahasiswaPageState extends State<DetailMahasiswaPage> {
  Future<void> _edit() async {
    final result = await Navigator.push<Mahasiswa>(
      context,
      MaterialPageRoute(
        builder: (_) => FormMahasiswaPage(
          mahasiswa: widget.mahasiswa,
          nimTerpakai: widget.nimLain,
        ),
      ),
    );
    if (!mounted || result == null) return;
    Navigator.pop(context, DetailResult.updated(result));
  }

  Color _warnaProfil(Mahasiswa m, ColorScheme cs) {
    final nilai = int.tryParse('FF${m.warnaprofil}', radix: 16);
    return nilai == null ? cs.primary : Color(nilai);
  }

  Future<void> _hapus() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus mahasiswa?'),
        content: Text(
          'Data ${widget.mahasiswa.nama} (${widget.mahasiswa.nim}) akan dihapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    Navigator.pop(context, const DetailResult.deleted());
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

  Widget _baris(IconData icon, String label, String nilai) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cs.primaryContainer.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: cs.onPrimaryContainer),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: text.labelMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 2),
                Text(
                  nilai.isEmpty ? '-' : nilai,
                  style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _seksi(String judul, List<Widget> baris) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            judul.toUpperCase(),
            style: text.labelMedium?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.6)),
          ),
          child: Column(
            children: [
              for (var i = 0; i < baris.length; i++) ...[
                if (i > 0) const Divider(height: 1, indent: 72),
                baris[i],
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.mahasiswa;
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final warna = _warnaProfil(m, cs);
    final adaFoto = m.fotoprofil.startsWith('http');

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(
          'Detail Mahasiswa',
          style: text.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        backgroundColor: cs.surfaceContainerLowest,
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 28,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      warna,
                      Color.alphaBlend(
                        Colors.black.withValues(alpha: 0.28),
                        warna,
                      ),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      backgroundImage: adaFoto
                          ? NetworkImage(m.fotoprofil)
                          : null,
                      onBackgroundImageError: adaFoto ? (_, _) {} : null,
                      child: adaFoto
                          ? null
                          : Text(
                              _inisial(m.nama),
                              style: text.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      m.nama,
                      textAlign: TextAlign.center,
                      style: text.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dipanggil ${m.panggilan}',
                      style: text.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final label in [
                          m.prodi,
                          'Semester ${m.semester}',
                          m.status,
                        ])
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              label,
                              style: text.labelLarge?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _seksi('Akademik', [
                _baris(Icons.badge_outlined, 'NIM', m.nim),
                _baris(Icons.school_outlined, 'Program Studi', m.prodi),
                _baris(
                  Icons.calendar_view_week_outlined,
                  'Semester',
                  m.semester,
                ),
                _baris(Icons.class_outlined, 'Kelas', m.kelas),
                _baris(Icons.verified_outlined, 'Status', m.status),
                _baris(Icons.grade_outlined, 'IPK', m.ipk),
              ]),
              _seksi('Data Pribadi', [
                _baris(Icons.wc_outlined, 'Jenis Kelamin', m.jenisKelamin),
                _baris(
                  Icons.location_on_outlined,
                  'Tempat Lahir',
                  m.tempatLahir,
                ),
                _baris(Icons.cake_outlined, 'Tanggal Lahir', m.tanggalLahir),
                _baris(Icons.favorite_border, 'Agama', m.agama),
              ]),
              _seksi('Alamat', [
                _baris(Icons.home_outlined, 'Alamat', m.alamat),
                _baris(Icons.location_city_outlined, 'Kota', m.kota),
                _baris(Icons.map_outlined, 'Provinsi', m.provinsi),
              ]),
              _seksi('Kontak', [
                _baris(Icons.email_outlined, 'Email', m.email),
                _baris(Icons.phone_outlined, 'No. HP', m.noHp),
              ]),
              _seksi('Preferensi', [
                _baris(
                  Icons.workspace_premium_outlined,
                  'Penerima Beasiswa',
                  m.penerimabeasiswa,
                ),
                _baris(Icons.work_outline, 'Bersedia Magang', m.bersediamagang),
                _baris(Icons.interests_outlined, 'Minat', m.minat),
              ]),
              _seksi('Berkas & Persetujuan', [
                _baris(Icons.image_outlined, 'Foto Profil', m.fotoprofil),
                _baris(Icons.description_outlined, 'Dokumen', m.dokumen),
                _baris(
                  Icons.fact_check_outlined,
                  'Persetujuan Data',
                  m.persetujuandata,
                ),
              ]),
              const SizedBox(height: 4),
              FilledButton.icon(
                onPressed: _edit,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Data'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _hapus,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Hapus Data'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: cs.error,
                  minimumSize: const Size.fromHeight(52),
                  side: BorderSide(color: cs.error.withValues(alpha: 0.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
