import 'package:app3/core/routes/app_route.dart';
import 'package:app3/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartEmptyView extends StatelessWidget {
  const CartEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: AppColors.mainColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 58.sp,
                  color: AppColors.mainColor,
                ),
              ),
            ),
            24.verticalSpace,
            Text(
              "Your Cart is Empty",
              style: TextStyle(
                fontFamily: 'DM',
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            10.verticalSpace,
            Text(
              "Looks like you haven't added any books yet.\nExplore our catalog and find your next favorite read!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.darkGrayColor,
                height: 1.5,
              ),
            ),
            28.verticalSpace,
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.buttonNavBarScreen,
                  (route) => false,
                );
              },
              icon: Icon(Icons.arrow_back_rounded, size: 18.sp, color: Colors.white),
              label: Text(
                "Explore Books",
                style: TextStyle(
                  fontFamily: 'DM',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

