import 'package:flutter/services.dart';

import '../pages/detail_data.dart';
import '../pages/detail_absensi.dart';

import 'package:flutter/material.dart';

import '../widgets/student_info_card.dart';
import '../widgets/absensi_info_card.dart';
import '../widgets/custom_button.dart';
import '../services/student_service.dart';
import '../services/absensi_service.dart';
import '../models/student_info.dart';
import '../models/absensi_info.dart';
import '../services/storage_service.dart';

class CampusGoHomePage extends StatefulWidget {
  const CampusGoHomePage({super.key});

  @override
  State<CampusGoHomePage> createState() => _CampusGoHomePageState();
}

//PEMBAHASAN BAB 4
class _CampusGoHomePageState extends State<CampusGoHomePage> {
  // State untuk menyimpan jumlah presensi/aktivitas
  int _counter = 0;

  //4.1.1
  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });
    await StorageService.saveTotalAktivitas(_counter);
  }

  //4.1.2
  void _navigateToDetail([BuildContext? context]) {
    String nim = '1234567890';
    String name = 'John Doe';

    // Navigator.push untuk berpindah halaman sambil mengirim data
    Navigator.push(
      context ?? this.context,
      MaterialPageRoute(
        builder: (context) => DetailData(nama: name, nim: nim),
      ),
    );
  }

  void _navigateToAbsensi(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const DetailAbsensi(nama: 'John Doe', nim: '1234567890'),
      ),
    );
  }

  // Menyimpan proses pemuatan data mahasiswa
  late Future<List<Student>> studentsFuture;
  late Future<AbsensiInfo> absensiFuture;

  @override
  void initState() {
    super.initState();

    // Membaca data saat halaman pertama kali dibuka
    studentsFuture = StudentService.loadStudents();
    absensiFuture = AbsensiService.fetchAbsensiInfo();
    _loadSavedCounter();
  }

  // Memuat ulang data JSON
  void reloadStudents() {
    setState(() {
      studentsFuture = StudentService.loadStudents();
    });
  }

  void reloadStudent() {
    setState(() {});
    studentsFuture = StudentService.loadStudents();
  }

  // Reload data dari Network API
  void reloadAbsensi() {
    setState(() {
      absensiFuture = AbsensiService.fetchAbsensiInfo();
    });
  }

  // Mengambil data dari StorageService secara asynchronous
  Future<void> _loadSavedCounter() async {
    final savedCounter = await StorageService.getTotalAktivitas();
    if (!mounted) return;
    setState(() {
      _counter = savedCounter;
    });
  }

  // Mereset counter di UI dan menghapusnya dari Local Storage
  Future<void> _resetCounter() async {
    await StorageService.resetTotalAktivitas();
    setState(() {
      _counter = 0;
    });
  }

  @override
  /*Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CampusGo')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.school, size: 80),
              const SizedBox(height: 16),
              const Text(
                'CampusGo',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Mobile Academic Information System'),
              const SizedBox(height: 8),
              Text(
                'Total Aktivitas: $_counter',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: 'Detail Absensi',
                icon: Icons.fact_check,
                type: CustomButtonType.primary,
                onPressed: () {
                  _navigateToAbsensi();
                },
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: 'Lihat Jadwal',
                icon: Icons.calendar_today,
                type: CustomButtonType.secondary,
                onPressed: () {
                  _navigateToDetail();
                },
              ),
              const SizedBox(height: 12),

              const SizedBox(height: 12),

              CustomButton(
                label: 'Butuh Bantuan?',
                icon: Icons.help_outline,
                type: CustomButtonType.tertiary,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Membuka Pusat Bantuan...')),
                  );
                },
              ),
              const SizedBox(height: 12),
              const StudentInfoCard(),
              const SizedBox(height: 12),
              const AbsensiInfocard(),
            ],
          ),
        ),
      ),
    );
  }*/
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CampusGo')),
      body: FutureBuilder<List<Student>>(
        future: studentsFuture,
        builder: (context, snapshot) {
          // 1. LOADING STATE
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. ERROR STATE
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 56,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Gagal membaca data mahasiswa.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    CustomButton(label: 'Coba Lagi', onPressed: reloadStudents),
                  ],
                ),
              ),
            );
          }
          // 3. MENGAMBIL DATA
          final students = snapshot.data ?? <Student>[];
          // 4. EMPTY STATE
          if (students.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_outline, size: 56),
                  SizedBox(height: 12),
                  Text('Data mahasiswa kosong'),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                const Icon(Icons.school, size: 80),
                const SizedBox(height: 16),
                const Text(
                  'CampusGo',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('Mobile Academic Information System'),
                const SizedBox(height: 8),
                Text(
                  'Total Aktivitas: $_counter',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  label: 'Tambah Aktivitas',
                  icon: Icons.play_arrow,
                  type: CustomButtonType.primary,
                  onPressed: () {
                    _incrementCounter();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Aktivitas Berhasil Dimulai!'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                CustomButton(
                  label: 'Reset Aktivitas',
                  icon: Icons.refresh,
                  type: CustomButtonType.tertiary,
                  onPressed: () {
                    _resetCounter();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data Aktivitas Direset!')),
                    );
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(
                  label: 'Lihat Jadwal',
                  icon: Icons.calendar_today,
                  type: CustomButtonType.secondary,
                  onPressed: () {
                    _navigateToDetail();
                  },
                ),
                const SizedBox(height: 12),
                CustomButton(
                  label: 'Butuh Bantuan?',
                  icon: Icons.help_outline,
                  type: CustomButtonType.tertiary,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Membuka Pusat Bantuan...')),
                    );
                  },
                ),
                const SizedBox(height: 12),
                //const StudentInfoCard(),
                const SizedBox(height: 12),
                FutureBuilder<AbsensiInfo>(
                  future: absensiFuture,
                  builder: (context, snapshot) {
                    // State Loading API
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    // State Error API
                    if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Text(
                              'Gagal memuat API Absensi: ${snapshot.error}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            CustomButton(
                              label: 'Coba Lagi Absensi',
                              onPressed: reloadAbsensi,
                            ),
                          ],
                        ),
                      );
                    }

                    // State Success API
                    if (snapshot.hasData) {
                      return AbsensiInfocard(info: snapshot.data!);
                    }

                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 16),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Daftar Mahasiswa',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return StudentInfoCard(
                      nim: student.nim,
                      name: student.name,
                      major: student.major,
                      semester: student.semester,
                      email: student.email,
                      attendance: student.attendance,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
