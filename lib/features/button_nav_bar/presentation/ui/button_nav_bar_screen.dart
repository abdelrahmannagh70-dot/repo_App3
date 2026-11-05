import 'package:app3/core/themes/app_colors.dart';
import 'package:app3/features/cart/preentaion/cart_cubit.dart';
import 'package:app3/features/profile/data/presentation/profile_cubit.dart';
import 'package:app3/features/welcome/presentaion/home/home_screen.dart';
import 'package:app3/features/presentaion/cubit/cubit/home_cubit.dart';
import 'package:app3/features/welcome/presentaion/slider/slider_cubit.dart';


import 'package:app3/features/bookmark/bookmark_screen.dart';
import 'package:app3/features/cart/preentaion/ui/cart_screen.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../gen/assets.gen.dart';
import '../../../profile/data/presentation/ui/profile_screen.dart';

class ButtonNavBarScreen extends StatefulWidget {
  const ButtonNavBarScreen({super.key});

  @override
  State<ButtonNavBarScreen> createState() => _ButtonNavBarScreenState();
}

class _ButtonNavBarScreenState extends State<ButtonNavBarScreen> {
  int currentIndex = 0;

  late final List<Widget> screens = [
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit()..getBestSellerBox(),
        ),
        BlocProvider(
          create: (context) => SliderCubit()..getSliders(),
        ),
      ],
      child: const HomeScreen(),
    ),

    const BookmarkScreen(),


    BlocProvider(
  create: (context) => CartCubit()..getCartData(),
  child: CartScreen(),
),

    BlocProvider(
      create: (context) => ProfileCubit()..getProfileData(),
      child: ProfileScreen(),
    )

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,

      // ✅ IndexedStack بيحافظ على حالة كل شاشة (السكرول والبيانات)
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        backgroundColor: AppColors.bgColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.mainColor,
        unselectedItemColor: Colors.grey,
        items: [
          _buildItem(Assets.icons.home.svg, 0, "Home"),
          _buildItem(Assets.icons.bookmark.svg, 1, "BookMark"),
          _buildItem(Assets.icons.category.svg, 2, "Cart"),
          _buildItem(Assets.icons.profile.svg, 3, "Profile"),
        ],
      ),
    );
  }

  // ✅ دالة واحدة بدل ما نكرر نفس الكود 4 مرات
  BottomNavigationBarItem _buildItem(
      Widget Function({double? width, double? height, ColorFilter? colorFilter}) svg,
      int index,
      String label,
      ) {
    return BottomNavigationBarItem(
      icon: svg(
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          currentIndex == index ? AppColors.mainColor : Colors.black,
          BlendMode.srcIn,
        ),
      ),
      label: label,
    );
  }
}