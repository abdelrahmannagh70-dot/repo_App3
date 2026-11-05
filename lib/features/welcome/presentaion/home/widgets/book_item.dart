import 'package:app3/core/routes/app_route.dart';
import 'package:app3/core/themes/app_colors.dart';
import 'package:app3/features/auth/data/models/book_model.dart';
import 'package:app3/features/presentaion/cubit/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookItem extends StatelessWidget {
  final Products? products;

  const BookItem({super.key, this.products});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.bookDetailsScreen,
          arguments: products?.id,
        );
      },

      child: Container(
        padding: EdgeInsets.all(10.r),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: AppColors.borderColor,
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // Book Image
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),

                child: Image.network(
                  products?.image ?? "",

                  width: double.infinity,

                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(
                          Icons.book,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            12.verticalSpace,

            // Book Name
            Text(
              products?.name ?? "Book Name",

              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),

            8.verticalSpace,

            // Price and Cart Button
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [

                  Text(
                    products?.price ?? "0",

                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Container(
                    width: 38.w,
                    height: 38.h,

                    decoration: BoxDecoration(
                      color: AppColors.darkColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),

                    child: IconButton(
                      padding: EdgeInsets.zero,

                      onPressed: () {
                        context.read<HomeCubit>().addToCart(products?.id ?? 0);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Added to cart"),
                          ),
                        );
                      },

                      icon: const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

          ],
        ),
      ),
    );
  }
}