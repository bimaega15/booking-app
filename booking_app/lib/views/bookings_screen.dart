import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/booking_controller.dart';
import '../controllers/fields_controller.dart';
import '../core/theme.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final bookingController = Get.find<BookingController>();
  final fieldsController = Get.find<FieldsController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.onBackground.withOpacity(0.6),
          labelStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUpcomingBookings(),
          _buildPastBookings(),
        ],
      ),
    );
  }

  Widget _buildUpcomingBookings() {
    return RefreshIndicator(
      onRefresh: () => bookingController.refreshBookings(),
      child: Obx(() {
        if (bookingController.isLoading) {
          return _buildLoadingList();
        }

        final upcomingBookings = bookingController.upcomingBookings;

        if (upcomingBookings.isEmpty) {
          return _buildEmptyState(
            icon: Icons.event_available,
            title: 'No upcoming bookings',
            subtitle: 'Book a field to see your reservations here',
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(20.w),
          itemCount: upcomingBookings.length,
          itemBuilder: (context, index) {
            final booking = upcomingBookings[index];
            return _buildBookingCard(booking, showActions: true);
          },
        );
      }),
    );
  }

  Widget _buildPastBookings() {
    return RefreshIndicator(
      onRefresh: () => bookingController.refreshBookings(),
      child: Obx(() {
        if (bookingController.isLoading) {
          return _buildLoadingList();
        }

        final pastBookings = bookingController.pastBookings;

        if (pastBookings.isEmpty) {
          return _buildEmptyState(
            icon: Icons.history,
            title: 'No past bookings',
            subtitle: 'Your booking history will appear here',
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(20.w),
          itemCount: pastBookings.length,
          itemBuilder: (context, index) {
            final booking = pastBookings[index];
            return _buildBookingCard(booking, showActions: false);
          },
        );
      }),
    );
  }

  Widget _buildBookingCard(booking, {required bool showActions}) {
    final field = fieldsController.fields.firstWhereOrNull(
      (f) => f.id == booking.fieldId,
    );

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    _getStatusIcon(booking.status),
                    color: _getStatusColor(booking.status),
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        field?.name ?? 'Unknown Field',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.onBackground,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        field?.location ?? 'Unknown Location',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTheme.onBackground.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    booking.status.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(booking.status),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Date',
                    DateFormat('EEEE, dd MMMM yyyy').format(booking.bookingDate),
                  ),
                  SizedBox(height: 8.h),
                  _buildInfoRow(
                    Icons.access_time,
                    'Time',
                    '${booking.startTime} - ${booking.endTime}',
                  ),
                  SizedBox(height: 8.h),
                  _buildInfoRow(
                    Icons.payments,
                    'Total',
                    'Rp ${booking.totalPrice.toInt()}',
                  ),
                  if (booking.notes != null) ...[
                    SizedBox(height: 8.h),
                    _buildInfoRow(
                      Icons.note,
                      'Notes',
                      booking.notes!,
                    ),
                  ],
                ],
              ),
            ),
            if (showActions && booking.status.name == 'pending') ...[
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showCancelDialog(booking),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red),
                        foregroundColor: Colors.red,
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Show booking details or modify
                      },
                      child: Text(
                        'Details',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: AppTheme.onBackground.withOpacity(0.6),
        ),
        SizedBox(width: 8.w),
        SizedBox(
          width: 60.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.onBackground.withOpacity(0.6),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.onBackground,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 3,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(bottom: 16.h),
        height: 160.h,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80.sp,
            color: AppTheme.onBackground.withOpacity(0.3),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.onBackground.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.onBackground.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(status) {
    switch (status.name) {
      case 'confirmed':
        return AppTheme.primaryColor;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.green;
      default:
        return AppTheme.onBackground;
    }
  }

  IconData _getStatusIcon(status) {
    switch (status.name) {
      case 'confirmed':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'cancelled':
        return Icons.cancel;
      case 'completed':
        return Icons.done_all;
      default:
        return Icons.info;
    }
  }

  void _showCancelDialog(booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Cancel Booking',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.onBackground.withOpacity(0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Keep Booking'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              final success = await bookingController.cancelBooking(booking.id);
              if (success) {
                Get.snackbar(
                  'Success',
                  'Booking cancelled successfully',
                  backgroundColor: AppTheme.primaryColor,
                  colorText: AppTheme.onPrimary,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: EdgeInsets.all(16.w),
                  borderRadius: 12.r,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }
}