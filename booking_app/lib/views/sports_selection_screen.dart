import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/sports_controller.dart';
import '../controllers/fields_controller.dart';
import '../core/theme.dart';
import 'fields_screen.dart';

class SportsSelectionScreen extends StatelessWidget {
  const SportsSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sportsController = Get.find<SportsController>();
    final fieldsController = Get.find<FieldsController>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Choose Your Sport'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What sport would you like to play today?',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppTheme.onBackground.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: Obx(() {
                  if (sportsController.isLoading) {
                    return _buildLoadingGrid();
                  }

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                    ),
                    itemCount: sportsController.sports.length,
                    itemBuilder: (context, index) {
                      final sport = sportsController.sports[index];
                      final isSelected = sportsController.selectedSportId == sport.id;
                      
                      return _buildSportCard(
                        sport: sport,
                        isSelected: isSelected,
                        onTap: () {
                          sportsController.selectSport(sport.id);
                          fieldsController.filterBySport(sport.id);
                          
                          Get.snackbar(
                            'Sport Selected',
                            'Showing fields for ${sport.name}',
                            duration: const Duration(seconds: 1),
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppTheme.primaryColor,
                            colorText: AppTheme.onPrimary,
                            margin: EdgeInsets.all(16.w),
                            borderRadius: 12.r,
                          );
                          
                          Future.delayed(const Duration(milliseconds: 800), () {
                            Get.off(() => const FieldsScreen());
                          });
                        },
                      );
                    },
                  );
                }),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    fieldsController.clearFilters();
                    Get.to(() => const FieldsScreen());
                  },
                  child: Text(
                    'Show All Fields',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSportCard({
    required sport,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primaryColor.withOpacity(0.1)
              : AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected 
                ? AppTheme.primaryColor
                : AppTheme.onBackground.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppTheme.primaryColor.withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryColor.withOpacity(0.2)
                      : AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Center(
                  child: Text(
                    sport.icon,
                    style: TextStyle(
                      fontSize: 32.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                sport.name,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.onBackground,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              Text(
                sport.description,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.onBackground.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 4.w,
                runSpacing: 4.h,
                children: sport.tags.take(2).map((tag) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryColor.withOpacity(0.2)
                        : AppTheme.onBackground.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.onBackground.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
      ),
      itemCount: 8,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
    );
  }
}