import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/booking_controller.dart';
import '../controllers/fields_controller.dart';
import '../core/theme.dart';

class BookingFormScreen extends StatefulWidget {
  const BookingFormScreen({super.key});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final bookingController = Get.find<BookingController>();
  final fieldsController = Get.find<FieldsController>();
  final notesController = TextEditingController();
  
  DateTime selectedDate = DateTime.now();
  String? selectedStartTime;
  String? selectedEndTime;

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Book Field'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldInfo(),
              SizedBox(height: 24.h),
              _buildDateSelection(),
              SizedBox(height: 24.h),
              _buildTimeSelection(),
              SizedBox(height: 24.h),
              _buildNotesSection(),
              SizedBox(height: 24.h),
              _buildPriceSummary(),
              SizedBox(height: 32.h),
              _buildBookButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldInfo() {
    return Obx(() {
      final field = fieldsController.selectedField;
      if (field == null) return const SizedBox.shrink();

      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: 60.w,
                height: 60.w,
                color: Colors.grey[300],
                child: field.images.isNotEmpty
                    ? Image.network(
                        field.images.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.sports,
                          color: AppTheme.onBackground.withOpacity(0.5),
                        ),
                      )
                    : Icon(
                        Icons.sports,
                        color: AppTheme.onBackground.withOpacity(0.5),
                      ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.onBackground,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    field.location,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.onBackground.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Rp ${field.pricePerHour.toInt()}/hour',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Date',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.onBackground,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ListTile(
            leading: Icon(
              Icons.calendar_today,
              color: AppTheme.primaryColor,
              size: 20.sp,
            ),
            title: Text(
              DateFormat('EEEE, dd MMMM yyyy').format(selectedDate),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.onBackground,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.onBackground.withOpacity(0.5),
              size: 16.sp,
            ),
            onTap: _selectDate,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelection() {
    return Obx(() {
      final field = fieldsController.selectedField;
      if (field == null) return const SizedBox.shrink();

      final dayName = DateFormat('EEEE').format(selectedDate);
      final availableHours = field.availableHours[dayName] ?? [];
      final bookedHours = bookingController.getBookedHours(field.id, selectedDate);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Time',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.onBackground,
            ),
          ),
          SizedBox(height: 12.h),
          if (availableHours.isEmpty)
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  'No available hours for this day',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppTheme.onBackground.withOpacity(0.6),
                  ),
                ),
              ),
            )
          else ...[
            Text(
              'Start Time',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.onBackground.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: availableHours.map((hour) {
                final isBooked = bookedHours.contains(hour);
                final isSelected = selectedStartTime == hour;
                
                return GestureDetector(
                  onTap: isBooked ? null : () {
                    setState(() {
                      selectedStartTime = hour;
                      selectedEndTime = null;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isBooked
                          ? Colors.red.withOpacity(0.1)
                          : isSelected
                              ? AppTheme.primaryColor
                              : AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isBooked
                            ? Colors.red.withOpacity(0.3)
                            : isSelected
                                ? AppTheme.primaryColor
                                : AppTheme.onBackground.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      hour,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: isBooked
                            ? Colors.red.withOpacity(0.7)
                            : isSelected
                                ? AppTheme.onPrimary
                                : AppTheme.onBackground,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            if (selectedStartTime != null) ...[
              SizedBox(height: 16.h),
              Text(
                'End Time',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.onBackground.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: _getAvailableEndTimes(availableHours, bookedHours).map((hour) {
                  final isSelected = selectedEndTime == hour;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedEndTime = hour;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : AppTheme.onBackground.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        hour,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppTheme.onPrimary
                              : AppTheme.onBackground,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ],
      );
    });
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes (Optional)',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.onBackground,
          ),
        ),
        SizedBox(height: 12.h),
        TextField(
          controller: notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Add any special requests or notes...',
            filled: true,
            fillColor: AppTheme.surfaceColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) => bookingController.setNotes(value),
        ),
      ],
    );
  }

  Widget _buildPriceSummary() {
    if (selectedStartTime == null || selectedEndTime == null) {
      return const SizedBox.shrink();
    }

    return Obx(() {
      final field = fieldsController.selectedField;
      if (field == null) return const SizedBox.shrink();

      final hours = _calculateHours();
      final totalPrice = hours * field.pricePerHour;

      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Duration',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppTheme.onBackground.withOpacity(0.7),
                  ),
                ),
                Text(
                  '${hours.toStringAsFixed(0)} hour${hours > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onBackground,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price per hour',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppTheme.onBackground.withOpacity(0.7),
                  ),
                ),
                Text(
                  'Rp ${field.pricePerHour.toInt()}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onBackground,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Divider(
              color: AppTheme.primaryColor.withOpacity(0.3),
              thickness: 1,
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Price',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.onBackground,
                  ),
                ),
                Text(
                  'Rp ${totalPrice.toInt()}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBookButton() {
    return SizedBox(
      width: double.infinity,
      child: Obx(() => ElevatedButton(
        onPressed: _canBook() ? _handleBooking : null,
        child: bookingController.isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.onPrimary),
                ),
              )
            : Text(
                'Confirm Booking',
                style: TextStyle(fontSize: 16.sp),
              ),
      )),
    );
  }

  bool _canBook() {
    return selectedStartTime != null &&
           selectedEndTime != null &&
           !bookingController.isLoading;
  }

  void _handleBooking() async {
    final field = fieldsController.selectedField;
    if (field == null || selectedStartTime == null || selectedEndTime == null) {
      return;
    }

    bookingController.setBookingDetails(
      fieldId: field.id,
      date: selectedDate,
      startTime: selectedStartTime!,
      endTime: selectedEndTime!,
      pricePerHour: field.pricePerHour,
    );

    final success = await bookingController.createBooking();
    if (success) {
      Get.back();
      Get.back();
      Get.snackbar(
        'Success',
        'Booking created successfully!',
        backgroundColor: AppTheme.primaryColor,
        colorText: AppTheme.onPrimary,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16.w),
        borderRadius: 12.r,
      );
    }
  }

  void _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: AppTheme.onPrimary,
              onSurface: AppTheme.onBackground,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        selectedStartTime = null;
        selectedEndTime = null;
      });
    }
  }

  List<String> _getAvailableEndTimes(List<String> availableHours, List<String> bookedHours) {
    if (selectedStartTime == null) return [];

    final startIndex = availableHours.indexOf(selectedStartTime!);
    if (startIndex == -1) return [];

    final endTimes = <String>[];
    for (int i = startIndex + 1; i < availableHours.length; i++) {
      final hour = availableHours[i];
      if (bookedHours.contains(hour)) break;
      
      final nextHour = _getNextHour(availableHours[i - 1]);
      if (nextHour == hour) {
        endTimes.add(hour);
      } else {
        break;
      }
    }

    return endTimes;
  }

  String _getNextHour(String hour) {
    final parts = hour.split(':');
    final currentHour = int.parse(parts[0]);
    final nextHour = currentHour + 1;
    return '${nextHour.toString().padLeft(2, '0')}:00';
  }

  double _calculateHours() {
    if (selectedStartTime == null || selectedEndTime == null) return 0;

    final startParts = selectedStartTime!.split(':');
    final endParts = selectedEndTime!.split(':');
    
    final startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
    final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);
    
    return (endMinutes - startMinutes) / 60;
  }
}