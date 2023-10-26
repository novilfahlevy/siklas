import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/screens/widgets/class_thumbnail.dart';
import 'package:siklas/screens/widgets/tag.dart';
import 'package:siklas/view_models/borrowing_history_view_model.dart';

class BorrowingHistoryScreen extends StatefulWidget {
  static const String routePath = '/borrowing-history';

  const BorrowingHistoryScreen({super.key});

  @override
  State<BorrowingHistoryScreen> createState() => _BorrowingHistoryScreenState();
}

class _BorrowingHistoryScreenState extends State<BorrowingHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<BorrowingHistoryViewModel>(
        builder: (context, state, _) {
          if (state.isFetchingBorrowing) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.borrowingModel == null) {
            return const Center(child: Text('Peminjaman tidak ditemukan'));
          }

          return ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20,),
                    Text(
                      state.borrowingModel!.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
              ),
              ClassThumbnail(
                classModel: state.classModel,
                floorModel: state.floorModel
              ),
              const SizedBox(height: 10,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30,),
                    Text('Status', style: Theme.of(context).textTheme.titleSmall,),
                    const SizedBox(height: 10,),
                    Tag(
                      label: state.borrowingModel!.getStatus(),
                      backgroundColor: state.borrowingModel!.status == 0
                        ? Theme.of(context).colorScheme.secondary
                        : state.borrowingModel!.status == 1
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary,
                      textColor: Colors.white
                    ),
                    const SizedBox(height: 30,),
                    Text('Tanggal pengajuan', style: Theme.of(context).textTheme.titleSmall,),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Tag(
                          label: state.borrowingModel!.createdAtFormattedDate(),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          textColor: Colors.white
                        ),
                        const SizedBox(width: 10,),
                        Tag(
                          label: state.borrowingModel!.createdAtFormattedTime(),
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
                          label: state.borrowingModel!.dateFormatted(),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          textColor: Colors.white
                        ),
                        const SizedBox(width: 10,),
                        Tag(
                          label: '${state.borrowingModel!.timeFromFormatted(context)} - ${state.borrowingModel!.timeUntilFormatted(context)}',
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
                        label: state.majorModel!.name,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        textColor: Colors.white
                      ),
                    ),
                    const SizedBox(height: 30,),
                    Text('Keterangan', style: Theme.of(context).textTheme.titleSmall,),
                    const SizedBox(height: 10,),
                    Text(state.borrowingModel!.description, style: Theme.of(context).textTheme.bodyLarge,),
                    const SizedBox(height: 20,),
                  ],
                ),
              )
            ],
          );
        }
      ),
    );
  }
}