import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class WorkingHoursWidget extends StatefulWidget {
  final bool isEnabled;
  final Function(List<WorkingHour>) onChanged;
  final List<WorkingHour>? workingHours;

  const WorkingHoursWidget({
    Key? key,
    required this.isEnabled,
    required this.onChanged,
    this.workingHours,
  }) : super(key: key);

  @override
  State<WorkingHoursWidget> createState() => _WorkingHoursWidgetState();
}

class _WorkingHoursWidgetState extends State<WorkingHoursWidget> {
  late List<WorkingHour> hours;

  @override
  void initState() {
    super.initState();
    hours = widget.workingHours ??
        [
          WorkingHour(day: 'Monday'),
          WorkingHour(day: 'Tuesday'),
          WorkingHour(day: 'Wednesday'),
          WorkingHour(day: 'Thursday'),
          WorkingHour(day: 'Friday'),
          WorkingHour(day: 'Saturday'),
          WorkingHour(day: 'Sunday'),
        ];
  }

  void _updateHour(int index, WorkingHour updatedHour) {
    setState(() {
      hours[index] = updatedHour;
    });
    widget.onChanged(hours);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: hours.map((hour) {
        final index = hours.indexOf(hour);
        return Card(
          margin: EdgeInsets.symmetric(vertical: tinyPadding),
          child: Padding(
            padding: EdgeInsets.all(normalPadding),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    hour.day,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                SizedBox(width: normalPadding),
                Switch(
                  value: hour.isOpen,
                  onChanged: widget.isEnabled
                      ? (value) {
                          _updateHour(
                            index,
                            WorkingHour(
                              day: hour.day,
                              openTime: hour.openTime,
                              closeTime: hour.closeTime,
                              isOpen: value,
                            ),
                          );
                        }
                      : null,
                ),
                if (hour.isOpen) ...[
                  SizedBox(width: normalPadding),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            enabled: widget.isEnabled,
                            initialValue: hour.openTime,
                            decoration: const InputDecoration(
                              labelText: 'Open Time',
                              hintText: '09:00',
                            ),
                            onChanged: (value) {
                              _updateHour(
                                index,
                                WorkingHour(
                                  day: hour.day,
                                  openTime: value,
                                  closeTime: hour.closeTime,
                                  isOpen: hour.isOpen,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: normalPadding),
                        Expanded(
                          child: TextFormField(
                            enabled: widget.isEnabled,
                            initialValue: hour.closeTime,
                            decoration: const InputDecoration(
                              labelText: 'Close Time',
                              hintText: '17:00',
                            ),
                            onChanged: (value) {
                              _updateHour(
                                index,
                                WorkingHour(
                                  day: hour.day,
                                  openTime: hour.openTime,
                                  closeTime: value,
                                  isOpen: hour.isOpen,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
