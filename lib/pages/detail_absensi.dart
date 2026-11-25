import 'package:flutter/material.dart';

/// Halaman detail absensi satu mahasiswa.
/// Tampilannya mengikuti halaman Detail Presensi.
/// Jika tombol "Absen Sekarang" ditekan, halaman menutup dan
/// mengembalikan nilai true ke halaman sebelumnya.
class DetailAbsensi extends StatelessWidget {
  final String nama;
  final String nim;
  final String mataKuliah;
  final String tanggal;
  final String status;

  const DetailAbsensi({
    super.key,
    required this.nama,
    required this.nim,
    this.mataKuliah = 'Pemrograman Mobile',
    this.tanggal = '19 Oktober 2026',
    this.status = 'Belum Absen',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Absensi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Konfirmasi Absensi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Kartu berisi data absensi
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    _InfoTile(
                      icon: Icons.person,
                      iconColor: Colors.blue,
                      title: 'Nama Mahasiswa',
                      value: nama,
                    ),
                    const _Pemisah(),
                    _InfoTile(
                      icon: Icons.badge,
                      iconColor: Colors.blue,
                      title: 'NIM',
                      value: nim,
                    ),
                    const _Pemisah(),
                    _InfoTile(
                      icon: Icons.menu_book,
                      iconColor: Colors.blue,
                      title: 'Mata Kuliah',
                      value: mataKuliah,
                    ),
                    const _Pemisah(),
                    _InfoTile(
                      icon: Icons.calendar_today,
                      iconColor: Colors.blue,
                      title: 'Tanggal',
                      value: tanggal,
                    ),
                    const _Pemisah(),
                    _InfoTile(
                      icon: Icons.check_circle,
                      iconColor: Colors.green,
                      title: 'Status',
                      value: status,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol outline selebar layar
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  // Kembali ke halaman sebelumnya sambil mengirim hasil: sudah absen
                  Navigator.pop(context, true);
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Absen Sekarang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: const TextStyle(fontSize: 17)),
      subtitle: Text(value, style: const TextStyle(fontSize: 14)),
    );
  }
}

class _Pemisah extends StatelessWidget {
  const _Pemisah();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 16, endIndent: 16);
  }
}
