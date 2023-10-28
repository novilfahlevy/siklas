import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/screens/borrowing_screen.dart';
import 'package:siklas/screens/widgets/tag.dart';
import 'package:siklas/view_models/borrowings_view_model.dart';
import 'package:siklas/view_models/borrowing_view_model.dart';

class BorrowingsScreen extends StatefulWidget {
  const BorrowingsScreen({super.key});

  @override
  State<BorrowingsScreen> createState() => _BorrowingsScreenState();
}

class _BorrowingsScreenState extends State<BorrowingsScreen> {
  void _goToBorrowingScreen(String borrowingId) {
    Provider
      .of<BorrowingViewModel>(context, listen: false)
      .fetchBorrowingById(borrowingId);

    Navigator.pushNamed(context, BorrowingScreen.routePath);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8,),
      child: Consumer<BorrowingsViewModel>(
        builder: (context, state, _) {
          if (state.isFetchingBorrowings) {
            return const Center(
              child: CircularProgressIndicator(
                strokeAlign: 3.0,
                strokeWidth: 3.0,
              )
            );
          }

          if (state.borrowings.isEmpty) {
            return const Center(child: Text('Tidak ada peminjaman di kelas ini'));
          }

          return ListView.builder(
            itemBuilder: (context, index) =>
              Padding(
                padding: EdgeInsets.only(top: index == 0 ? 8 : 0),
                child: GestureDetector(
                  onTap: () => _goToBorrowingScreen(state.borrowings[index].id),
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
            itemCount: state.borrowings.length
          );
        }
      ),
    );
  }
}