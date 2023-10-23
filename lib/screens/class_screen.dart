import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/view_models/class_borrowing_view_model.dart';
import 'package:siklas/view_models/class_view_model.dart';
import 'package:siklas/view_models/create_borrowing_view_model.dart';
import 'package:siklas/view_models/schedule_view_model.dart';

class ClassScreen extends StatefulWidget {
  static const String routePath = '/class';

  const ClassScreen({super.key});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  @override
  void initState() {
    if (mounted) {
      context.read<ClassViewModel>().addListener(_classFetchedStatusListener);
      context.read<ClassViewModel>().addListener(_showBorrowingsScreenListener);
    }

    super.initState();
  }

  void _classFetchedStatusListener() {
    if (mounted) {
      final classViewModel = Provider.of<ClassViewModel>(context, listen: false);

      if (classViewModel.isClassFetched) {
        final scheduleViewModel = Provider.of<ScheduleViewModel>(context, listen: false);
        scheduleViewModel.fetchSchedules(classViewModel.classModel!.id);

        classViewModel.isClassFetched = false;
      }
    }
  }

  void _showBorrowingsScreenListener() {
    if (mounted) {
      final classViewModel = Provider.of<ClassViewModel>(context, listen: false);
      final borrowingViewModel = Provider.of<ClassBorrowingViewModel>(context, listen: false);

      if (classViewModel.selectedScreenIndex == 1 && !borrowingViewModel.isBorrowingsFetched) {
        borrowingViewModel.fetchBorrowings(classViewModel.classModel!.id);
        borrowingViewModel.isBorrowingsFetched = true;
      }
    }
  }

  void _goToCreateBorrowingPage() {
    final createBorrowingViewModel = Provider.of<CreateBorrowingViewModel>(context, listen: false);
    final classViewModel = Provider.of<ClassViewModel>(context, listen: false);

    createBorrowingViewModel.fetchMajors();
    createBorrowingViewModel.currentClass = classViewModel.classModel;

    Navigator.pushNamed(context, '/create-borrowing');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<ClassViewModel>(
        builder: (context, state, _) {
          if (state.isFetchingClass) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  color: Colors.white,
                  child: Row(
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
                ),
                Consumer<ClassViewModel>(
                  builder: (context, state, _) {
                    return Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => state.selectedScreenIndex = 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  top: BorderSide(
                                    width: 0.5,
                                    color: Theme.of(context).colorScheme.outline
                                  ),
                                  bottom: state.selectedScreenIndex == 0
                                    ? BorderSide(
                                        color: Theme.of(context).colorScheme.primary,
                                        width: 2
                                      )
                                    : BorderSide(
                                        width: 0.5,
                                        color: Theme.of(context).colorScheme.outline
                                      )
                                )
                              ),
                              child: const Center(child: Text('Jadwal'))
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => state.selectedScreenIndex = 1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                              color: Colors.white,
                                border: Border(
                                  top: BorderSide(
                                    width: 0.5,
                                    color: Theme.of(context).colorScheme.outline
                                  ),
                                  bottom: state.selectedScreenIndex == 1
                                    ? BorderSide(
                                        color: Theme.of(context).colorScheme.primary,
                                        width: 2
                                      )
                                    : BorderSide(
                                        width: 0.5,
                                        color: Theme.of(context).colorScheme.outline
                                      )
                                )
                              ),
                              child: const Center(child: Text('Peminjaman'))
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                ),
                Expanded(
                  child: Consumer<ClassViewModel>(
                    builder: (context, state, _) => state.currentScreen,
                  ),
                )
              ],
            ),
          );
        }
      ),
      floatingActionButton: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: Consumer<ClassViewModel>(
          builder: (context, state, _) {
            return ElevatedButton(
              onPressed: state.isFetchingClass ? null : _goToCreateBorrowingPage,
              child: const Text('Pinjam kelas ini')
            );
          }
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}