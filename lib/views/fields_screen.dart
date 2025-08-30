import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/fields_controller.dart';
import '../controllers/sports_controller.dart';
import '../core/theme.dart';
import 'field_detail_screen.dart';

class FieldsScreen extends StatelessWidget {
  const FieldsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fieldsController = Get.find<FieldsController>();
    final sportsController = Get.find<SportsController>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Sports Fields'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _showFilterBottomSheet(context, fieldsController, sportsController);
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchAndFilter(fieldsController, sportsController),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => fieldsController.refreshFields(),
                child: Obx(() {
                  if (fieldsController.isLoading) {
                    return _buildLoadingList();
                  }

                  final fields = fieldsController.filteredFields;

                  if (fields.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(20.w),
                    itemCount: fields.length,
                    itemBuilder: (context, index) {
                      final field = fields[index];
                      return _buildFieldCard(field, fieldsController);
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter(FieldsController fieldsController, SportsController sportsController) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Container(
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
                hintText: 'Search fields...',
                prefixIcon: Icon(
                  Icons.search,
                  color: AppTheme.onBackground.withOpacity(0.5),
                  size: 20.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              ),
              onChanged: (value) => fieldsController.searchFields(value),
            ),
          ),
          SizedBox(height: 16.h),
          Obx(() {
            final selectedSport = sportsController.selectedSport;
            if (selectedSport == null) return const SizedBox.shrink();

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedSport.icon,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    selectedSport.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () {
                      sportsController.clearSelection();
                      fieldsController.clearFilters();
                    },
                    child: Icon(
                      Icons.close,
                      size: 18.sp,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFieldCard(field, FieldsController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          controller.selectField(field.id);
          Get.to(() => const FieldDetailScreen());
        },
        borderRadius: BorderRadius.circular(20.r),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              child: Container(
                height: 160.h,
                width: double.infinity,
                color: Colors.grey[300],
                child: field.images.isNotEmpty
                    ? Image.network(
                        field.images.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppTheme.surfaceColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.sports,
                                size: 48.sp,
                                color: AppTheme.onBackground.withOpacity(0.3),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Image not available',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppTheme.onBackground.withOpacity(0.5),
                                ),
                              ),
                            ],
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
                              size: 48.sp,
                              color: AppTheme.onBackground.withOpacity(0.3),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'No image available',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppTheme.onBackground.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          field.name,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.onBackground,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: field.isActive
                              ? AppTheme.primaryColor.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          field.isActive ? 'AVAILABLE' : 'CLOSED',
                          style: TextStyle(
                            fontSize: 10.sp,
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    field.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.onBackground.withOpacity(0.8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 16.h),
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
                        ' (${field.reviewCount} reviews)',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTheme.onBackground.withOpacity(0.6),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Rp ${field.pricePerHour.toInt()}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      Text(
                        '/hour',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTheme.onBackground.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: field.facilities.take(3).map<Widget>((facility) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        facility,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppTheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 3,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(bottom: 16.h),
        height: 300.h,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_outlined,
            size: 80.sp,
            color: AppTheme.onBackground.withOpacity(0.3),
          ),
          SizedBox(height: 16.h),
          Text(
            'No fields found',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.onBackground.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.onBackground.withOpacity(0.5),
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              Get.find<FieldsController>().clearFilters();
              Get.find<SportsController>().clearSelection();
            },
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, FieldsController fieldsController, SportsController sportsController) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.3,
          builder: (context, scrollController) => Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppTheme.onBackground.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Filter Fields',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24.h),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sport Category',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Obx(() => Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: sportsController.sports.map((sport) {
                            final isSelected = sportsController.selectedSportId == sport.id;
                            return FilterChip(
                              selected: isSelected,
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(sport.icon),
                                  SizedBox(width: 4.w),
                                  Text(sport.name),
                                ],
                              ),
                              onSelected: (selected) {
                                if (selected) {
                                  sportsController.selectSport(sport.id);
                                  fieldsController.filterBySport(sport.id);
                                } else {
                                  sportsController.clearSelection();
                                  fieldsController.clearFilters();
                                }
                              },
                              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                              checkmarkColor: AppTheme.primaryColor,
                            );
                          }).toList(),
                        )),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          sportsController.clearSelection();
                          fieldsController.clearFilters();
                          Get.back();
                        },
                        child: const Text('Clear All'),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        child: const Text('Apply'),
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
}