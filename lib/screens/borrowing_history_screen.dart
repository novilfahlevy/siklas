import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/screens/widgets/class_thumbnail.dart';
import 'package:siklas/screens/widgets/loading_circular.dart';
import 'package:siklas/screens/widgets/tag.dart';
import 'package:siklas/view_models/borrowing_histories_view_model.dart';
import 'package:siklas/view_models/borrowing_history_view_model.dart';
import 'package:siklas/view_models/login_view_model.dart';

class BorrowingHistoryScreen extends StatefulWidget {
  static const String routePath = '/borrowing-history';

  const BorrowingHistoryScreen({super.key});

  @override
  State<BorrowingHistoryScreen> createState() => _BorrowingHistoryScreenState();
}

class _BorrowingHistoryScreenState extends State<BorrowingHistoryScreen> {
  void _confirmCancelBorrowing() async {
    await showDialog(
      context: context,
      builder: (context) =>
        AlertDialog(
          title: Center(
            child: Text(
              'Konfirmasi pembatalan?',
              style: Theme.of(context).textTheme.bodyLarge
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tidak jadi', style: Theme.of(context).textTheme.bodyMedium,)
            ),
            TextButton(
              onPressed: () => _cancelBorrowing(),
              child: Text('Iya', style: Theme.of(context).textTheme.bodyMedium,)
            ),
          ],
        ),
    );
  }

  void _cancelBorrowing() {
    // Pop the alert dialog
    Navigator.pop(context);
    
    Provider
      .of<BorrowingHistoryViewModel>(context, listen: false)
      .cancelBorrowing()
      .then((value) {
        _showCancelBorrowingSuccessMessage();

        // Back to borrowing histories screen
        Navigator.pop(context);

        final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
        
        Provider
          .of<BorrowingHistoriesViewModel>(context, listen: false)
          .fetchBorrowingsByUserId(loginViewModel.userModel!.id);
      });
  }

  void _showCancelBorrowingSuccessMessage() {
    ScaffoldMessenger
      .of(context)
      .showSnackBar(const SnackBar(content: Text('Peminjaman berhasil dibatalkan.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<BorrowingHistoryViewModel>(
        builder: (context, state, _) {
          if (state.isFetchingBorrowing) {
            return Center(
              child: LoadingCircular(
                size: 30,
                color: Theme.of(context).colorScheme.primary
              )
            );
          }

          if (state.borrowingModel == null) {
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
                      state.borrowingModel!.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10,),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  child: ClassThumbnail(
                    classModel: state.classModel,
                    floorModel: state.floorModel
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
                        Text('Status', style: Theme.of(context).textTheme.titleSmall,),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Tag(
                              label: state.borrowingModel!.getStatus(),
                              backgroundColor: state.borrowingModel!.status == 0
                                ? Theme.of(context).colorScheme.secondary
                                : state.borrowingModel!.status == 1
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(context).colorScheme.primary,
                              textColor: Colors.white
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: Text(state.staffModel != null ? '(${state.staffModel!.name})' : '')
                            )
                          ],
                        ),
                        Visibility(
                          visible: state.borrowingModel!.status == 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30,),
                              Text('Keterangan penolakan', style: Theme.of(context).textTheme.titleSmall,),
                              const SizedBox(height: 10,),
                              Text(state.borrowingModel!.rejectedMessage!, style: Theme.of(context).textTheme.bodyLarge,),
                            ],
                          )
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
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80,),
            ],
          );
        }
      ),
      floatingActionButton: Consumer<BorrowingHistoryViewModel>(
        builder: (context, state, _) {
          // Display nothing while borrowings are being fetched
          // and when the borrowing has been responded (the status is not 0)
          if (state.isFetchingBorrowing || state.borrowingModel!.status != 0) {
            return const SizedBox.shrink();
          }

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                disabledBackgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: state.isFetchingBorrowing ? null : _confirmCancelBorrowing,
              child: state.isDeletingBorrowing
                ? const LoadingCircular()
                : const Text('Batalkan peminjaman')
            ),
          );
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}