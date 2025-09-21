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
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.8,
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.access_time,
                            color: Colors.blue,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Working Hours',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Select your working hours by tapping time slots',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Summary
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.schedule, color: Colors.blue, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Total: ${_calculateSelectedHours(selectedSlots)} hours/week',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Time Grid
                    Expanded(
                      child: _buildResponsiveTimeGrid(
                        selectedSlots,
                        setDialogState,
                      ),
                    ),

                    SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              _saveSelectedSlots(selectedSlots);
                              widget.onChanged(hours);
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Save Working Hours',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  int _calculateSelectedHours(Map<String, Set<int>> selectedSlots) {
    int total = 0;
    for (var slots in selectedSlots.values) {
      total += slots.length;
    }
    return total;
  }

  Widget _buildResponsiveTimeGrid(
    Map<String, Set<int>> selectedSlots,
    StateSetter setDialogState,
  ) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final fullDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive dimensions
        double availableWidth = constraints.maxWidth;
        double cellWidth = (availableWidth - 80) / 24; // 80 for day label width
        cellWidth = cellWidth.clamp(25.0, 45.0); // Min and max cell width

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Sticky Time header
              Container(
                height: 50,
                child: Row(
                  children: [
                    // Sticky corner cell
                    Container(
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border(
                          right: BorderSide(color: Colors.grey.shade300, width: 2),
                          bottom: BorderSide(color: Colors.grey.shade300, width: 2),
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Time',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                    // Scrollable time slots
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(24, (hour) {
                            bool isPeakHour = hour >= 9 && hour <= 17;
                            return Container(
                              width: cellWidth,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isPeakHour
                                    ? Colors.blue.shade50
                                    : Colors.grey.shade50,
                                border: Border(
                                  right: BorderSide(color: Colors.grey.shade200),
                                  bottom: BorderSide(color: Colors.grey.shade300, width: 2),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${hour.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isPeakHour
                                          ? Colors.blue.shade700
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    ':00',
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Day rows with sticky first column
              Expanded(
                child: Row(
                  children: [
                    // Sticky day labels column
                    Container(
                      width: 80,
                      child: SingleChildScrollView(
                        child: Column(
                          children: days.asMap().entries.map((entry) {
                            int dayIndex = entry.key;
                            String day = entry.value;
                            String fullDay = fullDays[dayIndex];
                            
                            return Container(
                              width: 80,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                border: Border(
                                  right: BorderSide(color: Colors.grey.shade300, width: 2),
                                  bottom: BorderSide(color: Colors.grey.shade200),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    day,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Text(
                                    '${selectedSlots[fullDay]?.length ?? 0}h',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.blue.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    
                    // Scrollable time slots area
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: Column(
                            children: days.asMap().entries.map((entry) {
                              int dayIndex = entry.key;
                              String fullDay = fullDays[dayIndex];

                              return Container(
                                height: 60,
                                child: Row(
                                  children: List.generate(24, (hour) {
                                    bool isSelected =
                                        selectedSlots[fullDay]?.contains(hour) ?? false;
                                    bool isBusinessHour = hour >= 9 && hour <= 17;

                                    return GestureDetector(
                                      onTap: () {
                                        setDialogState(() {
                                          if (selectedSlots[fullDay] == null) {
                                            selectedSlots[fullDay] = <int>{};
                                          }
                                          if (isSelected) {
                                            selectedSlots[fullDay]!.remove(hour);
                                          } else {
                                            selectedSlots[fullDay]!.add(hour);
                                          }
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 150),
                                        width: cellWidth,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.blue.shade100
                                              : (isBusinessHour
                                                    ? Colors.blue.shade50
                                                    : Colors.white),
                                          border: Border(
                                            right: BorderSide(color: Colors.grey.shade200),
                                            bottom: BorderSide(color: Colors.grey.shade200),
                                          ),
                                        ),
                                        child: isSelected
                                            ? Center(
                                                child: Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                  ),
                                                  child: Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                ),
                                              )
                                            : (isBusinessHour
                                                  ? Center(
                                                      child: Container(
                                                        width: 4,
                                                        height: 4,
                                                        decoration: BoxDecoration(
                                                          color: Colors.blue.shade200,
                                                          borderRadius:
                                                              BorderRadius.circular(2),
                                                        ),
                                                      ),
                                                    )
                                                  : null),
                                      ),
                                    );
                                  }),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
