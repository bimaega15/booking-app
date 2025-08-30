import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../core/theme.dart';
import '../controllers/fields_controller.dart';
import 'booking_form_screen.dart';

class FieldCalendarScreen extends StatefulWidget {
  const FieldCalendarScreen({super.key});

  @override
  State<FieldCalendarScreen> createState() => _FieldCalendarScreenState();
}

class _FieldCalendarScreenState extends State<FieldCalendarScreen>
    with SingleTickerProviderStateMixin {
  CalendarView _calendarView = CalendarView.month;
  DateTime _selectedDate = DateTime.now();
  final CalendarController _calendarController = CalendarController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final fieldsController = Get.find<FieldsController>();

  // Sample booking data for sport fields
  final List<Appointment> _bookingAppointments = <Appointment>[];
  bool _isCalendarReady = false;

  @override
  void initState() {
    super.initState();
    _calendarController.selectedDate = _selectedDate;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _generateSampleBookings();
    _animationController.forward();

    // Delay untuk memastikan calendar ready
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isCalendarReady = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _generateSampleBookings() {
    final now = DateTime.now();
    _bookingAppointments.clear();

    // Generate realistic booking data for sports field
    for (int i = 0; i < 45; i++) {
      final date =
          DateTime(now.year, now.month, now.day).add(Duration(days: i));

      // Morning slots (6-12)
      if (i % 2 == 0) {
        _bookingAppointments.add(Appointment(
          startTime: DateTime(date.year, date.month, date.day, 6, 0),
          endTime: DateTime(date.year, date.month, date.day, 8, 0),
          subject: 'Available Slot',
          color: Colors.green.withOpacity(0.8),
          notes: 'available',
        ));
        _bookingAppointments.add(Appointment(
          startTime: DateTime(date.year, date.month, date.day, 8, 0),
          endTime: DateTime(date.year, date.month, date.day, 10, 0),
          subject: 'Football Training',
          color: AppTheme.primaryColor,
          notes: 'booked',
        ));
        _bookingAppointments.add(Appointment(
          startTime: DateTime(date.year, date.month, date.day, 10, 0),
          endTime: DateTime(date.year, date.month, date.day, 12, 0),
          subject: 'Available Slot',
          color: Colors.green.withOpacity(0.8),
          notes: 'available',
        ));
      }

      // Afternoon slots (12-18)
      if (i % 3 == 0) {
        _bookingAppointments.add(Appointment(
          startTime: DateTime(date.year, date.month, date.day, 12, 0),
          endTime: DateTime(date.year, date.month, date.day, 14, 0),
          subject: 'Available Slot',
          color: Colors.green.withOpacity(0.8),
          notes: 'available',
        ));
        _bookingAppointments.add(Appointment(
          startTime: DateTime(date.year, date.month, date.day, 14, 0),
          endTime: DateTime(date.year, date.month, date.day, 16, 0),
          subject: 'Community Match',
          color: AppTheme.secondaryColor,
          notes: 'booked',
        ));
        _bookingAppointments.add(Appointment(
          startTime: DateTime(date.year, date.month, date.day, 16, 0),
          endTime: DateTime(date.year, date.month, date.day, 18, 0),
          subject: 'Available Slot',
          color: Colors.green.withOpacity(0.8),
          notes: 'available',
        ));
      }

      // Evening slots (18-22)
      if (i % 4 != 0) {
        _bookingAppointments.add(Appointment(
          startTime: DateTime(date.year, date.month, date.day, 18, 0),
          endTime: DateTime(date.year, date.month, date.day, 20, 0),
          subject: 'Private Booking',
          color: AppTheme.primaryVariant,
          notes: 'booked',
        ));
        _bookingAppointments.add(Appointment(
          startTime: DateTime(date.year, date.month, date.day, 20, 0),
          endTime: DateTime(date.year, date.month, date.day, 22, 0),
          subject: 'Available Slot',
          color: Colors.green.withOpacity(0.8),
          notes: 'available',
        ));
      }

      // Maintenance day
      if (i % 7 == 0) {
        _bookingAppointments.add(Appointment(
          startTime: DateTime(date.year, date.month, date.day, 8, 0),
          endTime: DateTime(date.year, date.month, date.day, 18, 0),
          subject: 'Field Maintenance',
          color: Colors.orange,
          notes: 'maintenance',
        ));
      }

      // Tournament day
      if (i % 10 == 0 && i != 0) {
        _bookingAppointments.add(Appointment(
          startTime: DateTime(date.year, date.month, date.day, 8, 0),
          endTime: DateTime(date.year, date.month, date.day, 18, 0),
          subject: 'Tournament Event',
          color: AppTheme.errorColor,
          notes: 'tournament',
        ));
      }
    }
  }

  List<Appointment> _getAppointmentsForDay(DateTime day) {
    return _bookingAppointments.where((appointment) {
      final appointmentDate = DateTime(appointment.startTime.year,
          appointment.startTime.month, appointment.startTime.day);
      final targetDate = DateTime(day.year, day.month, day.day);
      return appointmentDate == targetDate;
    }).toList();
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
          PopupMenuButton<CalendarView>(
            icon: Icon(
              Icons.view_comfy,
              color: AppTheme.onBackground,
            ),
            onSelected: (CalendarView view) {
              setState(() {
                _calendarView = view;
              });
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<CalendarView>>[
              PopupMenuItem<CalendarView>(
                value: CalendarView.month,
                child: Row(
                  children: [
                    Icon(Icons.calendar_month,
                        color: AppTheme.primaryColor, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text('Month View', style: TextStyle(fontSize: 14.sp)),
                  ],
                ),
              ),
              PopupMenuItem<CalendarView>(
                value: CalendarView.week,
                child: Row(
                  children: [
                    Icon(Icons.calendar_view_week,
                        color: AppTheme.primaryColor, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text('Week View', style: TextStyle(fontSize: 14.sp)),
                  ],
                ),
              ),
              PopupMenuItem<CalendarView>(
                value: CalendarView.day,
                child: Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: AppTheme.primaryColor, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text('Day View', style: TextStyle(fontSize: 14.sp)),
                  ],
                ),
              ),
              PopupMenuItem<CalendarView>(
                value: CalendarView.timelineDay,
                child: Row(
                  children: [
                    Icon(Icons.timeline,
                        color: AppTheme.primaryColor, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text('Timeline View', style: TextStyle(fontSize: 14.sp)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                children: [
                  // Booking status legend
                  _buildBookingLegend(),

                  SizedBox(height: 8.h),

                  // Calendar - make it more spacious
                  Expanded(
                    flex: _calendarView == CalendarView.month ? 3 : 4,
                    child: _buildCalendarCard(),
                  ),

                  SizedBox(height: 16.h),

                  // Selected day bookings
                  if (_calendarView == CalendarView.month ||
                      _calendarView == CalendarView.week)
                    Expanded(
                      flex: 2,
                      child: _buildSelectedDayBookings(),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookingLegend() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.surfaceColor,
            AppTheme.surfaceColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.primaryColor,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Booking Status Legend',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.onBackground,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 6.h,
            children: [
              _buildLegendItem(Colors.green.withOpacity(0.8), 'Available',
                  Icons.check_circle),
              _buildLegendItem(
                  AppTheme.primaryColor, 'Training', Icons.sports_soccer),
              _buildLegendItem(
                  AppTheme.secondaryColor, 'Match', Icons.emoji_events),
              _buildLegendItem(
                  AppTheme.primaryVariant, 'Private', Icons.person),
              _buildLegendItem(Colors.orange, 'Maintenance', Icons.build),
              _buildLegendItem(
                  AppTheme.errorColor, 'Tournament', Icons.military_tech),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12.sp,
            color: color,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: AppTheme.onBackground.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.surfaceColor,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 20,
            offset: const Offset(0, -4),
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: _buildSafeCalendar(),
      ),
    );
  }

  Widget _buildSafeCalendar() {
    if (!_isCalendarReady) {
      return Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
            SizedBox(height: 16.h),
            Text(
              'Loading Calendar...',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.onBackground,
              ),
            ),
          ],
        ),
      );
    }

    try {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: SfCalendar(
              view: _calendarView,
              controller: _calendarController,
              dataSource: MeetingDataSource(_bookingAppointments),
              initialDisplayDate: DateTime.now(),
              showDatePickerButton: false,
              showNavigationArrow: true,
              showCurrentTimeIndicator: false,
              monthViewSettings: MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                showAgenda: false,
                monthCellStyle: MonthCellStyle(
                  backgroundColor: Colors.transparent,
                  todayBackgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                  leadingDatesBackgroundColor: Colors.grey.withOpacity(0.1),
                  trailingDatesBackgroundColor: Colors.grey.withOpacity(0.1),
                  textStyle: TextStyle(
                    color: AppTheme.onBackground,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  leadingDatesTextStyle: TextStyle(
                    color: AppTheme.onBackground.withOpacity(0.4),
                    fontSize: 16.sp,
                  ),
                  trailingDatesTextStyle: TextStyle(
                    color: AppTheme.onBackground.withOpacity(0.4),
                    fontSize: 16.sp,
                  ),
                ),
                agendaStyle: AgendaStyle(
                  backgroundColor: AppTheme.surfaceColor,
                  appointmentTextStyle: TextStyle(
                    color: AppTheme.onBackground,
                    fontSize: 12.sp,
                  ),
                  dayTextStyle: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  dateTextStyle: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              timeSlotViewSettings: TimeSlotViewSettings(
                startHour: 6,
                endHour: 22,
                timeIntervalHeight: 60,
                minimumAppointmentDuration: const Duration(minutes: 30),
                timeTextStyle: TextStyle(
                  color: AppTheme.onBackground.withOpacity(0.7),
                  fontSize: 12.sp,
                ),
                timeFormat: 'HH:mm',
              ),
              headerStyle: CalendarHeaderStyle(
                backgroundColor: Colors.transparent,
                textStyle: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.onBackground,
                ),
              ),
              viewHeaderStyle: ViewHeaderStyle(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                dayTextStyle: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
                dateTextStyle: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              todayHighlightColor: AppTheme.primaryColor,
              selectionDecoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.3),
                border: Border.all(
                  color: AppTheme.primaryColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              appointmentTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
              onTap: (CalendarTapDetails details) {
                if (details.targetElement == CalendarElement.calendarCell &&
                    details.date != null) {
                  setState(() {
                    _selectedDate = details.date!;
                    _calendarController.selectedDate = _selectedDate;
                  });
                } else if (details.targetElement ==
                        CalendarElement.appointment &&
                    details.appointments != null) {
                  final appointment =
                      details.appointments!.first as Appointment;
                  _showAppointmentDetails(appointment);
                }
              },
              allowViewNavigation: true,
              allowedViews: const [
                CalendarView.month,
                CalendarView.week,
                CalendarView.day,
                CalendarView.timelineDay,
              ],
            ),
          );
        },
      );
    } catch (e) {
      // Fallback calendar jika ada error timezone
      return Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 64.sp,
              color: AppTheme.primaryColor.withOpacity(0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              'Calendar Loading...',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.onBackground,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Please wait while calendar initializes',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.onBackground.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildSelectedDayBookings() {
    final selectedDate = _selectedDate;
    final appointments = _getAppointmentsForDay(selectedDate);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
          if (appointments.isEmpty)
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
              child: appointments.isNotEmpty
                  ? ListView.separated(
                      physics: const ClampingScrollPhysics(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      itemCount: appointments.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        if (index >= appointments.length)
                          return const SizedBox.shrink();
                        final appointment = appointments[index];
                        return _buildAppointmentCard(appointment);
                      },
                    )
                  : const SizedBox.shrink(),
            ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    IconData statusIcon = Icons.event;
    String statusText = 'Available';

    if (appointment.notes == 'available') {
      statusIcon = Icons.check_circle_outline;
      statusText = 'Available';
    } else if (appointment.notes == 'booked') {
      statusIcon = Icons.event_available;
      statusText = 'Booked';
    } else if (appointment.notes == 'maintenance') {
      statusIcon = Icons.build_outlined;
      statusText = 'Maintenance';
    } else if (appointment.notes == 'tournament') {
      statusIcon = Icons.military_tech;
      statusText = 'Tournament';
    }

    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            appointment.color.withOpacity(0.1),
            appointment.color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: appointment.color.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: appointment.color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () => _showAppointmentDetails(appointment),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: appointment.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: appointment.color.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    statusIcon,
                    color: appointment.color,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${appointment.startTime.hour.toString().padLeft(2, '0')}:${appointment.startTime.minute.toString().padLeft(2, '0')} - ${appointment.endTime.hour.toString().padLeft(2, '0')}:${appointment.endTime.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.onBackground,
                        ),
                      ),
                      if (appointment.subject.isNotEmpty &&
                          appointment.subject != 'Available Slot') ...[
                        SizedBox(height: 4.h),
                        Text(
                          appointment.subject,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppTheme.onBackground.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      if (appointment.notes?.isNotEmpty == true) ...[
                        SizedBox(height: 2.h),
                        Text(
                          'Duration: ${appointment.endTime.difference(appointment.startTime).inHours}h ${appointment.endTime.difference(appointment.startTime).inMinutes.remainder(60)}m',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppTheme.onBackground.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: appointment.color,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: appointment.color.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    statusText.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAppointmentDetails(Appointment appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.surfaceColor,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 50.w,
              height: 4.h,
              margin: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: AppTheme.onBackground.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: appointment.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            appointment.notes == 'available'
                                ? Icons.check_circle
                                : appointment.notes == 'maintenance'
                                    ? Icons.build
                                    : appointment.notes == 'tournament'
                                        ? Icons.military_tech
                                        : Icons.event,
                            color: appointment.color,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointment.subject,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.onBackground,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                appointment.notes?.toUpperCase() ?? 'BOOKING',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: appointment.color,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    _buildDetailRow(
                      Icons.access_time,
                      'Time',
                      '${appointment.startTime.hour.toString().padLeft(2, '0')}:${appointment.startTime.minute.toString().padLeft(2, '0')} - ${appointment.endTime.hour.toString().padLeft(2, '0')}:${appointment.endTime.minute.toString().padLeft(2, '0')}',
                    ),
                    SizedBox(height: 16.h),
                    _buildDetailRow(
                      Icons.timelapse,
                      'Duration',
                      '${appointment.endTime.difference(appointment.startTime).inHours}h ${appointment.endTime.difference(appointment.startTime).inMinutes.remainder(60)}m',
                    ),
                    SizedBox(height: 16.h),
                    _buildDetailRow(
                      Icons.calendar_today,
                      'Date',
                      '${appointment.startTime.day}/${appointment.startTime.month}/${appointment.startTime.year}',
                    ),
                    if (appointment.notes == 'available') ...[
                      SizedBox(height: 32.h),
                      Container(
                        width: double.infinity,
                        child: Obx(() => ElevatedButton(
                          onPressed: fieldsController.selectedField?.isActive ?? false
                              ? () {
                                  Get.back();
                                  Get.to(() => const BookingFormScreen());
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.book_online, size: 20.sp),
                              SizedBox(width: 8.w),
                              Text(
                                fieldsController.selectedField?.isActive ?? false
                                    ? 'Book This Slot'
                                    : 'Closed',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          ),
                        )),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTheme.onBackground.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 20.sp,
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.onBackground.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppTheme.onBackground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source.where((appointment) {
      // Validasi appointment untuk menghindari error geometry
      return appointment.startTime.isBefore(appointment.endTime) &&
          appointment.startTime.hour >= 0 &&
          appointment.startTime.hour <= 23 &&
          appointment.endTime.hour >= 0 &&
          appointment.endTime.hour <= 23;
    }).toList();
  }
}
