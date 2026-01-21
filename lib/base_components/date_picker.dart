import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DatePicker {
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final pickedDate = await showDialog(
      context: context,
      builder: (context) {
        return _DatePickerDialog(
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
        );
      },
      useRootNavigator: false,
    );
    return pickedDate is DateTime ? pickedDate : null;
  }
}

class _DatePickerDialog extends StatelessWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const _DatePickerDialog({
    this.initialDate,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: SmoothRectangleBorder(
        borderRadius: Spacing.smoothR12,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // TODO: implement.
          SizedBox(
            height: 400,
            width: 400,
            child: TableCalendar(
              firstDay: firstDate ?? DateTime.fromMillisecondsSinceEpoch(0),
              lastDay: lastDate ?? DateTime.now(),
              focusedDay: initialDate ?? DateTime.now(),
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
