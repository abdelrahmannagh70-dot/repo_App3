import 'package:app3/core/themes/app_colors.dart';
import 'package:app3/features/cart/preentaion/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartErrorView extends StatelessWidget {
  final String? message;

  const CartErrorView({super.key, this.message});

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
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.wifi_off_rounded,
                  size: 48.sp,
                  color: const Color(0xFFE53935),
                ),
              ),
            ),
            20.verticalSpace,
            Text(
              "Unable to Load Cart",
              style: TextStyle(
                fontFamily: 'DM',
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            8.verticalSpace,
            Text(
              message ??
                  "Something went wrong while fetching your cart. Please check your internet connection and try again.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.darkGrayColor,
                height: 1.4,
              ),
            ),
            24.verticalSpace,
            ElevatedButton.icon(
              onPressed: () {
                context.read<CartCubit>().getCartData();
              },
              icon: Icon(Icons.refresh_rounded, size: 18.sp, color: Colors.white),
              label: Text(
                "Try Again",
                style: TextStyle(
                  fontFamily: 'DM',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
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

