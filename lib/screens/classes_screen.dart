import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/models/class_model.dart';
import 'package:siklas/models/floor_model.dart';
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
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(labelText: 'Lantai'),
                ),
                onChanged: (FloorModel? floor) => state.selectedFloor = floor,
                selectedItem: state.firstFloor,
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

                if (state.classes.isNotEmpty) {
                    return ListView(
                      shrinkWrap: true,
                      children: state.classes.map((ClassModel c) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                            child: Column(
                              children: <Widget>[
                                Image.network(
                                  'https://feb.unr.ac.id/wp-content/uploads/2023/03/650ed502-a5ba-4406-8011-d739652a1e9c-1536x864.jpg',
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                                ListTile(title: Text(c.name)),
                              ],
                            ),
                          ),
                        );
                      })
                      .toList()
                    );
                  }

                  return const Center(child: Text('Tidak ada kelas yang tersedia'));
              }
            ),
          ),
        ],
      ),
    );
  }
}