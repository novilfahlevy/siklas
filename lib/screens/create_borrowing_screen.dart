import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/models/borrowing_model.dart';
import 'package:siklas/models/major_model.dart';
import 'package:siklas/screens/borrowing_screen.dart';
import 'package:siklas/screens/main_screen.dart';
import 'package:siklas/screens/widgets/loading_circular.dart';
import 'package:siklas/screens/widgets/timepicker.dart';
import 'package:siklas/view_models/borrowing_view_model.dart';
import 'package:siklas/view_models/class_view_model.dart';
import 'package:siklas/screens/widgets/datepicker.dart';
import 'package:siklas/view_models/create_borrowing_view_model.dart';
import 'package:siklas/view_models/main_view_model.dart';

class CreateBorrowingScreen extends StatefulWidget {
  static const String routePath = '/create-borrowing';

  const CreateBorrowingScreen({super.key});

  @override
  State<CreateBorrowingScreen> createState() => _CreateBorrowingScreenState();
}

class _CreateBorrowingScreenState extends State<CreateBorrowingScreen> {
  @override
  void initState() {
    if (mounted) {
      context.read<CreateBorrowingViewModel>().addListener(_borrowingTimeHasBookedListener);
      context.read<CreateBorrowingViewModel>().addListener(_borrowingCreatedListener);
    }

    super.initState();
  }

  void _borrowingTimeHasBookedListener() {
    if (mounted) {
      final createBorrowingViewModel = Provider.of<CreateBorrowingViewModel>(context, listen: false);
      dynamic schduleOrBookedBorrowing = createBorrowingViewModel.sameTimeScheduleOrBookedBorrowing;

      if (createBorrowingViewModel.sameTimeScheduleOrBookedBorrowing != false) {
        bool isItBorrowing = schduleOrBookedBorrowing is BorrowingModel;

        ScaffoldMessenger
          .of(context)
          .showSnackBar(SnackBar(
            content: GestureDetector(
              onTap: () => isItBorrowing ? _goToBorrowingScreen(schduleOrBookedBorrowing.id) : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isItBorrowing
                      ? 'Mohon maaf, kelas sudah dipinjam pada waktu tersebut.'
                      : 'Mohon maaf, terdapat jadwal rutin pada waktu tersebut.'
                  ),
                  Visibility(
                    visible: isItBorrowing,
                    child: const SizedBox(height: 5,)
                  ),
                  Visibility(
                    visible: isItBorrowing,
                    child: const Text('Tekan untuk lihat peminjaman.', style: TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    )),
                  ),
                ],
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.error
          ));
      }
    }
  }

  void _goToBorrowingScreen(String borrowingId) {
    Provider
      .of<BorrowingViewModel>(context, listen: false)
      .fetchBorrowingById(borrowingId);

    Navigator.pushNamed(context, BorrowingScreen.routePath);
  }

  /// Show the success message if the borrowing has been created,
  /// and then go to the main screen, specificly to the borrowing histories screen.
  void _borrowingCreatedListener() {
    if (mounted) {
      final createBorrowingViewModel = Provider.of<CreateBorrowingViewModel>(context, listen: false);
      final mainViewModel = Provider.of<MainViewModel>(context, listen: false);

      if (createBorrowingViewModel.isBorrowingCreated) {
        ScaffoldMessenger
          .of(context)
          .showSnackBar(const SnackBar(content: Text('Peminjaman berhasil dibuat.')));

        mainViewModel.selectedScreenIndex = 1;

        Navigator.popUntil(context, ModalRoute.withName(MainScreen.routePath));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ClassViewModel>(
          builder: (context, state, _) {
            // Display empty text if the class is not found
            if (state.classModel == null) {
              return const Text('');
            }

            return Text(
              'Pinjam kelas ${state.classModel!.name}',
              style: Theme.of(context).textTheme.titleMedium,
            );
          }
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<CreateBorrowingViewModel>(
          builder: (context, state, _) {
            return Form(
              key: state.formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: state.titleController,
                    decoration: const InputDecoration(
                      labelText: 'Nama kegiatan',
                    ),
                    validator: state.validateName,
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: state.descriptionController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      labelText: 'Keterangan kegiatan',
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                    validator: state.validateDescription,
                  ),
                  const SizedBox(height: 20,),
                  DropdownSearch<MajorModel>(
                    items: state.majors.toList(),
                    itemAsString: (MajorModel major) => major.name,
                    enabled: !state.isFetchingMajors,
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(labelText: 'Program studi'),
                    ),
                    onChanged: (MajorModel? major) => state.selectedMajor = major,
                    selectedItem: state.firstMajor,
                    dropdownBuilder: (context, selectedItem) =>
                      Text(
                        selectedItem != null ? selectedItem.name : '',
                        style: Theme.of(context).textTheme.bodyLarge
                      ),
                    popupProps: PopupProps.dialog(
                      containerBuilder: (context, popupWidget) =>
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          padding: const EdgeInsets.all(10),
                          child: popupWidget,
                        ),
                      itemBuilder: (context, item, isSelected) =>
                        ListTile(
                          title: Text(
                            item.name,
                            style: (state.selectedMajor != null ? state.selectedMajor!.name : '') == item.name
                              ? Theme.of(context).textTheme.titleSmall
                              : Theme.of(context).textTheme.bodyLarge
                          )
                        ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Datepicker(
                    currentDate: state.date,
                    onDateSelected: (selectedDate) => state.date = selectedDate
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(
                        child: Timepicker(
                          label: 'Mulai',
                          currentTime: state.timeFrom, 
                          onTimeSelected: (selectedTime) => state.timeFrom = selectedTime,
                          isError: !state.isTimeValid,
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Timepicker(
                          label: 'Sampai',
                          currentTime: state.timeUntil, 
                          onTimeSelected: (selectedTime) => state.timeUntil = selectedTime,
                          isError: !state.isTimeValid,
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: !state.isTimeValid,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8,),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Waktu tidak valid',
                            style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Theme.of(context).colorScheme.error),
                          )
                        ),
                      ],
                    )
                  ),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: state.isSubmittingBorrowing ? null : state.submitBorrowing,
                    child: state.isSubmittingBorrowing
                      ? const LoadingCircular()
                      : const Text('Ajukan peminjaman')
                  ),
                  const SizedBox(height: 20,),
                ],
              )
            );
          }
        ),
      )
    );
  }
}