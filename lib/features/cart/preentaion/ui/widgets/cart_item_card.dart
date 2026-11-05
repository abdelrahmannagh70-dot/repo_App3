import 'package:app3/core/routes/app_route.dart';
import 'package:app3/core/themes/app_colors.dart';
import 'package:app3/features/cart/data/model/cart_model.dart';
import 'package:app3/features/cart/preentaion/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;

  const CartItemCard({super.key, required this.item});

  void _onTapProduct(BuildContext context) {
    if (item.itemProductId != null) {
      Navigator.of(context).pushNamed(
        AppRoutes.bookDetailsScreen,
        arguments: item.itemProductId,
      );
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          "Remove Item",
          style: TextStyle(
            fontFamily: 'DM',
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Are you sure you want to remove \"${item.itemProductName ?? 'this item'}\" from your cart?",
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.darkGrayColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: AppColors.grayColor,
                fontSize: 14.sp,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              if (item.itemId != null) {
                context.read<CartCubit>().removeFromCart(cartItemId: item.itemId!);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              "Remove",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _increment(BuildContext context) {
    final currentQty = item.itemQuantity ?? 1;
    final maxStock = item.itemProductStock;

    if (maxStock != null && currentQty >= maxStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Maximum available stock is $maxStock"),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    HapticFeedback.lightImpact();
    if (item.itemId != null) {
      context.read<CartCubit>().updateQuantity(
            cartItemId: item.itemId!,
            quantity: currentQty + 1,
          );
    }
  }

  void _decrement(BuildContext context) {
    final currentQty = item.itemQuantity ?? 1;

    if (currentQty <= 1) {
      _showDeleteDialog(context);
      return;
    }

    HapticFeedback.lightImpact();
    if (item.itemId != null) {
      context.read<CartCubit>().updateQuantity(
            cartItemId: item.itemId!,
            quantity: currentQty - 1,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasDiscount =
        item.itemProductDiscount != null && (item.itemProductDiscount ?? 0) > 0;
    final displayPrice = item.itemProductPriceAfterDiscount != null
        ? "\$${item.itemProductPriceAfterDiscount!.toStringAsFixed(2)}"
        : (item.itemProductPrice != null ? "\$${item.itemProductPrice}" : "");

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book Thumbnail
          GestureDetector(
            onTap: () => _onTapProduct(context),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    width: 78.w,
                    height: 108.h,
                    color: AppColors.bgColor,
                    child: item.itemProductImage != null &&
                            item.itemProductImage!.isNotEmpty
                        ? Image.network(
                            item.itemProductImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Center(
                              child: Icon(
                                Icons.menu_book_rounded,
                                size: 32.sp,
                                color: AppColors.grayColor,
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.menu_book_rounded,
                              size: 32.sp,
                              color: AppColors.grayColor,
                            ),
                          ),
                  ),
                ),
                if (hasDiscount)
                  Positioned(
                    top: 6.h,
                    left: 6.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        "-${item.itemProductDiscount}%",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          14.horizontalSpace,

          // Item Details & Controls
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Delete button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _onTapProduct(context),
                        child: Text(
                          item.itemProductName ?? "Book Title",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'DM',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => _showDeleteDialog(context),
                      borderRadius: BorderRadius.circular(20.r),
                      child: Padding(
                        padding: EdgeInsets.all(4.r),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: 20.sp,
                          color: const Color(0xFFE53935).withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
                6.verticalSpace,

                // Prices
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      displayPrice,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainColor,
                      ),
                    ),
                    if (hasDiscount && item.itemProductPrice != null) ...[
                      8.horizontalSpace,
                      Text(
                        "\$${item.itemProductPrice}",
                        style: TextStyle(
                          fontSize: 12.sp,
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.grayColor,
                        ),
                      ),
                    ],
                  ],
                ),
                10.verticalSpace,

                // Quantity and Item Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quantity Control
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgColor,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: AppColors.borderColor,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          _quantityButton(
                            icon: item.itemQuantity == 1
                                ? Icons.delete_outline_rounded
                                : Icons.remove_rounded,
                            iconColor: item.itemQuantity == 1
                                ? const Color(0xFFE53935)
                                : Colors.black87,
                            onTap: () => _decrement(context),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Text(
                              "${item.itemQuantity ?? 1}",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          _quantityButton(
                            icon: Icons.add_rounded,
                            iconColor: Colors.black87,
                            onTap: () => _increment(context),
                          ),
                        ],
                      ),
                    ),

                    // Item Total
                    if (item.itemTotal != null)
                      Text(
                        "Total: \$${item.itemTotal!.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGrayColor,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 16.sp,
          color: iconColor,
        ),
      ),
    );
  }
}

