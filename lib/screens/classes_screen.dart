import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/models/floor_model.dart';
import 'package:siklas/screens/class_screen.dart';
import 'package:siklas/screens/widgets/loading_circular.dart';
import 'package:siklas/view_models/borrowings_view_model.dart';
import 'package:siklas/view_models/class_view_model.dart';
import 'package:siklas/view_models/classes_view_model.dart';

class ClassesScreen extends StatefulWidget {
  static const String routePath = '/classes';

  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  @override
  void initState() {
    Provider.of<ClassesViewModel>(context, listen: false).fetchFloors();

    super.initState();
  }

  void _goToClassScreen(String classId) {
    Provider.of<ClassViewModel>(context, listen: false).fetchClass(classId);
    Provider.of<BorrowingsViewModel>(context, listen: false).isBorrowingsFetched = false;

    Navigator.pushNamed(context, ClassScreen.routePath);
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
                
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.classes.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _goToClassScreen(state.classes[index].id),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: FutureBuilder(
                                  future: state.classes[index].getImagePath(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Image.network(
                                        snapshot.data!,
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width: double.infinity,
                                        loadingBuilder: (context, child, loadingProgress) =>
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: LoadingCircular(
                                              size: 50,
                                              color: Theme.of(context).colorScheme.primary,
                                            )
                                          ),
                                      );
                                    }

                                    return const SizedBox(width: double.infinity, height: 200);
                                  },
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
                        )
                      ),
                    );
                  }
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}