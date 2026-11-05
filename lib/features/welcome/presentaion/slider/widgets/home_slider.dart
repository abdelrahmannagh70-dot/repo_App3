import 'package:app3/features/welcome/presentaion/slider/slider_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app3/features/welcome/presentaion/slider/slider_cubit.dart';

class HomeSlider extends StatefulWidget {
  const HomeSlider({super.key});

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SliderCubit, SliderState>(
      builder: (context, state) {
        if (state is SliderLoading) {
          return Container(
            height: 150.h,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }

        if (state is SliderSuccess) {
          final sliders = state.sliders ?? [];

          if (sliders.isEmpty) {
            return const SizedBox();
          }

          return Column(
            children: [
              SizedBox(
                height: 150.h,
                child: PageView.builder(
                  itemCount: sliders.length,

                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },

                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),

                      child: Image.network(
                        sliders[index].image ?? "",
                        width: double.infinity,
                        fit: BoxFit.cover,

                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image_not_supported),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              12.verticalSpace,

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  sliders.length,
                      (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: currentIndex == index ? 20.w : 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: currentIndex == index
                            ? Colors.amberAccent
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }

        if (state is SliderError) {
          return const Center(
            child: Text("Couldn't load banners"),
          );
        }

        return const SizedBox();
      },
    );
  }
}