import 'package:annotations_helper/constants/constants.dart';
import 'package:flutter/material.dart';

class MainActionButton extends StatelessWidget {
  const MainActionButton({
    super.key,
    required this.text,
    required this.width,
    required this.height,
    this.onTap,
  });

  final void Function()? onTap;
  final String text;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.spacingXXS,
          horizontal: Dimensions.spacingS,
        ),
        decoration: BoxDecoration(
          color: Color(0xFF136660),
          border: Border.all(
            color: AppColors.teal,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(Dimensions.radius4),
        ),
        child: Center(
          child: Text(text, style: AppTextStyles.inputBoxTextStyle),
        ),
      ),
    );
  }
}
