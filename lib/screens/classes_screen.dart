import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/models/floor_model.dart';
import 'package:siklas/screens/class_screen.dart';
import 'package:siklas/view_models/borrowings_view_model.dart';
import 'package:siklas/view_models/class_view_model.dart';
import 'package:siklas/view_models/classes_view_model.dart';
import 'package:siklas/view_models/main_view_model.dart';

class ClassesScreen extends StatefulWidget {
  static const String routePath = '/classes';

  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  @override
  void initState() {
    final MainViewModel mainViewModel = Provider.of<MainViewModel>(context, listen: false);

    if (!mainViewModel.isScreenEverChanged) {
      Provider.of<ClassesViewModel>(context, listen: false).fetchFloors();
    }

    super.initState();
  }

  void _goToClassScreen(String classId) {
    Provider.of<ClassViewModel>(context, listen: false).fetchClass(classId);
    Provider.of<BorrowingsViewModel>(context, listen: false).isBorrowingsFetched = false;

    Navigator.pushNamed(
      context,
      ClassScreen.routePath,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Column(
        children: [
          Consumer<ClassesViewModel>(
            builder: (context, state, _) {
              return DropdownSearch<FloorModel>(
                items: state.floors.toList(),
                itemAsString: (FloorModel floor) => floor.name,
                enabled: !state.isFetchingClasses,
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(labelText: 'Lantai'),
                ),
                onChanged: (FloorModel? floor) => state.selectedFloor = floor,
                selectedItem: state.firstFloor,
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
                        style: (state.selectedFloor != null ? state.selectedFloor!.name : '') == item.name
                          ? Theme.of(context).textTheme.titleSmall
                          : Theme.of(context).textTheme.bodyLarge
                      )
                    ),
                ),
              );
            }
          ),
          const SizedBox(height: 10,),
          Expanded(
            child: Consumer<ClassesViewModel>(
              builder: (context, state, _) {
                if (state.isFetchingClasses) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.classes.isEmpty) {
                  return Center(
                    child: Text(
                      'Tidak ada kelas yang tersedia',
                      style: Theme.of(context).textTheme.bodyLarge
                    )
                  );
                }
                
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: state.classes.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 20,),
                  itemBuilder: (context, index) =>
                    GestureDetector(
                      onTap: () => _goToClassScreen(state.classes[index].id),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://feb.unr.ac.id/wp-content/uploads/2023/03/650ed502-a5ba-4406-8011-d739652a1e9c-1536x864.jpg',
                                  fit: BoxFit.cover,
                                  height: 200,
                                  width: double.infinity,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.black26,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  state.classes[index].name,
                                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}