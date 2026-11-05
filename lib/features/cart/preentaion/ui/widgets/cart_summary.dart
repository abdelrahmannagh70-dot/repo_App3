import 'package:app3/core/themes/app_colors.dart';
import 'package:app3/core/widget/App_button.dart';
import 'package:app3/features/cart/data/model/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartSummary extends StatefulWidget {
  final CartDataModel cartData;

  const CartSummary({super.key, required this.cartData});

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  final TextEditingController _promoController = TextEditingController();
  bool _isPromoApplied = false;
  double _discountAmount = 0.0;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final code = _promoController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    FocusScope.of(context).unfocus();
    HapticFeedback.mediumImpact();

    if (code == "BOOK10" || code == "DISCOUNT10" || code == "PROMO") {
      setState(() {
        _isPromoApplied = true;
        final rawTotal = double.tryParse(widget.cartData.total ?? "0") ?? 0;
        _discountAmount = rawTotal * 0.10;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Promo code '$code' applied! (10% off)"),
          backgroundColor: const Color(0xFF2E7D32),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid promo code. Try 'BOOK10'"),
          backgroundColor: Color(0xFFE53935),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showCheckoutSheet() {
    final rawTotal = double.tryParse(widget.cartData.total ?? "0") ?? 0;
    final finalTotal = (rawTotal - _discountAmount).clamp(0, double.infinity);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            20.verticalSpace,
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.mainColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                size: 48.sp,
                color: AppColors.mainColor,
              ),
            ),
            16.verticalSpace,
            Text(
              "Checkout Confirmation",
              style: TextStyle(
                fontFamily: 'DM',
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            8.verticalSpace,
            Text(
              "You are about to checkout ${widget.cartData.cartItems?.length ?? 0} item(s) for a total of \$${finalTotal.toStringAsFixed(2)}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.darkGrayColor,
              ),
            ),
            24.verticalSpace,
            AppButton(
              titel: "Confirm Order",
              onTap: () {
                Navigator.of(sheetCtx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Order placed successfully! 🎉"),
                    backgroundColor: Color(0xFF2E7D32),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
            ),
            12.verticalSpace,
            TextButton(
              onPressed: () => Navigator.of(sheetCtx).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.grayColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rawTotal = double.tryParse(widget.cartData.total ?? "0") ?? 0;
    final finalTotal = (rawTotal - _discountAmount).clamp(0, double.infinity);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Summary",
            style: TextStyle(
              fontFamily: 'DM',
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          14.verticalSpace,

          // Promo code field
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: AppColors.bgColor,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.discount_outlined,
                        size: 18.sp,
                        color: AppColors.grayColor,
                      ),
                      8.horizontalSpace,
                      Expanded(
                        child: TextField(
                          controller: _promoController,
                          textCapitalization: TextCapitalization.characters,
                          style: TextStyle(fontSize: 13.sp),
                          decoration: InputDecoration(
                            hintText: "Promo Code (e.g. BOOK10)",
                            hintStyle: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.grayColor,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              8.horizontalSpace,
              InkWell(
                onTap: _applyPromo,
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  height: 44.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    _isPromoApplied ? "Applied" : "Apply",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          16.verticalSpace,

          // Subtotal
          _summaryRow(
            label: "Subtotal",
            value: "\$${rawTotal.toStringAsFixed(2)}",
          ),
          10.verticalSpace,

          // Discount if applied
          if (_isPromoApplied) ...[
            _summaryRow(
              label: "Promo Discount (10%)",
              value: "-\$${_discountAmount.toStringAsFixed(2)}",
              valueColor: const Color(0xFF2E7D32),
            ),
            10.verticalSpace,
          ],

          // Shipping
          _summaryRow(
            label: "Shipping",
            value: "FREE",
            valueColor: const Color(0xFF2E7D32),
            isBadge: true,
          ),
          14.verticalSpace,

          Divider(color: AppColors.borderColor, thickness: 1),
          12.verticalSpace,

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Amount",
                style: TextStyle(
                  fontFamily: 'DM',
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                "\$${finalTotal.toStringAsFixed(2)}",
                style: TextStyle(
                  fontFamily: 'DM',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkColor,
                ),
              ),
            ],
          ),
          20.verticalSpace,

          // Checkout Button
          AppButton(
            titel: "Proceed to Checkout",
            onTap: _showCheckoutSheet,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow({
    required String label,
    required String value,
    Color? valueColor,
    bool isBadge = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.darkGrayColor,
          ),
        ),
        isBadge
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
              )
            : Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? Colors.black87,
                ),
              ),
      ],
    );
  }
}

