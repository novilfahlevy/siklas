import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/screens/widgets/tag.dart';
import 'package:siklas/view_models/class_view_model.dart';
import 'package:siklas/view_models/detail_borrowing_view_model.dart';

class DetailBorrowingScreen extends StatefulWidget {
  static const String routePath = '/borrowing';

  const DetailBorrowingScreen({super.key});

  @override
  State<DetailBorrowingScreen> createState() => _DetailBorrowingScreenState();
}

class _DetailBorrowingScreenState extends State<DetailBorrowingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<DetailBorrowingViewModel>(
        builder: (context, state, _) {
          if (state.isFetchingBorrowing) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.borrowing == null) {
            return const Center(child: Text('Peminjaman tidak ditemukan'));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(height: 20,),
                Text(
                  state.borrowing!.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 30,),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://feb.unr.ac.id/wp-content/uploads/2023/03/650ed502-a5ba-4406-8011-d739652a1e9c-1536x864.jpg',
                        width: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer<ClassViewModel>(
                            builder: (context, state, _) {
                              if (state.classModel != null) {
                                return Text(
                                  state.classModel!.name,
                                  style: Theme.of(context).textTheme.titleSmall,
                                  overflow: TextOverflow.ellipsis,
                                );
                              }

                              return const Text('-');
                            }
                          ),
                          Consumer<ClassViewModel>(
                            builder: (context, state, _) {
                              if (state.floorModel != null) {
                                return Text(
                                  state.floorModel!.name,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                );
                              }

                              return const Text('-');
                            }
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30,),
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
                const SizedBox(height: 20,),
              ],
            ),
          );
        }
      ),
    );
  }
}