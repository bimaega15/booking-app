import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/sports_controller.dart';
import '../controllers/fields_controller.dart';
import '../controllers/booking_controller.dart';
import '../models/booking.dart';
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
                      _buildSearchBar(context),
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

  Widget _buildSearchBar(BuildContext context) {
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
          suffixIcon: GestureDetector(
            onTap: () => _showFilterBottomSheet(context),
            child: Container(
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
            children: popularFields.map<Widget>((field) => _buildFieldCard(field)).toList(),
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
              BookingStatusHelper.getStatusName(booking.status).toUpperCase(),
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

  Color _getStatusColor(BookingStatus status) {
    switch (BookingStatusHelper.getStatusName(status)) {
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

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final fieldsController = Get.find<FieldsController>();
  
  String selectedLocation = 'All Locations';
  RangeValues priceRange = const RangeValues(50000, 500000);
  List<String> selectedTimes = [];
  
  final List<String> locations = [
    'All Locations',
    'Jakarta Selatan',
    'Jakarta Utara', 
    'Jakarta Barat',
    'Jakarta Timur',
    'Jakarta Pusat',
    'Tangerang',
    'Bekasi',
    'Depok',
  ];
  
  final List<String> timeSlots = [
    '06:00 - 09:00',
    '09:00 - 12:00', 
    '12:00 - 15:00',
    '15:00 - 18:00',
    '18:00 - 21:00',
    '21:00 - 24:00',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: AppTheme.onBackground.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Fields',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.onBackground,
                  ),
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Divider(color: AppTheme.onBackground.withOpacity(0.1)),
          
          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationFilter(),
                  SizedBox(height: 24.h),
                  _buildPriceFilter(),
                  SizedBox(height: 24.h),
                  _buildTimeFilter(),
                ],
              ),
            ),
          ),
          
          // Apply Button
          Padding(
            padding: EdgeInsets.all(24.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.onBackground,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.onBackground.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedLocation,
              isExpanded: true,
              items: locations.map((String location) {
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(
                    location,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.onBackground,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLocation = newValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range per Hour',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.onBackground,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Rp ${priceRange.start.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} - Rp ${priceRange.end.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        RangeSlider(
          values: priceRange,
          min: 25000,
          max: 1000000,
          divisions: 39,
          activeColor: AppTheme.primaryColor,
          inactiveColor: AppTheme.primaryColor.withOpacity(0.3),
          onChanged: (RangeValues values) {
            setState(() {
              priceRange = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTimeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Time Slots',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.onBackground,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: timeSlots.map((time) {
            final isSelected = selectedTimes.contains(time);
            return InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedTimes.remove(time);
                  } else {
                    selectedTimes.add(time);
                  }
                });
              },
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected ? AppTheme.primaryColor : AppTheme.onBackground.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isSelected ? AppTheme.onPrimary : AppTheme.onBackground,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _resetFilters() {
    setState(() {
      selectedLocation = 'All Locations';
      priceRange = const RangeValues(50000, 500000);
      selectedTimes.clear();
    });
  }

  void _applyFilters() {
    fieldsController.applyFilters(
      location: selectedLocation == 'All Locations' ? null : selectedLocation,
      minPrice: priceRange.start,
      maxPrice: priceRange.end,
      timeSlots: selectedTimes.isEmpty ? null : selectedTimes,
    );
    
    Get.back();
    
    Get.snackbar(
      'Filters Applied',
      'Found ${fieldsController.filteredFields.length} fields matching your criteria',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.primaryColor,
      colorText: AppTheme.onPrimary,
      margin: EdgeInsets.all(16.w),
      borderRadius: 12.r,
    );
  }
}