import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/screens/borrowing_history_screen.dart';
import 'package:siklas/screens/widgets/tag.dart';
import 'package:siklas/view_models/borrowing_history_view_model.dart';
import 'package:siklas/view_models/borrowing_histories_view_model.dart';

class BorrowingHistoriesScreen extends StatefulWidget {
  static const String routePath = '/borrowings';

  const BorrowingHistoriesScreen({super.key});

  @override
  State<BorrowingHistoriesScreen> createState() => _BorrowingHistoriesScreenState();
}

class _BorrowingHistoriesScreenState extends State<BorrowingHistoriesScreen> {
  void _goToDetailBorrowingScreen(String borrowingId) {
    Provider
      .of<BorrowingHistoryViewModel>(context, listen: false)
      .fetchBorrowingById(borrowingId);

    Navigator.pushNamed(context, BorrowingHistoryScreen.routePath);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Consumer<BorrowingHistoriesViewModel>(
        builder: (context, state, _) {
          if (state.isFetchingBorrowings) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.borrowings.isEmpty) {
            return Center(
              child: Text(
                'Tidak ada peminjaman',
                style: Theme.of(context).textTheme.bodyLarge
              )
            );
          }

          return ListView.builder(
            itemCount: state.borrowings.length,
            itemBuilder: (context, index) =>
              Padding(
                padding: EdgeInsets.only(top: index == 0 ? 8 : 0),
                child: GestureDetector(
                  onTap: () => _goToDetailBorrowingScreen(state.borrowings[index].id),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(state.borrowings[index].title,),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Row(
                              children: [
                                Tag(
                                  label: state.borrowings[index].dateFormatted(),
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                  textColor: Colors.white
                                ),
                                const SizedBox(width: 10,),
                                Tag(
                                  label: '${state.borrowings[index].timeFromFormatted(context)} - ${state.borrowings[index].timeUntilFormatted(context)}',
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                  textColor: Colors.white
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          );
        }
      )
    );
  }
}