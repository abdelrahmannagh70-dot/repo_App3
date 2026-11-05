import 'package:app3/features/presentaion/cubit/cubit/home_cubit.dart';
import 'package:app3/features/welcome/presentaion/home/home_app_bar.dart';
import 'package:app3/features/welcome/presentaion/home/widgets/book_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:app3/features/welcome/presentaion/slider/widgets/home_slider.dart';

import '../../../auth/data/models/book_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          // الـ BlocListener لازم يلف الـ CustomScrollView (مش جواه)
          child: BlocListener<HomeCubit, HomeState>(
            listenWhen: (previous, current) =>
            current is AddToCartLoading ||
                current is AddToCartSuccess ||
                current is AddToCartError,
            listener: (context, state) {
              if (state is AddToCartLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                  const Center(child: CircularProgressIndicator()),
                );
              } else if (state is AddToCartSuccess) {
                Navigator.of(context, rootNavigator: true).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Product added successfully")),
                );
              } else if (state is AddToCartError) {
                Navigator.of(context, rootNavigator: true).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to add product")),
                );
              }
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeAppBar(),
                      20.verticalSpace,
                      const HomeSlider(),
                      20.verticalSpace,
                      Text(
                        "Best Seller",
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      15.verticalSpace,
                    ],
                  ),
                ),

                BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (previous, current) =>
                  current is GetBestSellerLoading ||
                      current is GetBestSellerSuccess ||
                      current is GetBestSellerError,
                  builder: (context, state) {
                    if (state is GetBestSellerLoading) {
                      return SliverToBoxAdapter(
                        child: Skeletonizer(
                          enabled: true,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: .52,
                              mainAxisSpacing: 14.h,
                              crossAxisSpacing: 18.w,
                            ),
                            itemBuilder: (context, index) {
                              return BookItem(
                                products: Products(
                                  name: "Book Name",
                                  price: "322",
                                  image: "",
                                ),
                              );
                            },
                            itemCount: 8,
                          ),
                        ),
                      );
                    } else if (state is GetBestSellerSuccess) {
                      final products = state.products ?? [];

                      if (products.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: Center(child: Text("No books found")),
                        );
                      }

                      return SliverGrid(
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: .52,
                          mainAxisSpacing: 14.h,
                          crossAxisSpacing: 18.w,
                        ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return BookItem(products: products[index]);
                        }, childCount: products.length),
                      );
                    } else if (state is GetBestSellerError) {
                      return const SliverToBoxAdapter(
                        child: Center(child: Text("Something went wrong")),
                      );
                    }

                    return const SliverToBoxAdapter(child: SizedBox());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}