import 'package:flutter/material.dart';

import '../models/mahasiswa.dart';

class FormMahasiswaPage extends StatefulWidget {
  final Mahasiswa? mahasiswa;
  final Set<String> nimTerpakai;

  const FormMahasiswaPage({
    super.key,
    this.mahasiswa,
    required this.nimTerpakai,
  });

  @override
  State<FormMahasiswaPage> createState() => _FormMahasiswaPageState();
}

class _FormMahasiswaPageState extends State<FormMahasiswaPage> {
  static const _opsiSemester = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
  ];
  static const _opsiStatus = ['Aktif', 'Cuti', 'Lulus', 'Non-aktif'];
  static const _opsiMinat = [
    'Pemrograman',
    'Desain',
    'Multimedia',
    'Jaringan',
    'Data',
    'Robotika',
    'Bisnis Digital',
  ];
  static const _palet = [
    '1E3A5F',
    '0F766E',
    '7C3AED',
    'B45309',
    'BE123C',
    '334155',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nim;
  late final TextEditingController _nama;
  late final TextEditingController _panggilan;
  late final TextEditingController _prodi;
  late final TextEditingController _email;
  late final TextEditingController _nohp;
  late final TextEditingController _jeniskelamin;
  late final TextEditingController _tempatlahir;
  late final TextEditingController _tanggallahir;
  late final TextEditingController _agama;
  late final TextEditingController _kelas;
  late final TextEditingController _ipk;
  late final TextEditingController _alamat;
  late final TextEditingController _provinsi;
  late final TextEditingController _kota;
  late final TextEditingController _fotoprofil;
  late final TextEditingController _dokumen;

  String? _semester;
  String? _status;
  late bool _beasiswa;
  late bool _magang;
  late Set<String> _minat;
  late String _warna;
  late bool _setuju;

  @override
  void initState() {
    super.initState();
    final m = widget.mahasiswa;
    _nim = TextEditingController(text: m?.nim);
    _nama = TextEditingController(text: m?.nama);
    _panggilan = TextEditingController(text: m?.panggilan);
    _prodi = TextEditingController(text: m?.prodi);
    _email = TextEditingController(text: m?.email);
    _nohp = TextEditingController(text: m?.noHp);
    _jeniskelamin = TextEditingController(text: m?.jenisKelamin);
    _tempatlahir = TextEditingController(text: m?.tempatLahir);
    _tanggallahir = TextEditingController(text: m?.tanggalLahir);
    _agama = TextEditingController(text: m?.agama);
    _kelas = TextEditingController(text: m?.kelas);
    _ipk = TextEditingController(text: m?.ipk);
    _alamat = TextEditingController(text: m?.alamat);
    _provinsi = TextEditingController(text: m?.provinsi);
    _kota = TextEditingController(text: m?.kota);
    _fotoprofil = TextEditingController(text: m?.fotoprofil);
    _dokumen = TextEditingController(text: m?.dokumen);

    _semester = (m == null || m.semester.isEmpty) ? null : m.semester;
    _status = (m == null || m.status.isEmpty) ? null : m.status;
    _beasiswa = m?.penerimabeasiswa == 'Ya';
    _magang = m?.bersediamagang == 'Ya';
    _minat = (m == null || m.minat.isEmpty)
        ? <String>{}
        : m.minat.split(', ').toSet();
    _warna = (m == null || m.warnaprofil.isEmpty)
        ? _palet.first
        : m.warnaprofil;
    _setuju = m?.persetujuandata == 'Ya';
  }

  @override
  void dispose() {
    _nim.dispose();
    _nama.dispose();
    _panggilan.dispose();
    _prodi.dispose();
    _email.dispose();
    _nohp.dispose();
    _jeniskelamin.dispose();
    _tempatlahir.dispose();
    _tanggallahir.dispose();
    _agama.dispose();
    _kelas.dispose();
    _ipk.dispose();
    _alamat.dispose();
    _provinsi.dispose();
    _kota.dispose();
    _fotoprofil.dispose();
    _dokumen.dispose();
    super.dispose();
  }

  String? _wajib(String? value, String label) {
    return value == null || value.trim().isEmpty
        ? '$label tidak boleh kosong'
        : null;
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Mahasiswa(
        nim: _nim.text.trim(),
        nama: _nama.text.trim(),
        panggilan: _panggilan.text.trim(),
        prodi: _prodi.text.trim(),
        email: _email.text.trim(),
        noHp: _nohp.text.trim(),
        jenisKelamin: _jeniskelamin.text.trim(),
        tempatLahir: _tempatlahir.text.trim(),
        tanggalLahir: _tanggallahir.text.trim(),
        agama: _agama.text.trim(),
        semester: _semester ?? '',
        kelas: _kelas.text.trim(),
        status: _status ?? '',
        ipk: _ipk.text.trim().replaceAll(',', '.'),
        penerimabeasiswa: _beasiswa ? 'Ya' : 'Tidak',
        bersediamagang: _magang ? 'Ya' : 'Tidak',
        minat: _opsiMinat.where(_minat.contains).join(', '),
        alamat: _alamat.text.trim(),
        provinsi: _provinsi.text.trim(),
        kota: _kota.text.trim(),
        fotoprofil: _fotoprofil.text.trim(),
        dokumen: _dokumen.text.trim(),
        warnaprofil: _warna,
        persetujuandata: _setuju ? 'Ya' : 'Tidak',
      ),
    );
  }

  InputDecoration _dekor(
    String label,
    IconData icon, {
    Widget? suffix,
    String? helper,
  }) {
    final cs = Theme.of(context).colorScheme;
    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecoration(
      labelText: label,
      helperText: helper,
      prefixIcon: Icon(icon, size: 22),
      suffixIcon: suffix,
      filled: true,
      fillColor: cs.surface,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: border(cs.outlineVariant),
      enabledBorder: border(cs.outlineVariant),
      focusedBorder: border(cs.primary, 1.8),
      errorBorder: border(cs.error),
      focusedErrorBorder: border(cs.error, 1.8),
    );
  }

  Widget _judul(String teks, IconData icon) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: cs.primary),
          const SizedBox(width: 8),
          Text(
            teks.toUpperCase(),
            style: text.labelMedium?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _kotak() {
    final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: cs.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: cs.outlineVariant),
    );
  }

  Widget _saklar(
    String judul,
    IconData icon,
    bool nilai,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      decoration: _kotak(),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        secondary: Icon(icon),
        title: Text(judul),
        value: nilai,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    const gap = SizedBox(height: 14);
    const jarakBagian = SizedBox(height: 28);

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(
          widget.mahasiswa == null ? 'Tambah Mahasiswa' : 'Edit Mahasiswa',
          style: text.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        backgroundColor: cs.surfaceContainerLowest,
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                // ---------------- AKADEMIK ----------------
                _judul('Akademik', Icons.school_outlined),
                TextFormField(
                  controller: _nim,
                  decoration: _dekor('NIM', Icons.badge_outlined),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    final error = _wajib(value, 'NIM');
                    if (error != null) return error;
                    if (widget.nimTerpakai.contains(
                      value!.trim().toLowerCase(),
                    )) {
                      return 'NIM sudah digunakan';
                    }
                    return null;
                  },
                ),
                gap,
                TextFormField(
                  controller: _prodi,
                  decoration: _dekor('Program Studi', Icons.menu_book_outlined),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (value) => _wajib(value, 'Program studi'),
                ),
                gap,
                DropdownButtonFormField<String>(
                  initialValue: _semester,
                  decoration: _dekor(
                    'Semester',
                    Icons.calendar_view_week_outlined,
                  ),
                  items: _opsiSemester
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _semester = v),
                  validator: (v) => v == null ? 'Semester wajib dipilih' : null,
                ),
                gap,
                TextFormField(
                  controller: _kelas,
                  decoration: _dekor('Kelas', Icons.class_outlined),
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                  validator: (value) => _wajib(value, 'Kelas'),
                ),
                gap,
                DropdownButtonFormField<String>(
                  initialValue: _status,
                  decoration: _dekor('Status', Icons.verified_outlined),
                  items: _opsiStatus
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _status = v),
                  validator: (v) => v == null ? 'Status wajib dipilih' : null,
                ),
                gap,
                TextFormField(
                  controller: _ipk,
                  decoration: _dekor('IPK', Icons.grade_outlined),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    final error = _wajib(value, 'IPK');
                    if (error != null) return error;
                    final angka = double.tryParse(
                      value!.trim().replaceAll(',', '.'),
                    );
                    if (angka == null || angka < 0 || angka > 4) {
                      return 'IPK harus berupa angka 0 sampai 4';
                    }
                    return null;
                  },
                ),
                jarakBagian,

                // ---------------- IDENTITAS ----------------
                _judul('Identitas', Icons.person_outline),
                TextFormField(
                  controller: _nama,
                  decoration: _dekor('Nama Lengkap', Icons.person_outline),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (value) => _wajib(value, 'Nama'),
                ),
                gap,
                TextFormField(
                  controller: _panggilan,
                  decoration: _dekor(
                    'Nama Panggilan',
                    Icons.sentiment_satisfied_alt_outlined,
                  ),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (value) => _wajib(value, 'Nama Panggilan'),
                ),
                gap,
                TextFormField(
                  controller: _jeniskelamin,
                  decoration: _dekor('Jenis Kelamin', Icons.wc_outlined),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (value) => _wajib(value, 'Jenis Kelamin'),
                ),
                gap,
                TextFormField(
                  controller: _tempatlahir,
                  decoration: _dekor(
                    'Tempat Lahir',
                    Icons.location_on_outlined,
                  ),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (value) => _wajib(value, 'Tempat Lahir'),
                ),
                gap,
                TextFormField(
                  controller: _tanggallahir,
                  decoration: _dekor(
                    'Tanggal Lahir',
                    Icons.cake_outlined,
                    suffix: const Icon(Icons.calendar_today_outlined),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final tanggal = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );
                    if (tanggal != null) {
                      _tanggallahir.text =
                          '${tanggal.day.toString().padLeft(2, '0')}-'
                          '${tanggal.month.toString().padLeft(2, '0')}-'
                          '${tanggal.year}';
                    }
                  },
                  validator: (value) => _wajib(value, 'Tanggal Lahir'),
                ),
                gap,
                TextFormField(
                  controller: _agama,
                  decoration: _dekor('Agama', Icons.favorite_border),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (value) => _wajib(value, 'Agama'),
                ),
                jarakBagian,

                // ---------------- ALAMAT ----------------
                _judul('Alamat', Icons.home_outlined),
                TextFormField(
                  controller: _alamat,
                  decoration: _dekor('Alamat Lengkap', Icons.home_outlined),
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  minLines: 2,
                  maxLines: 4,
                  validator: (value) => _wajib(value, 'Alamat'),
                ),
                gap,
                TextFormField(
                  controller: _kota,
                  decoration: _dekor(
                    'Kota / Kabupaten',
                    Icons.location_city_outlined,
                  ),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (value) => _wajib(value, 'Kota'),
                ),
                gap,
                TextFormField(
                  controller: _provinsi,
                  decoration: _dekor('Provinsi', Icons.map_outlined),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (value) => _wajib(value, 'Provinsi'),
                ),
                jarakBagian,

                // ---------------- KONTAK ----------------
                _judul('Kontak', Icons.contact_phone_outlined),
                TextFormField(
                  controller: _nohp,
                  decoration: _dekor('No. HP', Icons.phone_outlined),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: (value) => _wajib(value, 'No. HP'),
                ),
                gap,
                TextFormField(
                  controller: _email,
                  decoration: _dekor('Email', Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    final error = _wajib(value, 'Email');
                    if (error != null) return error;
                    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                    if (!regex.hasMatch(value!.trim())) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                jarakBagian,

                // ---------------- PREFERENSI ----------------
                _judul('Preferensi', Icons.tune_outlined),
                _saklar(
                  'Penerima beasiswa',
                  Icons.workspace_premium_outlined,
                  _beasiswa,
                  (v) => setState(() => _beasiswa = v),
                ),
                gap,
                _saklar(
                  'Bersedia magang',
                  Icons.work_outline,
                  _magang,
                  (v) => setState(() => _magang = v),
                ),
                gap,
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: _kotak(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.interests_outlined),
                          const SizedBox(width: 12),
                          Text('Minat', style: text.bodyLarge),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final opsi in _opsiMinat)
                            FilterChip(
                              label: Text(opsi),
                              selected: _minat.contains(opsi),
                              onSelected: (aktif) => setState(() {
                                aktif ? _minat.add(opsi) : _minat.remove(opsi);
                              }),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                jarakBagian,

                // ---------------- TAMPILAN & BERKAS ----------------
                _judul('Tampilan & Berkas', Icons.palette_outlined),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: _kotak(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Warna profil', style: text.bodyLarge),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          for (final hex in _palet)
                            GestureDetector(
                              onTap: () => setState(() => _warna = hex),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(int.parse('FF$hex', radix: 16)),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _warna == hex
                                        ? cs.onSurface
                                        : Colors.transparent,
                                    width: 2.5,
                                  ),
                                ),
                                child: _warna == hex
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 20,
                                      )
                                    : null,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                gap,
                TextFormField(
                  controller: _fotoprofil,
                  decoration: _dekor(
                    'Foto Profil',
                    Icons.image_outlined,
                    helper: 'Opsional. Isi dengan URL gambar (https://...)',
                  ),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                ),
                gap,
                TextFormField(
                  controller: _dokumen,
                  decoration: _dekor(
                    'Dokumen',
                    Icons.description_outlined,
                    helper: 'Opsional. Isi dengan nama file atau tautan',
                  ),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _simpan(),
                ),
                jarakBagian,

                // ---------------- PERSETUJUAN ----------------
                FormField<bool>(
                  initialValue: _setuju,
                  validator: (v) =>
                      v == true ? null : 'Persetujuan wajib dicentang',
                  builder: (state) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: _kotak().copyWith(
                          border: Border.all(
                            color: state.hasError
                                ? cs.error
                                : cs.outlineVariant,
                          ),
                        ),
                        child: CheckboxListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: state.value ?? false,
                          title: const Text(
                            'Saya menyetujui data ini disimpan dan digunakan.',
                          ),
                          onChanged: (v) {
                            state.didChange(v);
                            setState(() => _setuju = v ?? false);
                          },
                        ),
                      ),
                      if (state.hasError)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 6, 0, 0),
                          child: Text(
                            state.errorText!,
                            style: text.bodySmall?.copyWith(color: cs.error),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: _simpan,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Simpan Data'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
