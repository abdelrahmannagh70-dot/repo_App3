import 'package:app3/core/routes/app_route.dart';
import 'package:app3/core/services/local/local_Helper.dart';
import 'package:app3/core/themes/APP_text_Style.dart';
import 'package:app3/core/themes/app_colors.dart';
import 'package:app3/core/utils/app.constans.dart';
import 'package:app3/core/widget/App_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          "Profile",
          style: AppTextStyle.font30Regular.copyWith(
            fontSize: 24.sp,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () {
              showDialog(context: context, builder: (context)=>AlertDialog(
                title: Text("Are you sure to Logout"),
                content: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(child: AppButton(titel: "Confirm",
                      bgColor: Colors.transparent,
                      textColor: Colors.black,
                        onTap: (){
                        localHelper.prefs?.remove(AppConstans.userToken);
                        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.loginScreen, (e)=>false);
                        },
                      )),
                      10.horizontalSpace,
                      Expanded(child: AppButton(titel: "Cancel",
                      onTap: ()=>Navigator.pop(context),))
                    ],
                  ),
                ),

              ));
            },
            icon: const Icon(Icons.logout),
          ),
        ),
      ],
    );
  }
}