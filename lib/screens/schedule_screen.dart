import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/screens/widgets/tag.dart';
import 'package:siklas/view_models/schedule_view_model.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8,),
      child: Consumer<ScheduleViewModel>(
        builder: (context, state, _) {
          if (state.isFetchingSchedules) {
            return const Center(
              child: CircularProgressIndicator(
                strokeAlign: 3.0,
                strokeWidth: 3.0,
              )
            );
          }

          if (state.schedules.isEmpty) {
            return const Center(child: Text('Tidak ada jadwal di kelas ini'));
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
                          Text(state.schedules[index].title),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Row(
                              children: [
                                Tag(
                                  label: state.schedules[index].day,
                                  backgroundColor: Theme.of(context).colorScheme.secondary, textColor: Colors.white
                                ),
                                const SizedBox(width: 10,),
                                Tag(
                                  label: '${state.schedules[index].timeFrom} - ${state.schedules[index].timeUntil}',
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
              itemCount: state.schedules.length
            );
        }
      ),
    );
  }
}