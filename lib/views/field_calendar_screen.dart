import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../core/theme.dart';
import '../controllers/fields_controller.dart';

class FieldCalendarScreen extends StatefulWidget {
  const FieldCalendarScreen({super.key});

  @override
  State<FieldCalendarScreen> createState() => _FieldCalendarScreenState();
}

class _FieldCalendarScreenState extends State<FieldCalendarScreen>
    with SingleTickerProviderStateMixin {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final fieldsController = Get.find<FieldsController>();

  // Sample booking data for sport fields
  final Map<DateTime, List<BookingSlot>> _bookingSlots = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _generateSampleBookings();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _generateSampleBookings() {
    final now = DateTime.now();
    
    // Generate realistic booking data for sports field
    for (int i = 0; i < 45; i++) {
      final date = DateTime(now.year, now.month, now.day + i);
      final slots = <BookingSlot>[];
      
      // Morning slots (6-12)
      if (i % 2 == 0) {
        slots.add(BookingSlot('06:00 - 08:00', BookingStatus.available, 'Available'));
        slots.add(BookingSlot('08:00 - 10:00', BookingStatus.booked, 'Football Training'));
        slots.add(BookingSlot('10:00 - 12:00', BookingStatus.available, 'Available'));
      }
      
      // Afternoon slots (12-18)
      if (i % 3 == 0) {
        slots.add(BookingSlot('12:00 - 14:00', BookingStatus.available, 'Available'));
        slots.add(BookingSlot('14:00 - 16:00', BookingStatus.booked, 'Community Match'));
        slots.add(BookingSlot('16:00 - 18:00', BookingStatus.available, 'Available'));
      }
      
      // Evening slots (18-22)
      if (i % 4 != 0) {
        slots.add(BookingSlot('18:00 - 20:00', BookingStatus.booked, 'Private Booking'));
        slots.add(BookingSlot('20:00 - 22:00', BookingStatus.available, 'Available'));
      }
      
      // Maintenance day
      if (i % 7 == 0) {
        slots.clear();
        slots.add(BookingSlot('Full Day', BookingStatus.maintenance, 'Field Maintenance'));
      }
      
      // Tournament day
      if (i % 10 == 0 && i != 0) {
        slots.clear();
        slots.add(BookingSlot('08:00 - 18:00', BookingStatus.booked, 'Tournament Event'));
      }
      
      if (slots.isNotEmpty) {
        _bookingSlots[date] = slots;
      }
    }
  }

  List<BookingSlot> _getSlotsForDay(DateTime day) {
    return _bookingSlots[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final field = fieldsController.selectedField;
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          '${field?.name ?? "Field"} Booking Schedule',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.onBackground,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
            color: AppTheme.onBackground,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _calendarFormat = _calendarFormat == CalendarFormat.month
                    ? CalendarFormat.week
                    : CalendarFormat.month;
              });
            },
            icon: Icon(
              _calendarFormat == CalendarFormat.month
                  ? Icons.view_week
                  : Icons.view_module,
              color: AppTheme.onBackground,
            ),
            tooltip: _calendarFormat == CalendarFormat.month
                ? 'Week View'
                : 'Month View',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Booking status legend
            _buildBookingLegend(),
            
            // Calendar
            _buildCalendarCard(),
            
            SizedBox(height: 8.h),
            
            // Selected day bookings
            Expanded(
              child: _buildSelectedDayBookings(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingLegend() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTheme.onBackground.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Status',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.onBackground,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildLegendItem(Colors.green, 'Available', Icons.check_circle),
              SizedBox(width: 16.w),
              _buildLegendItem(Colors.red, 'Booked', Icons.cancel),
              SizedBox(width: 16.w),
              _buildLegendItem(Colors.orange, 'Maintenance', Icons.build),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: color,
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppTheme.onBackground.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TableCalendar<BookingSlot>(
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2025, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        eventLoader: _getSlotsForDay,
        startingDayOfWeek: StartingDayOfWeek.monday,
        
        // Calendar styling
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.w600,
          ),
          
          // Today styling
          todayDecoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
          
          // Selected day styling
          selectedDecoration: BoxDecoration(
            color: AppTheme.primaryColor,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.onPrimary,
          ),
          
          // Default day styling
          defaultTextStyle: TextStyle(
            color: AppTheme.onBackground,
            fontWeight: FontWeight.w500,
          ),
          
          // Markers
          markersMaxCount: 4,
          markerDecoration: const BoxDecoration(
            color: Colors.transparent,
          ),
        ),
        
        // Header styling
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.onBackground,
          ),
          leftChevronIcon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chevron_left,
              color: AppTheme.primaryColor,
              size: 20.sp,
            ),
          ),
          rightChevronIcon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chevron_right,
              color: AppTheme.primaryColor,
              size: 20.sp,
            ),
          ),
          headerPadding: EdgeInsets.symmetric(vertical: 16.h),
        ),
        
        // Days of week styling
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: AppTheme.onBackground.withOpacity(0.7),
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
          weekendStyle: TextStyle(
            color: AppTheme.primaryColor.withOpacity(0.8),
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
        ),
        
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        
        // Custom marker builder for booking status
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, slots) {
            if (slots.isEmpty) return const SizedBox();
            
            return Positioned(
              bottom: 4,
              child: Wrap(
                children: slots.take(3).map((slot) {
                  Color markerColor;
                  switch (slot.status) {
                    case BookingStatus.available:
                      markerColor = Colors.green;
                      break;
                    case BookingStatus.booked:
                      markerColor = Colors.red;
                      break;
                    case BookingStatus.maintenance:
                      markerColor = Colors.orange;
                      break;
                  }
                  
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: markerColor,
                      shape: BoxShape.circle,
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSelectedDayBookings() {
    final selectedDate = _selectedDay ?? _focusedDay;
    final slots = _getSlotsForDay(selectedDate);
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                Icon(
                  Icons.event,
                  color: AppTheme.primaryColor,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Schedule for ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.onBackground,
                  ),
                ),
              ],
            ),
          ),
          
          if (slots.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 48.sp,
                      color: AppTheme.onBackground.withOpacity(0.3),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'No bookings scheduled',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppTheme.onBackground.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Field is available for booking',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.onBackground.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: slots.length,
                separatorBuilder: (context, index) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final slot = slots[index];
                  return _buildBookingSlotCard(slot);
                },
              ),
            ),
          
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildBookingSlotCard(BookingSlot slot) {
    Color statusColor;
    IconData statusIcon;
    
    switch (slot.status) {
      case BookingStatus.available:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
        break;
      case BookingStatus.booked:
        statusColor = Colors.red;
        statusIcon = Icons.cancel_outlined;
        break;
      case BookingStatus.maintenance:
        statusColor = Colors.orange;
        statusIcon = Icons.build_outlined;
        break;
    }
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              statusIcon,
              color: statusColor,
              size: 20.sp,
            ),
          ),
          
          SizedBox(width: 16.w),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot.timeSlot,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.onBackground,
                  ),
                ),
                
                if (slot.title.isNotEmpty && slot.title != 'Available') ...[
                  SizedBox(height: 4.h),
                  Text(
                    slot.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              slot.status.name.toUpperCase(),
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum BookingStatus { available, booked, maintenance }

class BookingSlot {
  final String timeSlot;
  final BookingStatus status;
  final String title;

  BookingSlot(this.timeSlot, this.status, this.title);
}