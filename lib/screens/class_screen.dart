import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/screens/create_borrowing_screen.dart';
import 'package:siklas/screens/widgets/class_thumbnail.dart';
import 'package:siklas/view_models/borrowings_view_model.dart';
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
      context.read<ClassViewModel>().addListener(_isClassFetchedListener);
      context.read<ClassViewModel>().addListener(_showBorrowingsScreenListener);
    }

    super.initState();
  }

  /// Make sure if the schedules are fetched only once
  /// when the class screen has opened and the class data is already fetched.
  void _isClassFetchedListener() {
    if (mounted) {
      final classViewModel = Provider.of<ClassViewModel>(context, listen: false);

      if (classViewModel.isClassFetched) {
        final scheduleViewModel = Provider.of<ScheduleViewModel>(context, listen: false);
        scheduleViewModel.fetchSchedules(classViewModel.classModel!.id);

        classViewModel.isClassFetched = false;
      }
    }
  }

  /// Fetch the borrowings data when 'Peminjaman' tab is selected.
  /// Also make sure if the borrowings are fetched only once.
  void _showBorrowingsScreenListener() {
    if (mounted) {
      final classViewModel = Provider.of<ClassViewModel>(context, listen: false);
      final borrowingViewModel = Provider.of<BorrowingsViewModel>(context, listen: false);

      if (classViewModel.selectedScreenIndex == 1 && !borrowingViewModel.areBorrowingsFetched) {
        borrowingViewModel.fetchBorrowings(classViewModel.classModel!.id);
        borrowingViewModel.areBorrowingsFetched = true;
      }
    }
  }

  /// Fetch major options in the create borrowing view model,
  /// set the class model to the create borrowing view model,
  /// and then go to the create borrowing screen.
  void _goToCreateBorrowingScreen() {
    final createBorrowingViewModel = Provider.of<CreateBorrowingViewModel>(context, listen: false);
    final classViewModel = Provider.of<ClassViewModel>(context, listen: false);

    createBorrowingViewModel.fetchMajors();
    createBorrowingViewModel.currentClass = classViewModel.classModel;

    Navigator.pushNamed(context, CreateBorrowingScreen.routePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<ClassViewModel>(
        builder: (context, state, _) {
          // Display loading indicator while the class is being fetched.
          if (state.isFetchingClass) {
            return const Center(child: CircularProgressIndicator());
          }

          // Display a note if the class is not found
          if (state.classModel == null) {
            return const Center(child: Text('Kelas tidak ditemukan'));
          }

          return Column(
            children: [
              Container(
                color: Colors.white,
                child: Consumer<ClassViewModel>(
                  builder: (context, state, _) {
                    return ClassThumbnail(
                      classModel: state.classModel,
                      floorModel: state.floorModel
                    );
                  }
                )
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
              ),
              const SizedBox(height: 80,)
            ],
          );
        }
      ),
      floatingActionButton: Consumer<ClassViewModel>(
        builder: (context, state, _) {
          // Display nothing while the class is being fetched
          if (state.isFetchingClass) {
            return const SizedBox.shrink();
          }

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isFetchingClass ? null : _goToCreateBorrowingScreen,
              child: const Text('Pinjam kelas ini')
            )
          );
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}