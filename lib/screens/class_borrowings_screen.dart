import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/screens/widgets/tag.dart';
import 'package:siklas/view_models/borrowing_view_model.dart';

class ClassBorrowingsScreen extends StatefulWidget {
  const ClassBorrowingsScreen({super.key});

  @override
  State<ClassBorrowingsScreen> createState() => _ClassBorrowingsScreenState();
}

class _ClassBorrowingsScreenState extends State<ClassBorrowingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8,),
      child: Consumer<BorrowingViewModel>(
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
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(state.borrowings[index].title),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Row(
                              children: [
                                Tag(
                                  label: state.borrowings[index].date,
                                  backgroundColor: Theme.of(context).colorScheme.secondary, textColor: Colors.white
                                ),
                                const SizedBox(width: 10,),
                                Tag(
                                  label: '${state.borrowings[index].timeFrom} - ${state.borrowings[index].timeUntil}',
                                  backgroundColor: Theme.of(context).colorScheme.secondary, textColor: Colors.white
                                ),
                              ],
                            ),
                          ),
                        ],
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