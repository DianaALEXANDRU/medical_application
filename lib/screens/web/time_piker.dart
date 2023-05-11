import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePicker24H extends StatefulWidget {
  final Function(DateTime) onTimeSelected;
  final String? title;
  final DateTime? initialTime;

  const TimePicker24H({
    required this.onTimeSelected,
    this.title,
    this.initialTime,
  });

  @override
  _TimePicker24HState createState() => _TimePicker24HState();
}

class _TimePicker24HState extends State<TimePicker24H> {
  late DateTime _time;

  @override
  void initState() {
    super.initState();
    _time = widget.initialTime ?? DateTime.now();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _time.hour, minute: _time.minute),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final newTime = DateTime(
          _time.year, _time.month, _time.day, picked.hour, picked.minute);
      setState(() {
        _time = newTime;
      });
      widget.onTimeSelected(newTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.title ?? "Time",
              style: const TextStyle(fontSize: 16.0),
            ),
            Text(
              DateFormat.Hm().format(_time),
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
