import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/sports_controller.dart';
import '../controllers/fields_controller.dart';
import '../controllers/booking_controller.dart';
import '../core/theme.dart';
import 'sports_selection_screen.dart';
import 'field_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sportsController = Get.find<SportsController>();
    final fieldsController = Get.find<FieldsController>();
    final bookingController = Get.find<BookingController>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              sportsController.refreshSports(),
              fieldsController.refreshFields(),
              bookingController.refreshBookings(),
            ]);
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      SizedBox(height: 24.h),
                      _buildSearchBar(),
                      SizedBox(height: 24.h),
                      _buildQuickStats(bookingController),
                      SizedBox(height: 24.h),
                      _buildSportsCategories(sportsController),
                      SizedBox(height: 24.h),
                      _buildPopularFields(fieldsController),
                      SizedBox(height: 24.h),
                      _buildUpcomingBookings(bookingController),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, Sports Lover! 👋',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.onBackground,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Find and book your perfect sports field',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.onBackground.withOpacity(0.7),
              ),
            ),
          ],
        ),
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: AppTheme.primaryColor,
            size: 24.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
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
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search fields, sports, locations...',
          prefixIcon: Icon(
            Icons.search,
            color: AppTheme.onBackground.withOpacity(0.5),
            size: 20.sp,
          ),
          suffixIcon: Container(
            margin: EdgeInsets.all(8.w),
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.tune,
              color: AppTheme.onPrimary,
              size: 16.sp,
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        ),
        onChanged: (value) {
          Get.find<FieldsController>().searchFields(value);
        },
      ),
    );
  }

  Widget _buildQuickStats(BookingController controller) {
    return Obx(() {
      final upcomingCount = controller.upcomingBookings.length;
      final completedCount = controller.pastBookings.length;
      
      return Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Upcoming',
              upcomingCount.toString(),
              Icons.event_available,
              AppTheme.secondaryColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              'Completed',
              completedCount.toString(),
              Icons.check_circle,
              AppTheme.primaryColor,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.onBackground.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSportsCategories(SportsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sports Categories',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.onBackground,
              ),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => const SportsSelectionScreen());
              },
              child: Text(
                'See All',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Obx(() {
          if (controller.isLoading) {
            return SizedBox(
              height: 100.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) => _buildSportCategoryShimmer(),
              ),
            );
          }
          
          return SizedBox(
            height: 100.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.sports.take(6).length,
              itemBuilder: (context, index) {
                final sport = controller.sports[index];
                return _buildSportCategory(sport.name, sport.icon, () {
                  controller.selectSport(sport.id);
                  Get.find<FieldsController>().filterBySport(sport.id);
                  Get.to(() => const SportsSelectionScreen());
                });
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSportCategory(String name, String emoji, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80.w,
        margin: EdgeInsets.only(right: 12.w),
        child: Column(
          children: [
            Container(
              width: 60.w,
              height: 60.w,
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
              child: Center(
                child: Text(
                  emoji,
                  style: TextStyle(fontSize: 24.sp),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              name,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.onBackground,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSportCategoryShimmer() {
    return Container(
      width: 80.w,
      margin: EdgeInsets.only(right: 12.w),
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: 60.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularFields(FieldsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Fields',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.onBackground,
          ),
        ),
        SizedBox(height: 16.h),
        Obx(() {
          if (controller.isLoading) {
            return Column(
              children: List.generate(2, (index) => _buildFieldCardShimmer()),
            );
          }
          
          final popularFields = controller.fields.take(3).toList();
          
          return Column(
            children: popularFields.map((field) => _buildFieldCard(field)).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildFieldCard(field) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
      child: InkWell(
        onTap: () {
          Get.find<FieldsController>().selectField(field.id);
          Get.to(() => const FieldDetailScreen());
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  width: 80.w,
                  height: 80.w,
                  color: Colors.grey[300],
                  child: field.images.isNotEmpty
                      ? Image.network(
                          field.images.first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: AppTheme.surfaceColor,
                            child: Icon(
                              Icons.image,
                              color: AppTheme.onBackground.withOpacity(0.5),
                            ),
                          ),
                        )
                      : Container(
                          color: AppTheme.surfaceColor,
                          child: Icon(
                            Icons.sports,
                            color: AppTheme.onBackground.withOpacity(0.5),
                          ),
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14.sp,
                          color: AppTheme.onBackground.withOpacity(0.6),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            field.location,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppTheme.onBackground.withOpacity(0.6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16.sp,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          field.rating.toString(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onBackground,
                          ),
                        ),
                        Text(
                          ' (${field.reviewCount})',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppTheme.onBackground.withOpacity(0.6),
                          ),
                        ),
                        const Spacer(),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldCardShimmer() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16.r),
      ),
      height: 112.h,
    );
  }

  Widget _buildUpcomingBookings(BookingController controller) {
    return Obx(() {
      final upcomingBookings = controller.upcomingBookings.take(3).toList();
      
      if (upcomingBookings.isEmpty) {
        return const SizedBox.shrink();
      }
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Bookings',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.onBackground,
            ),
          ),
          SizedBox(height: 16.h),
          ...upcomingBookings.map((booking) => _buildBookingCard(booking)),
        ],
      );
    });
  }

  Widget _buildBookingCard(booking) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.event,
              color: AppTheme.primaryColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Field Booking',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.onBackground,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${booking.bookingDate.day}/${booking.bookingDate.month} • ${booking.startTime} - ${booking.endTime}',
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
                fontWeight: FontWeight.w600,
                color: _getStatusColor(booking.status),
              ),
            ),
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
        return AppTheme.errorColor;
      case 'completed':
        return Colors.green;
      default:
        return AppTheme.onBackground;
    }
  }
}