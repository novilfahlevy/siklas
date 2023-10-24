import 'package:flutter/material.dart';

class Timepicker extends StatefulWidget {
  final String label;

  final TimeOfDay currentTime;

  final void Function(TimeOfDay selectedTime) onTimeSelected;
  
  bool isError;

  Timepicker({
    super.key,
    required this.label,
    required this.currentTime,
    required this.onTimeSelected,
    this.isError = false,
  });

  @override
  State<Timepicker> createState() => _TimepickerState();
}

class _TimepickerState extends State<Timepicker> {
  void _onSelectDate() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: widget.currentTime,
    );

    if (selectedTime != null) {
      widget.onTimeSelected(selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: widget.isError ? 1 : 0.5,
          color: widget.isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.outline
        ),
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
                    widget.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      letterSpacing: -0.41,
                      color: Theme.of(context).colorScheme.secondary
                    ), 
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    widget.currentTime.format(context),
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