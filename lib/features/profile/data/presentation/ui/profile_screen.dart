import 'package:app3/features/profile/data/presentation/profile_cubit.dart';
import 'package:app3/features/profile/data/presentation/ui/widgets/profile_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            const ProfileAppBar(),
            20.verticalSpace,
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is GetProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetProfileSuccess) {

                  final user = state.profileDate;

                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 35.r,
                        backgroundImage:Image.network(state.profileDate?.image??"").image,
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(state.profileDate?.name??""),
                            Text(state.profileDate?.email??""),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Text("Error");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
