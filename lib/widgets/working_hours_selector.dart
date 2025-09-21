import 'package:flutter/material.dart';
import '../models/user.dart';
import 'working_hours_models.dart';
import 'working_hours_grid_days_rows.dart';
import 'working_hours_grid_hours_rows.dart';

class WorkingHoursWidget extends StatefulWidget {
  final bool isEnabled;
  final Function(List<WorkingHour>) onChanged;
  final List<WorkingHour>? workingHours;
  final WorkingHoursLayout layout;

  const WorkingHoursWidget({
    Key? key,
    required this.isEnabled,
    required this.onChanged,
    this.workingHours,
    this.layout = WorkingHoursLayout.daysAsRows,
  }) : super(key: key);

  @override
  State<WorkingHoursWidget> createState() => _WorkingHoursWidgetState();
}

class _WorkingHoursWidgetState extends State<WorkingHoursWidget> {
  late List<WorkingHour> hours;

  @override
  void initState() {
    super.initState();
    hours = widget.workingHours ?? _getDefaultWorkingHours();
  }

  List<WorkingHour> _getDefaultWorkingHours() {
    return WorkingHoursUtils.fullDayNames
        .map((day) => WorkingHour(day: day, isOpen: false))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          if (hours.isNotEmpty) ...[
            const SizedBox(height: 12.0),
            _buildWorkingHoursList(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Working Hours',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4.0),
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
          icon: const Icon(Icons.edit, size: 16),
          label: const Text('Modify'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkingHoursList() {
    return Column(
      children: hours.map((hour) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  hour.day.substring(0, 3),
                  style: const TextStyle(
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
    );
  }

  String _formatTimeDisplay(WorkingHour hour) {
    if (hour.openTime.contains(', ')) {
      return hour.openTime;
    } else if (hour.openTime.contains('-')) {
      return hour.openTime;
    } else {
      return '${hour.openTime} - ${hour.closeTime}';
    }
  }

  int _calculateTotalHours() {
    int totalHours = 0;
    for (var hour in hours) {
      if (hour.isOpen) {
        try {
          String timeRangesString = hour.openTime;
          if (timeRangesString.contains(', ')) {
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
            List<String> times = timeRangesString.split('-');
            if (times.length == 2) {
              int startHour = int.parse(times[0].split(':')[0]);
              int endHour = int.parse(times[1].split(':')[0]);
              totalHours += (endHour - startHour);
            }
          } else {
            int openHour = int.parse(hour.openTime.split(':')[0]);
            int closeHour = int.parse(hour.closeTime.split(':')[0]);
            totalHours += (closeHour - openHour);
          }
        } catch (e) {
          totalHours += 8;
        }
      }
    }
    return totalHours;
  }

  void _showWorkingHoursDialog(BuildContext context) {
    Map<String, Set<int>> selectedSlots = _parseCurrentHours();

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
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildDialogHeader(),
                    const SizedBox(height: 20),
                    _buildSummary(selectedSlots),
                    const SizedBox(height: 20),
                    Expanded(child: _buildGrid(selectedSlots, setDialogState)),
                    const SizedBox(height: 20),
                    _buildDialogActions(selectedSlots),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Map<String, Set<int>> _parseCurrentHours() {
    Map<String, Set<int>> selectedSlots = {};
    for (var hour in hours) {
      selectedSlots[hour.day] = <int>{};
      if (hour.isOpen) {
        String timeRangesString = hour.openTime;
        if (timeRangesString.contains(', ')) {
          List<String> ranges = timeRangesString.split(', ');
          for (String range in ranges) {
            _parseTimeRange(range, selectedSlots[hour.day]!);
          }
        } else if (timeRangesString.contains('-')) {
          _parseTimeRange(timeRangesString, selectedSlots[hour.day]!);
        } else {
          int startHour = WorkingHoursUtils.timeStringToHour(hour.openTime);
          int endHour = WorkingHoursUtils.timeStringToHour(hour.closeTime);
          for (int i = startHour; i < endHour; i++) {
            selectedSlots[hour.day]!.add(i);
          }
        }
      }
    }
    return selectedSlots;
  }

  void _parseTimeRange(String range, Set<int> slots) {
    if (range.contains('-')) {
      List<String> times = range.split('-');
      if (times.length == 2) {
        int startHour = WorkingHoursUtils.timeStringToHour(times[0]);
        int endHour = WorkingHoursUtils.timeStringToHour(times[1]);
        for (int i = startHour; i < endHour; i++) {
          slots.add(i);
        }
      }
    }
  }

  Widget _buildDialogHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.access_time, color: Colors.blue, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Working Hours',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Select your working hours by tapping time slots',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSummary(Map<String, Set<int>> selectedSlots) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.schedule, color: Colors.blue, size: 20),
          const SizedBox(width: 8),
          Text(
            'Total: ${WorkingHoursUtils.calculateSelectedHours(selectedSlots)} hours/week',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(
    Map<String, Set<int>> selectedSlots,
    StateSetter setDialogState,
  ) {
    void onSlotTap(String day, int hour, bool isSelected) {
      setDialogState(() {
        selectedSlots[day] ??= <int>{};
        if (isSelected) {
          selectedSlots[day]!.remove(hour);
        } else {
          selectedSlots[day]!.add(hour);
        }
      });
    }

    return widget.layout == WorkingHoursLayout.daysAsRows
        ? DaysAsRowsGrid(selectedSlots: selectedSlots, onSlotTap: onSlotTap)
        : HoursAsRowsGrid(selectedSlots: selectedSlots, onSlotTap: onSlotTap);
  }

  Widget _buildDialogActions(Map<String, Set<int>> selectedSlots) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
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
        const SizedBox(width: 12),
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
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Save Working Hours',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  void _saveSelectedSlots(Map<String, Set<int>> selectedSlots) {
    List<WorkingHour> newHours = [];

    for (var day in WorkingHoursUtils.fullDayNames) {
      Set<int> slots = selectedSlots[day] ?? <int>{};

      if (slots.isEmpty) {
        newHours.add(WorkingHour(day: day, isOpen: false));
      } else {
        List<int> sortedSlots = slots.toList()..sort();
        List<String> timeRanges = [];

        int start = sortedSlots.first;
        int end = sortedSlots.first;

        for (int i = 1; i < sortedSlots.length; i++) {
          if (sortedSlots[i] == end + 1) {
            end = sortedSlots[i];
          } else {
            timeRanges.add(
              '${WorkingHoursUtils.hourToTimeString(start)}-${WorkingHoursUtils.hourToTimeString(end + 1)}',
            );
            start = sortedSlots[i];
            end = sortedSlots[i];
          }
        }
        timeRanges.add(
          '${WorkingHoursUtils.hourToTimeString(start)}-${WorkingHoursUtils.hourToTimeString(end + 1)}',
        );

        newHours.add(
          WorkingHour(
            day: day,
            openTime: timeRanges.join(', '),
            closeTime: '',
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
