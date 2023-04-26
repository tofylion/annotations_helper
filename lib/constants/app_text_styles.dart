import 'package:annotations_helper/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static TextStyle get inputBoxTextStyle => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      );
  static TextStyle get backButtonTextStyle => TextStyle(
      color: AppColors.litBlack, fontSize: 25.sp, fontWeight: FontWeight.bold);
  static TextStyle get creditsTextStyle =>
      TextStyle(color: AppColors.textGrey, fontSize: 20.sp);
}
