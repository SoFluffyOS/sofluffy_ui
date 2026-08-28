import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';
import 'package:table_calendar/table_calendar.dart';

class DateTimeRange {
  final DateTime start;
  final DateTime end;

  const DateTimeRange({required this.start, required this.end});

  Duration get duration => end.difference(start);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateTimeRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);
}

class DatePicker {
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final fluffyTheme = context.fluffyTheme;
    final pickedDate = await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: FluffyColors.barrier,
      transitionDuration: FluffyDurations.dialogTransition,
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
      pageBuilder: (context, anim1, anim2) {
        return FluffyTheme(
          data: fluffyTheme,
          child: _DatePickerDialog(
            initialDate: initialDate,
            firstDate: firstDate,
            lastDate: lastDate,
          ),
        );
      },
    );
    return pickedDate is DateTime ? pickedDate : null;
  }

  static Future<DateTimeRange?> pickRange(
    BuildContext context, {
    DateTime? initialStartDate,
    DateTime? initialEndDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final fluffyTheme = context.fluffyTheme;
    final pickedRange = await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: FluffyColors.barrier,
      transitionDuration: FluffyDurations.dialogTransition,
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
      pageBuilder: (context, anim1, anim2) {
        return FluffyTheme(
          data: fluffyTheme,
          child: _DateRangePickerDialog(
            initialStartDate: initialStartDate,
            initialEndDate: initialEndDate,
            firstDate: firstDate,
            lastDate: lastDate,
          ),
        );
      },
    );
    if (pickedRange is DateTimeRange) {
      return pickedRange;
    }
    return null;
  }
}

class _DatePickerDialog extends StatelessWidget {
  const _DatePickerDialog({
    this.initialDate,
    this.firstDate,
    this.lastDate,
  });

  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    return _DatePickerDialogContent(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }
}

class _DatePickerDialogContent extends StatefulWidget {
  const _DatePickerDialogContent({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  State<_DatePickerDialogContent> createState() =>
      _DatePickerDialogContentState();
}

class _DatePickerDialogContentState extends State<_DatePickerDialogContent> {
  late final DateTime _firstDay;
  late final DateTime _lastDay;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final firstDay = _normalizeDate(
      widget.firstDate ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
    final lastDay = _normalizeDate(widget.lastDate ?? DateTime.now());
    final normalizedBounds = switch (firstDay.isAfter(lastDay)) {
      true => (firstDay: lastDay, lastDay: firstDay),
      false => (firstDay: firstDay, lastDay: lastDay),
    };
    _firstDay = normalizedBounds.firstDay;
    _lastDay = normalizedBounds.lastDay;

    final initialCandidate = _normalizeDate(
      widget.initialDate ?? DateTime.now(),
    );
    final clampedInitialDate = _clampDate(initialCandidate);

    _focusedDay = clampedInitialDate;
    _selectedDay = clampedInitialDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.fluffyTheme;
    final isDark = context.isDark;
    final typography = theme.typography;
    final primaryColor = theme.colors.primary;
    final onSurfaceColor = isDark
        ? theme.colors.neutral1
        : theme.colors.neutral7;
    final scaffoldBg = isDark ? theme.colors.neutral7 : theme.colors.neutral1;
    final borderColor = isDark ? theme.colors.neutral5 : theme.colors.neutral3;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(Spacing.d64),
        child: RoundCard(
          padding: EdgeInsets.all(Spacing.d16),
          color: scaffoldBg,
          borderColor: borderColor,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 320,
              maxWidth: 360,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                SizedBox(height: Spacing.d12),
                TableCalendar<DateTime>(
                  firstDay: _firstDay,
                  lastDay: _lastDay,
                  focusedDay: _focusedDay,
                  currentDay: _normalizeDate(DateTime.now()),
                  headerVisible: false,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                  },
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  daysOfWeekHeight: Spacing.d24,
                  rowHeight: Spacing.d40,
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    defaultTextStyle: typography.base2.copyWith(
                      color: onSurfaceColor,
                    ),
                    weekendTextStyle: typography.base2.copyWith(
                      color: onSurfaceColor,
                    ),
                    outsideTextStyle: typography.base2.copyWith(
                      color: onSurfaceColor.withValues(alpha: 0.3),
                    ),
                    disabledTextStyle: typography.base2.copyWith(
                      color: onSurfaceColor.withValues(alpha: 0.3),
                    ),
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor),
                    ),
                    todayTextStyle: typography.base2.copyWith(
                      color: onSurfaceColor,
                      fontWeight: FontWeight.w600,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: typography.base2.copyWith(
                      color: isDark
                          ? theme.colors.neutral7
                          : theme.colors.neutral1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: typography.caption1.copyWith(
                      color: onSurfaceColor.withValues(alpha: 0.5),
                    ),
                    weekendStyle: typography.caption1.copyWith(
                      color: onSurfaceColor.withValues(alpha: 0.5),
                    ),
                  ),
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = _normalizeDate(focusedDay);
                    });
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = _normalizeDate(selectedDay);
                      _focusedDay = _normalizeDate(focusedDay);
                    });
                  },
                ),
                SizedBox(height: Spacing.d12),
                Text(
                  _formatSelectedDate(_selectedDay),
                  textAlign: TextAlign.center,
                  style: typography.caption1.copyWith(
                    color: onSurfaceColor.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: Spacing.d16),
                Row(
                  children: [
                    Expanded(
                      child: Button(
                        variant: ButtonVariant.ghost,
                        label: 'Cancel',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    SizedBox(width: Spacing.d8),
                    Expanded(
                      child: Button(
                        variant: ButtonVariant.primary,
                        label: 'Apply',
                        onPressed: () =>
                            Navigator.of(context).pop(_selectedDay),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = context.fluffyTheme;
    final isDark = context.isDark;
    final onSurfaceColor = isDark
        ? theme.colors.neutral1
        : theme.colors.neutral7;
    return Row(
      children: [
        RoundButton(
          icon: const _DatePickerChevron(direction: _DatePickerChevronDir.left),
          tooltip: 'Previous month',
          enable: _canMoveToPreviousMonth,
          onPressed: _canMoveToPreviousMonth
              ? () => _moveFocusedMonth(-1)
              : null,
        ),
        Expanded(
          child: Text(
            _monthLabel(_focusedDay),
            textAlign: TextAlign.center,
            style: context.fluffyTheme.typography.base1.copyWith(
              color: onSurfaceColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        RoundButton(
          icon: const _DatePickerChevron(
            direction: _DatePickerChevronDir.right,
          ),
          tooltip: 'Next month',
          enable: _canMoveToNextMonth,
          onPressed: _canMoveToNextMonth ? () => _moveFocusedMonth(1) : null,
        ),
      ],
    );
  }

  bool get _canMoveToPreviousMonth {
    final previousMonth = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
    final firstMonth = DateTime(_firstDay.year, _firstDay.month, 1);
    return !previousMonth.isBefore(firstMonth);
  }

  bool get _canMoveToNextMonth {
    final nextMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
    final lastMonth = DateTime(_lastDay.year, _lastDay.month, 1);
    return !nextMonth.isAfter(lastMonth);
  }

  void _moveFocusedMonth(int offset) {
    final nextMonth = DateTime(_focusedDay.year, _focusedDay.month + offset, 1);
    setState(() {
      _focusedDay = _clampDate(nextMonth);
    });
  }

  DateTime _clampDate(DateTime date) {
    if (date.isBefore(_firstDay)) {
      return _firstDay;
    }
    if (date.isAfter(_lastDay)) {
      return _lastDay;
    }
    return date;
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _monthLabel(DateTime date) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${monthNames[date.month - 1]} ${date.year}';
  }

  String _formatSelectedDate(DateTime date) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _DateRangePickerDialog extends StatelessWidget {
  const _DateRangePickerDialog({
    this.initialStartDate,
    this.initialEndDate,
    this.firstDate,
    this.lastDate,
  });

  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    return _DateRangePickerDialogContent(
      initialStartDate: initialStartDate,
      initialEndDate: initialEndDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }
}

class _DateRangePickerDialogContent extends StatefulWidget {
  const _DateRangePickerDialogContent({
    required this.initialStartDate,
    required this.initialEndDate,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  State<_DateRangePickerDialogContent> createState() =>
      _DateRangePickerDialogContentState();
}

class _DateRangePickerDialogContentState
    extends State<_DateRangePickerDialogContent> {
  late final DateTime _firstDay;
  late final DateTime _lastDay;
  late DateTime _focusedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    final firstDay = _normalizeDate(
      widget.firstDate ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
    final lastDay = _normalizeDate(widget.lastDate ?? DateTime.now());
    final normalizedBounds = switch (firstDay.isAfter(lastDay)) {
      true => (firstDay: lastDay, lastDay: firstDay),
      false => (firstDay: firstDay, lastDay: lastDay),
    };
    _firstDay = normalizedBounds.firstDay;
    _lastDay = normalizedBounds.lastDay;

    final normalizedStart = switch (widget.initialStartDate) {
      final value? => _clampDate(_normalizeDate(value)),
      null => null,
    };
    final normalizedEnd = switch (widget.initialEndDate) {
      final value? => _clampDate(_normalizeDate(value)),
      null => null,
    };

    _rangeStart = normalizedStart;
    _rangeEnd = normalizedEnd;
    _focusedDay =
        normalizedEnd ??
        normalizedStart ??
        _clampDate(_normalizeDate(DateTime.now()));

    if (_rangeStart != null &&
        _rangeEnd != null &&
        _rangeStart!.isAfter(_rangeEnd!)) {
      final start = _rangeEnd;
      _rangeEnd = _rangeStart;
      _rangeStart = start;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.fluffyTheme;
    final isDark = context.isDark;
    final typography = theme.typography;
    final primaryColor = theme.colors.primary;
    final onSurfaceColor = isDark
        ? theme.colors.neutral1
        : theme.colors.neutral7;
    final scaffoldBg = isDark ? theme.colors.neutral7 : theme.colors.neutral1;
    final borderColor = isDark ? theme.colors.neutral5 : theme.colors.neutral3;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(Spacing.d64),
        child: RoundCard(
          padding: EdgeInsets.all(Spacing.d16),
          color: scaffoldBg,
          borderColor: borderColor,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 360,
              maxWidth: 400,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                SizedBox(height: Spacing.d12),
                TableCalendar<DateTime>(
                  firstDay: _firstDay,
                  lastDay: _lastDay,
                  focusedDay: _focusedDay,
                  currentDay: _normalizeDate(DateTime.now()),
                  headerVisible: false,
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  rangeSelectionMode: RangeSelectionMode.toggledOn,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                  },
                  daysOfWeekHeight: Spacing.d24,
                  rowHeight: Spacing.d40,
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    defaultTextStyle: typography.base2.copyWith(
                      color: onSurfaceColor,
                    ),
                    weekendTextStyle: typography.base2.copyWith(
                      color: onSurfaceColor,
                    ),
                    outsideTextStyle: typography.base2.copyWith(
                      color: onSurfaceColor.withValues(alpha: 0.3),
                    ),
                    disabledTextStyle: typography.base2.copyWith(
                      color: onSurfaceColor.withValues(alpha: 0.3),
                    ),
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor),
                    ),
                    todayTextStyle: typography.base2.copyWith(
                      color: onSurfaceColor,
                      fontWeight: FontWeight.w600,
                    ),
                    rangeStartDecoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    rangeEndDecoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    rangeHighlightColor: primaryColor.withValues(alpha: 0.18),
                    rangeStartTextStyle: typography.base2.copyWith(
                      color: isDark
                          ? theme.colors.neutral7
                          : theme.colors.neutral1,
                      fontWeight: FontWeight.w600,
                    ),
                    rangeEndTextStyle: typography.base2.copyWith(
                      color: isDark
                          ? theme.colors.neutral7
                          : theme.colors.neutral1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: typography.caption1.copyWith(
                      color: onSurfaceColor.withValues(alpha: 0.5),
                    ),
                    weekendStyle: typography.caption1.copyWith(
                      color: onSurfaceColor.withValues(alpha: 0.5),
                    ),
                  ),
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = _normalizeDate(focusedDay);
                    });
                  },
                  onRangeSelected: (start, end, focusedDay) {
                    setState(() {
                      _rangeStart = switch (start) {
                        final value? => _normalizeDate(value),
                        null => null,
                      };
                      _rangeEnd = switch (end) {
                        final value? => _normalizeDate(value),
                        null => null,
                      };
                      _focusedDay = _normalizeDate(focusedDay);
                    });
                  },
                ),
                SizedBox(height: Spacing.d12),
                Text(
                  _formatSelectedRange(),
                  textAlign: TextAlign.center,
                  style: typography.caption1.copyWith(
                    color: onSurfaceColor.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: Spacing.d16),
                Row(
                  children: [
                    Expanded(
                      child: Button(
                        variant: ButtonVariant.ghost,
                        label: 'Cancel',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    SizedBox(width: Spacing.d8),
                    Expanded(
                      child: Button(
                        variant: ButtonVariant.primary,
                        label: 'Apply',
                        onPressed: switch ((_rangeStart, _rangeEnd)) {
                          (final start?, final end?) =>
                            () => Navigator.of(context).pop(
                              DateTimeRange(start: start, end: end),
                            ),
                          _ => null,
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = context.fluffyTheme;
    final isDark = context.isDark;
    final onSurfaceColor = isDark
        ? theme.colors.neutral1
        : theme.colors.neutral7;
    return Row(
      children: [
        RoundButton(
          icon: const _DatePickerChevron(direction: _DatePickerChevronDir.left),
          tooltip: 'Previous month',
          enable: _canMoveToPreviousMonth,
          onPressed: _canMoveToPreviousMonth
              ? () => _moveFocusedMonth(-1)
              : null,
        ),
        Expanded(
          child: Text(
            _monthLabel(_focusedDay),
            textAlign: TextAlign.center,
            style: context.fluffyTheme.typography.base1.copyWith(
              color: onSurfaceColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        RoundButton(
          icon: const _DatePickerChevron(
            direction: _DatePickerChevronDir.right,
          ),
          tooltip: 'Next month',
          enable: _canMoveToNextMonth,
          onPressed: _canMoveToNextMonth ? () => _moveFocusedMonth(1) : null,
        ),
      ],
    );
  }

  bool get _canMoveToPreviousMonth {
    final previousMonth = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
    final firstMonth = DateTime(_firstDay.year, _firstDay.month, 1);
    return !previousMonth.isBefore(firstMonth);
  }

  bool get _canMoveToNextMonth {
    final nextMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
    final lastMonth = DateTime(_lastDay.year, _lastDay.month, 1);
    return !nextMonth.isAfter(lastMonth);
  }

  void _moveFocusedMonth(int offset) {
    final nextMonth = DateTime(_focusedDay.year, _focusedDay.month + offset, 1);
    setState(() {
      _focusedDay = _clampDate(nextMonth);
    });
  }

  DateTime _clampDate(DateTime date) {
    if (date.isBefore(_firstDay)) {
      return _firstDay;
    }
    if (date.isAfter(_lastDay)) {
      return _lastDay;
    }
    return date;
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _monthLabel(DateTime date) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${monthNames[date.month - 1]} ${date.year}';
  }

  String _formatSelectedRange() {
    if (_rangeStart == null || _rangeEnd == null) {
      return 'Select a start and end date';
    }
    return '${_formatSelectedDate(_rangeStart!)} - ${_formatSelectedDate(_rangeEnd!)}';
  }

  String _formatSelectedDate(DateTime date) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }
}

enum _DatePickerChevronDir { left, right }

class _DatePickerChevron extends StatelessWidget {
  final _DatePickerChevronDir direction;

  const _DatePickerChevron({
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Spacing.d20,
      height: Spacing.d20,
      child: CustomPaint(
        painter: _DatePickerChevronPainter(
          direction: direction,
          color: context.isDark
              ? context.fluffyTheme.colors.neutral1
              : context.fluffyTheme.colors.neutral7,
        ),
      ),
    );
  }
}

class _DatePickerChevronPainter extends CustomPainter {
  final _DatePickerChevronDir direction;
  final Color color;

  _DatePickerChevronPainter({required this.direction, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (direction == _DatePickerChevronDir.left) {
      path.moveTo(size.width * 0.6, size.height * 0.25);
      path.lineTo(size.width * 0.35, size.height * 0.5);
      path.lineTo(size.width * 0.6, size.height * 0.75);
    } else {
      path.moveTo(size.width * 0.4, size.height * 0.25);
      path.lineTo(size.width * 0.65, size.height * 0.5);
      path.lineTo(size.width * 0.4, size.height * 0.75);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DatePickerChevronPainter oldDelegate) =>
      oldDelegate.direction != direction || oldDelegate.color != color;
}
