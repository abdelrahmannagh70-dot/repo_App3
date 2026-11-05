import 'package:app3/core/themes/app_colors.dart';
import 'package:app3/features/cart/preentaion/cart_cubit.dart';
import 'package:app3/features/cart/preentaion/ui/widgets/cart_empty_view.dart';
import 'package:app3/features/cart/preentaion/ui/widgets/cart_error_view.dart';
import 'package:app3/features/cart/preentaion/ui/widgets/cart_item_card.dart';
import 'package:app3/features/cart/preentaion/ui/widgets/cart_skeleton_loading.dart';
import 'package:app3/features/cart/preentaion/ui/widgets/cart_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<CartCubit>();
      if (cubit.state is CartInitial) {
        cubit.getCartData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        title: Text(
          "My Cart",
          style: TextStyle(
            fontFamily: 'DM',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              final count = context.read<CartCubit>().currentCartData?.cartItems?.length ??
                  (state is GetCartSuccess ? state.cartData?.cartItems?.length ?? 0 : 0);

              if (count > 0) {
                return Center(
                  child: Container(
                    margin: EdgeInsets.only(right: 8.w),
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.mainColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: AppColors.mainColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      "$count ${count == 1 ? 'Item' : 'Items'}",
                      style: TextStyle(
                        fontFamily: 'DM',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkColor,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            tooltip: "Refresh Cart",
            icon: Icon(
              Icons.refresh_rounded,
              size: 22.sp,
              color: Colors.black87,
            ),
            onPressed: () {
              context.read<CartCubit>().getCartData();
            },
          ),
          8.horizontalSpace,
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {
            if (state is GetCartError && state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  backgroundColor: const Color(0xFFE53935),
                  duration: const Duration(seconds: 2),
                ),
              );
            }


            if (state is CartItemActionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: const Color(0xFFE53935),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<CartCubit>();
            final isItemUpdating = state is CartItemActionLoading;
            final cartData = state is GetCartSuccess
                ? state.cartData
                : cubit.currentCartData;

            if (state is GetCartLoading && cartData == null) {
              return const CartSkeletonLoading();
            }

            if (state is GetCartError && cartData == null) {
              return CartErrorView(message: state.message);
            }

            final items = cartData?.cartItems ?? [];

            if (items.isEmpty && !isItemUpdating) {
              return RefreshIndicator(
                color: AppColors.mainColor,
                onRefresh: () => cubit.getCartData(),
                child: const CartEmptyView(),
              );
            }

            final userName = cartData?.user?.userName;

            return Stack(
              children: [
                RefreshIndicator(
                  color: AppColors.mainColor,
                  onRefresh: () => cubit.getCartData(),
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    children: [
                      // User Greeting or items info header
                      if (userName != null && userName.isNotEmpty) ...[
                        Row(
                          children: [
                            Text(
                              "Welcome, ",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.darkGrayColor,
                              ),
                            ),
                            Text(
                              userName,
                              style: TextStyle(
                                fontFamily: 'DM',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkColor,
                              ),
                            ),
                          ],
                        ),
                        10.verticalSpace,
                      ],

                      // Cart Items List
                      ...items.map((item) => CartItemCard(item: item)),

                      12.verticalSpace,

                      // Order Summary & Checkout
                      if (cartData != null)
                        CartSummary(cartData: cartData),

                      20.verticalSpace,
                    ],
                  ),
                ),

                // Subtle progress indicator when updating quantity or removing item
                if (isItemUpdating)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.mainColor,
                      ),
                      minHeight: 3.h,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}