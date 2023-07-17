import 'package:annotations_helper/constants/constants.dart';
import 'package:flutter/material.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton(
      {super.key, this.onTap, this.text = 'BACK', this.shadowOpacity = 0.25});

  final void Function()? onTap;
  final String text;
  final double shadowOpacity;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        width: Dimensions.backButtonWidth,
        height: Dimensions.backButtonHeight,
        decoration: BoxDecoration(
          color: AppColors.roboGreen,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(Dimensions.radius5),
            bottomLeft: Radius.circular(Dimensions.radius5),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.teal.withOpacity(shadowOpacity),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.backButtonTextStyle,
          ),
        ),
      ),
    );
  }
}
