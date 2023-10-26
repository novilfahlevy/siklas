import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/screens/widgets/class_thumbnail.dart';
import 'package:siklas/screens/widgets/tag.dart';
import 'package:siklas/view_models/class_view_model.dart';
import 'package:siklas/view_models/borrowing_view_model.dart';

class BorrowingScreen extends StatefulWidget {
  static const String routePath = '/borrowing';

  const BorrowingScreen({super.key});

  @override
  State<BorrowingScreen> createState() => _BorrowingScreenState();
}

class _BorrowingScreenState extends State<BorrowingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<BorrowingViewModel>(
        builder: (context, state, _) {
          if (state.isFetchingBorrowing) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.borrowing == null) {
            return const Center(child: Text('Peminjaman tidak ditemukan'));
          }

          return ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20,),
                    Text(
                      state.borrowing!.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10,),
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  child: Consumer<ClassViewModel>(
                    builder: (context, state, _) {
                      return ClassThumbnail(
                        classModel: state.classModel,
                        floorModel: state.floorModel
                      );
                    }
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tanggal pengajuan', style: Theme.of(context).textTheme.titleSmall,),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Tag(
                              label: state.borrowing!.createdAtFormattedDate(),
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              textColor: Colors.white
                            ),
                            const SizedBox(width: 10,),
                            Tag(
                              label: state.borrowing!.createdAtFormattedTime(),
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              textColor: Colors.white
                            ),
                          ],
                        ),
                        const SizedBox(height: 30,),
                        Text('Tanggal dan waktu', style: Theme.of(context).textTheme.titleSmall,),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Tag(
                              label: state.borrowing!.dateFormatted(),
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              textColor: Colors.white
                            ),
                            const SizedBox(width: 10,),
                            Tag(
                              label: '${state.borrowing!.timeFromFormatted(context)} - ${state.borrowing!.timeUntilFormatted(context)}',
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              textColor: Colors.white
                            ),
                          ],
                        ),
                        const SizedBox(height: 30,),
                        Text('Program studi', style: Theme.of(context).textTheme.titleSmall,),
                        const SizedBox(height: 10,),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Tag(
                            label: state.major!.name,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            textColor: Colors.white
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Text('Keterangan', style: Theme.of(context).textTheme.titleSmall,),
                        const SizedBox(height: 10,),
                        Text(state.borrowing!.description, style: Theme.of(context).textTheme.bodyLarge,),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
            ],
          );
        }
      ),
    );
  }
}