import 'package:flutter/material.dart';
import 'package:siklas/screens/widgets/tag.dart';

class ClassScreen extends StatefulWidget {
  static const String routePath = '/class';

  const ClassScreen({super.key});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: ListView(
          children: [
            Image.network(
              'https://feb.unr.ac.id/wp-content/uploads/2023/03/650ed502-a5ba-4406-8011-d739652a1e9c-1536x864.jpg',
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Kelas C101',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const Divider(height: 40,),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RegularScheduleTitle(),
                  SizedBox(height: 20,),
                  RegularSchedule(),
                  SizedBox(height: 20,),
                  RegularSchedule(),
                  SizedBox(height: 20,),
                  BorrowingTitle(),
                  SizedBox(height: 20,),
                  Borrowing(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('Pinjam kelas ini')
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class RegularScheduleTitle extends StatelessWidget {
  const RegularScheduleTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Jadwal rutin',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(width: 8,),
        Tooltip(
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          message: 'Jadwal rutin dari kelas ini. Kelas tidak dapat dipinjam pada saat jadwal-jadwal berikut.',
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(100)
            ),
            child: const Icon(
              Icons.question_mark,
              color: Colors.white,
              size: 14,
            ),
          ),
        )
      ],
    );
  }
}

class RegularSchedule extends StatelessWidget {
  const RegularSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      title: Text('Mata Kuliah Manajemen Proyek prodi Sistem Informasi Akt 21'),
      subtitle: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Tag(label: 'Rabu', backgroundColor: Colors.purple, textColor: Colors.white),
            SizedBox(width: 10,),
            Tag(label: '07:30 - 09:00', backgroundColor: Colors.purple, textColor: Colors.white),
          ],
        ),
      ),
    );
  }
}

class BorrowingTitle extends StatelessWidget {
  const BorrowingTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Peminjaman',
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}

class Borrowing extends StatelessWidget {
  const Borrowing({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      title: Text('Sosialisasi Persiapan Praktikum PBO prodi Sistem Informasi'),
      subtitle: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Tag(label: '17 Oktober 2023', backgroundColor: Colors.purple, textColor: Colors.white),
            SizedBox(width: 10,),
            Tag(label: '09:30 - 11:30', backgroundColor: Colors.purple, textColor: Colors.white),
          ],
        ),
      ),
    );
  }
}