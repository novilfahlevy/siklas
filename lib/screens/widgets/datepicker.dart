import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Datepicker extends StatefulWidget {
  DateTime currentDate = DateTime.now();
  final void Function(DateTime selectedDate) onDateSelected;

  Datepicker({
    super.key,
    required this.currentDate,
    required this.onDateSelected
  });

  @override
  State<Datepicker> createState() => _DatepickerState();
}

class _DatepickerState extends State<Datepicker> {
  void _onSelectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5)
    );

    if (selectedDate != null) {
      widget.onDateSelected(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.5, color: Theme.of(context).colorScheme.outline),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tanggal',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      letterSpacing: -0.41,
                      color: Theme.of(context).colorScheme.secondary
                    ), 
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    DateFormat('d MMMM y').format(widget.currentDate),
                    style: Theme.of(context).textTheme.bodySmall
                  )
                ],
              ),
              TextButton(
                onPressed: _onSelectDate,
                child: Text('Pilih', style: Theme.of(context).textTheme.labelMedium,)
              )
            ],
          )
        ],
      ),
    );
  }
}