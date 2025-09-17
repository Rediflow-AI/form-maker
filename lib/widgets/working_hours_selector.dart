import 'package:flutter/material.dart';
import '../models/user.dart';

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
    hours =
        widget.workingHours ??
        [
          WorkingHour(day: 'Monday', isOpen: false),
          WorkingHour(day: 'Tuesday', isOpen: false),
          WorkingHour(day: 'Wednesday', isOpen: false),
          WorkingHour(day: 'Thursday', isOpen: false),
          WorkingHour(day: 'Friday', isOpen: false),
          WorkingHour(day: 'Saturday', isOpen: false),
          WorkingHour(day: 'Sunday', isOpen: false),
        ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Working Hours',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      hours.isEmpty || hours.every((h) => !h.isOpen)
                          ? 'No working hours set'
                          : 'Total: ${_calculateTotalHours()}h/week',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: widget.isEnabled
                    ? () => _showWorkingHoursDialog(context)
                    : null,
                icon: Icon(Icons.edit, size: 16),
                label: Text('Modify'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
          if (hours.isNotEmpty) ...[
            SizedBox(height: 12.0),
            Column(
              children: hours.map((hour) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          hour.day.substring(0, 3),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          hour.isOpen ? _formatTimeDisplay(hour) : 'Closed',
                          style: TextStyle(
                            color: hour.isOpen ? Colors.black87 : Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTimeDisplay(WorkingHour hour) {
    // If openTime contains time ranges (like "09:00-12:00, 14:00-17:00")
    if (hour.openTime.contains(', ')) {
      return hour.openTime; // Already properly formatted
    } else if (hour.openTime.contains('-')) {
      return hour.openTime; // Single range, already formatted
    } else {
      // Fallback to old format
      return '${hour.openTime} - ${hour.closeTime}';
    }
  }

  int _calculateTotalHours() {
    int totalHours = 0;
    for (var hour in hours) {
      if (hour.isOpen) {
        try {
          // Parse time ranges (could be multiple ranges like "09:00-12:00, 14:00-17:00")
          String timeRangesString = hour.openTime;
          if (timeRangesString.contains(', ')) {
            // Multiple time ranges
            List<String> ranges = timeRangesString.split(', ');
            for (String range in ranges) {
              if (range.contains('-')) {
                List<String> times = range.split('-');
                if (times.length == 2) {
                  int startHour = int.parse(times[0].split(':')[0]);
                  int endHour = int.parse(times[1].split(':')[0]);
                  totalHours += (endHour - startHour);
                }
              }
            }
          } else if (timeRangesString.contains('-')) {
            // Single time range
            List<String> times = timeRangesString.split('-');
            if (times.length == 2) {
              int startHour = int.parse(times[0].split(':')[0]);
              int endHour = int.parse(times[1].split(':')[0]);
              totalHours += (endHour - startHour);
            }
          } else {
            // Fallback to old format
            int openHour = int.parse(hour.openTime.split(':')[0]);
            int closeHour = int.parse(hour.closeTime.split(':')[0]);
            totalHours += (closeHour - openHour);
          }
        } catch (e) {
          // Default calculation if parsing fails
          totalHours += 8; // Default 8 hours
        }
      }
    }
    return totalHours;
  }

  void _showWorkingHoursDialog(BuildContext context) {
    print('Opening working hours dialog with ${hours.length} hours');

    // Create a list of selected time slots for each day
    Map<String, Set<int>> selectedSlots = {};
    for (var hour in hours) {
      selectedSlots[hour.day] = <int>{};
      if (hour.isOpen) {
        // Parse time ranges (could be multiple ranges like "09:00-12:00, 14:00-17:00")
        String timeRangesString = hour.openTime;
        if (timeRangesString.contains(', ')) {
          // Multiple time ranges
          List<String> ranges = timeRangesString.split(', ');
          for (String range in ranges) {
            if (range.contains('-')) {
              List<String> times = range.split('-');
              if (times.length == 2) {
                int startHour = _timeStringToHour(times[0]);
                int endHour = _timeStringToHour(times[1]);
                for (int i = startHour; i < endHour; i++) {
                  selectedSlots[hour.day]!.add(i);
                }
              }
            }
          }
        } else if (timeRangesString.contains('-')) {
          // Single time range
          List<String> times = timeRangesString.split('-');
          if (times.length == 2) {
            int startHour = _timeStringToHour(times[0]);
            int endHour = _timeStringToHour(times[1]);
            for (int i = startHour; i < endHour; i++) {
              selectedSlots[hour.day]!.add(i);
            }
          }
        } else {
          // Fallback to old format
          int startHour = _timeStringToHour(hour.openTime);
          int endHour = _timeStringToHour(hour.closeTime);
          for (int i = startHour; i < endHour; i++) {
            selectedSlots[hour.day]!.add(i);
          }
        }
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.access_time, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Working Hours'),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 500,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: _buildTimeGrid(selectedSlots, setDialogState),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _saveSelectedSlots(selectedSlots);
                    widget.onChanged(hours);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTimeGrid(
    Map<String, Set<int>> selectedSlots,
    StateSetter setDialogState,
  ) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final timeSlots = List.generate(24, (index) => index); // 0-23 hours

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // Header row with time slots
          Row(
            children: [
              // Empty corner cell
              Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: Text(
                    'Day / Time',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                ),
              ),
              // Time slot headers
              ...timeSlots.map((hour) {
                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Center(
                    child: Text(
                      '${hour.toString().padLeft(2, '0')}:00',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
          // Day rows
          ...days.map((day) {
            return Row(
              children: [
                // Day label
                Container(
                  width: 100,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                // Time slot cells
                ...timeSlots.map((hour) {
                  bool isSelected = selectedSlots[day]?.contains(hour) ?? false;
                  return GestureDetector(
                    onTap: () {
                      setDialogState(() {
                        if (selectedSlots[day] == null) {
                          selectedSlots[day] = <int>{};
                        }
                        if (isSelected) {
                          selectedSlots[day]!.remove(hour);
                        } else {
                          selectedSlots[day]!.add(hour);
                        }
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 35,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade200 : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? Colors.blue.shade400
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: isSelected
                          ? Center(
                              child: Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.blue.shade700,
                              ),
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  int _timeStringToHour(String timeString) {
    try {
      return int.parse(timeString.split(':')[0]);
    } catch (e) {
      return 9; // Default to 9 AM
    }
  }

  String _hourToTimeString(int hour) {
    return '${hour.toString().padLeft(2, '0')}:00';
  }

  void _saveSelectedSlots(Map<String, Set<int>> selectedSlots) {
    List<WorkingHour> newHours = [];

    for (var day in [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ]) {
      Set<int> slots = selectedSlots[day] ?? <int>{};

      if (slots.isEmpty) {
        // Day is closed
        newHours.add(WorkingHour(day: day, isOpen: false));
      } else {
        // Find continuous time blocks
        List<int> sortedSlots = slots.toList()..sort();
        List<String> timeRanges = [];

        int start = sortedSlots.first;
        int end = sortedSlots.first;

        for (int i = 1; i < sortedSlots.length; i++) {
          if (sortedSlots[i] == end + 1) {
            // Continuous slot
            end = sortedSlots[i];
          } else {
            // Gap found, save the current range
            timeRanges.add(
              '${_hourToTimeString(start)}-${_hourToTimeString(end + 1)}',
            );
            start = sortedSlots[i];
            end = sortedSlots[i];
          }
        }
        // Add the last range
        timeRanges.add(
          '${_hourToTimeString(start)}-${_hourToTimeString(end + 1)}',
        );

        // Create a WorkingHour with the time ranges stored in a way we can parse
        newHours.add(
          WorkingHour(
            day: day,
            openTime: timeRanges.join(
              ', ',
            ), // Store all ranges in openTime for now
            closeTime: '', // We'll use openTime to store the full schedule
            isOpen: true,
          ),
        );
      }
    }

    setState(() {
      hours = newHours;
    });
  }
}
