import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/fields_controller.dart';
import '../core/theme.dart';
import 'booking_form_screen.dart';
import 'field_calendar_screen.dart';

class FieldDetailScreen extends StatelessWidget {
  const FieldDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fieldsController = Get.find<FieldsController>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        final field = fieldsController.selectedField;
        
        if (field == null) {
          return const Center(
            child: Text('Field not found'),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300.h,
              pinned: true,
              backgroundColor: AppTheme.primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    field.images.isNotEmpty
                        ? PageView.builder(
                            itemCount: field.images.length,
                            itemBuilder: (context, index) => Image.network(
                              field.images[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: AppTheme.surfaceColor,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.sports,
                                      size: 80.sp,
                                      color: AppTheme.onBackground.withOpacity(0.3),
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      'Image not available',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppTheme.onBackground.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: AppTheme.surfaceColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.sports,
                                  size: 80.sp,
                                  color: AppTheme.onBackground.withOpacity(0.3),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'No images available',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: AppTheme.onBackground.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    if (field.images.length > 1)
                      Positioned(
                        bottom: 16.h,
                        right: 16.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Text(
                            '${field.images.length} photos',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              leading: Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppTheme.onBackground,
                    size: 20.sp,
                  ),
                ),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: IconButton(
                    onPressed: () => Get.to(() => const FieldCalendarScreen()),
                    icon: Icon(
                      Icons.calendar_month,
                      color: AppTheme.onBackground,
                      size: 20.sp,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: IconButton(
                    onPressed: () {
                      // TODO: Add to favorites
                    },
                    icon: Icon(
                      Icons.favorite_border,
                      color: AppTheme.onBackground,
                      size: 20.sp,
                    ),
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldHeader(field),
                    SizedBox(height: 20.h),
                    _buildDescription(field),
                    SizedBox(height: 20.h),
                    _buildFacilities(field),
                    SizedBox(height: 20.h),
                    _buildLocation(field),
                    SizedBox(height: 20.h),
                    _buildAvailableHours(field),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      bottomSheet: Obx(() {
        final field = fieldsController.selectedField;
        if (field == null) return const SizedBox.shrink();
        
        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price per hour',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.onBackground.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      'Rp ${field.pricePerHour.toInt()}',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: field.isActive
                        ? () => Get.to(() => const BookingFormScreen())
                        : null,
                    child: Text(
                      field.isActive ? 'Book Now' : 'Closed',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFieldHeader(field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                field.name,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.onBackground,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: field.isActive
                    ? AppTheme.primaryColor.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                field.isActive ? 'AVAILABLE' : 'CLOSED',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: field.isActive
                      ? AppTheme.primaryColor
                      : Colors.red,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 16.sp,
              color: AppTheme.onBackground.withOpacity(0.6),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                field.address,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.onBackground.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Icon(
              Icons.star,
              size: 18.sp,
              color: Colors.amber,
            ),
            SizedBox(width: 4.w),
            Text(
              field.rating.toString(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.onBackground,
              ),
            ),
            Flexible(
              child: Text(
                ' (${field.reviewCount} reviews)',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.onBackground.withOpacity(0.6),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: TextButton.icon(
                onPressed: () {
                  // TODO: Show reviews
                },
                icon: Icon(
                  Icons.reviews,
                  size: 16.sp,
                ),
                label: const Text('Reviews'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.onBackground,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          field.description,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.onBackground.withOpacity(0.8),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFacilities(field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Facilities',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.onBackground,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: field.facilities.map<Widget>((facility) => Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getFacilityIcon(facility),
                  size: 16.sp,
                  color: AppTheme.primaryColor,
                ),
                SizedBox(width: 6.w),
                Text(
                  facility,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.onBackground,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildLocation(field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.onBackground,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Container(
                height: 120.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map,
                        size: 40.sp,
                        color: AppTheme.onBackground.withOpacity(0.5),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Map View',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTheme.onBackground.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16.sp,
                    color: AppTheme.primaryColor,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      field.address,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppTheme.onBackground,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvailableHours(field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Hours',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.onBackground,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: field.availableHours.entries.map<Widget>((entry) {
              final day = entry.key;
              final hours = entry.value;
              
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onBackground,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Wrap(
                        spacing: 6.w,
                        runSpacing: 6.h,
                        children: hours.map<Widget>((hour) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            hour,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppTheme.onBackground,
                            ),
                          ),
                        )).toList(),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  IconData _getFacilityIcon(String facility) {
    switch (facility.toLowerCase()) {
      case 'parking':
        return Icons.local_parking;
      case 'changing room':
        return Icons.meeting_room;
      case 'shower':
        return Icons.shower;
      case 'canteen':
        return Icons.restaurant;
      case 'sound system':
        return Icons.volume_up;
      case 'air conditioning':
        return Icons.ac_unit;
      case 'equipment rental':
        return Icons.sports_tennis;
      case 'pro shop':
        return Icons.shopping_bag;
      case 'coaching':
        return Icons.sports;
      case 'clubhouse':
        return Icons.home;
      case 'restaurant':
        return Icons.restaurant_menu;
      default:
        return Icons.check_circle;
    }
  }
}