import 'package:flutter/material.dart';
import 'working_hours_models.dart';

class HoursAsRowsGrid extends StatefulWidget {
  final Map<String, Set<int>> selectedSlots;
  final Function(String day, int hour, bool isSelected) onSlotTap;

  const HoursAsRowsGrid({
    Key? key,
    required this.selectedSlots,
    required this.onSlotTap,
  }) : super(key: key);

  @override
  State<HoursAsRowsGrid> createState() => _HoursAsRowsGridState();
}

class _HoursAsRowsGridState extends State<HoursAsRowsGrid> {
  late ScrollController _horizontalController;
  late ScrollController _verticalController;
  late ScrollController _horizontalHeaderController;
  late ScrollController _verticalHeaderController;

  bool _isUpdatingHorizontal = false;
  bool _isUpdatingVertical = false;

  @override
  void initState() {
    super.initState();
    _horizontalController = ScrollController();
    _verticalController = ScrollController();
    _horizontalHeaderController = ScrollController();
    _verticalHeaderController = ScrollController();

    // Sync horizontal scrolling between header and main grid
    _horizontalController.addListener(() {
      if (!_isUpdatingHorizontal && _horizontalHeaderController.hasClients) {
        _isUpdatingHorizontal = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_horizontalHeaderController.hasClients) {
            _horizontalHeaderController.jumpTo(_horizontalController.offset);
          }
          _isUpdatingHorizontal = false;
        });
      }
    });

    _horizontalHeaderController.addListener(() {
      if (!_isUpdatingHorizontal && _horizontalController.hasClients) {
        _isUpdatingHorizontal = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_horizontalController.hasClients) {
            _horizontalController.jumpTo(_horizontalHeaderController.offset);
          }
          _isUpdatingHorizontal = false;
        });
      }
    });

    // Sync vertical scrolling between side labels and main grid
    _verticalController.addListener(() {
      if (!_isUpdatingVertical && _verticalHeaderController.hasClients) {
        _isUpdatingVertical = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_verticalHeaderController.hasClients) {
            _verticalHeaderController.jumpTo(_verticalController.offset);
          }
          _isUpdatingVertical = false;
        });
      }
    });

    _verticalHeaderController.addListener(() {
      if (!_isUpdatingVertical && _verticalController.hasClients) {
        _isUpdatingVertical = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_verticalController.hasClients) {
            _verticalController.jumpTo(_verticalHeaderController.offset);
          }
          _isUpdatingVertical = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    _horizontalHeaderController.dispose();
    _verticalHeaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cellHeight = ((constraints.maxHeight - 50) / 24).clamp(
          30.0,
          50.0,
        );
        double cellWidth = ((constraints.maxWidth - 80) / 7).clamp(70.0, 120.0);

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              _buildHourLabelsColumn(cellHeight),
              Expanded(child: _buildDayColumns(cellWidth, cellHeight)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHourLabelsColumn(double cellHeight) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          _buildCornerCell(),
          Expanded(
            child: SingleChildScrollView(
              controller: _verticalHeaderController,
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: List.generate(
                  24,
                  (hour) => _buildHourLabelCell(hour, cellHeight),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCornerCell() {
    return Container(
      width: 80,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 2),
          bottom: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8)),
      ),
      child: Center(
        child: Text(
          'Hour',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildHourLabelCell(int hour, double cellHeight) {
    bool isPeakHour = WorkingHoursUtils.isBusinessHour(hour);
    int totalDaysAtThisHour = 0;
    for (String fullDay in WorkingHoursUtils.fullDayNames) {
      if (widget.selectedSlots[fullDay]?.contains(hour) ?? false) {
        totalDaysAtThisHour++;
      }
    }

    return Container(
      width: 80,
      height: cellHeight,
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
            '${hour.toString().padLeft(2, '0')}:00',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: isPeakHour ? Colors.blue.shade700 : Colors.grey.shade700,
            ),
          ),
          Text(
            '${totalDaysAtThisHour}d',
            style: TextStyle(
              fontSize: 9,
              color: Colors.blue.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayColumns(double cellWidth, double cellHeight) {
    return Column(
      children: [
        _buildDayHeader(cellWidth),
        Expanded(
          child: SingleChildScrollView(
            controller: _horizontalController,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: SingleChildScrollView(
              controller: _verticalController,
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: List.generate(
                  24,
                  (hour) => _buildHourRow(hour, cellWidth, cellHeight),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayHeader(double cellWidth) {
    return SizedBox(
      height: 50,
      child: SingleChildScrollView(
        controller: _horizontalHeaderController,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        child: Row(
          children: WorkingHoursUtils.dayAbbreviations.asMap().entries.map((
            entry,
          ) {
            int dayIndex = entry.key;
            String day = entry.value;
            String fullDay = WorkingHoursUtils.fullDayNames[dayIndex];

            return Container(
              width: cellWidth,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border(
                  right: BorderSide(color: Colors.grey.shade200),
                  bottom: BorderSide(color: Colors.grey.shade300, width: 2),
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
                    '${widget.selectedSlots[fullDay]?.length ?? 0}h',
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
    );
  }

  Widget _buildHourRow(int hour, double cellWidth, double cellHeight) {
    bool isBusinessHour = WorkingHoursUtils.isBusinessHour(hour);

    return SizedBox(
      height: cellHeight,
      child: Row(
        children: WorkingHoursUtils.dayAbbreviations.asMap().entries.map((
          entry,
        ) {
          int dayIndex = entry.key;
          String fullDay = WorkingHoursUtils.fullDayNames[dayIndex];
          bool isSelected =
              widget.selectedSlots[fullDay]?.contains(hour) ?? false;

          return GestureDetector(
            onTap: () => widget.onSlotTap(fullDay, hour, isSelected),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: cellWidth,
              height: cellHeight,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blue.shade100
                    : (isBusinessHour ? Colors.blue.shade50 : Colors.white),
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
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
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          )
                        : null),
            ),
          );
        }).toList(),
      ),
    );
  }
}
