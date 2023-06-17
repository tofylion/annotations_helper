import 'package:annotations_helper/constants/dimensions.dart';
import 'package:annotations_helper/constants/timing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sprung/sprung.dart';

class MainScreenAnimator extends AnimationController {
  MainScreenAnimator({required TickerProvider vsync}) : super(vsync: vsync) {
    duration = Timing.mainTransitionDuration;
    _initAnimations();
  }

  late CurvedAnimation _curvedAnimationController;
  late Animation<double> _inputBoxMoveAnimation;
  late Animation<double> _mainActionButtonMoveAnimation;
  late Animation<double> _mainActionButtonWidthAnimation;
  late Animation<double> _mainActionButtonHeightAnimation;
  late Animation<double> _backButtonAnimation;

  final videoExpandedProvider = StateProvider<bool>((ref) => false);

  void _initAnimations() {
    _curvedAnimationController = CurvedAnimation(
        parent: this,
        curve: Sprung.overDamped,
        reverseCurve: Sprung.overDamped.flipped);
    _inputBoxMoveAnimation = Tween<double>(
            begin: Dimensions.inputBoxLocation,
            end: -Dimensions.inputBoxHeight - 10.sp)
        .animate(_curvedAnimationController);
    _mainActionButtonMoveAnimation = Tween<double>(
            begin: Dimensions.actionButtonLocation,
            end: Dimensions.videoPlayerLocation)
        .animate(_curvedAnimationController);
    _mainActionButtonWidthAnimation = Tween<double>(
            begin: Dimensions.actionButtonWidth,
            end: Dimensions.videoPlayerWidth)
        .animate(_curvedAnimationController);
    _mainActionButtonHeightAnimation = Tween<double>(
            begin: Dimensions.actionButtonHeight,
            end: Dimensions.videoPlayerHeight)
        .animate(_curvedAnimationController);
    _backButtonAnimation =
        Tween<double>(begin: -Dimensions.backButtonHeight - 10.sp, end: 0)
            .animate(_curvedAnimationController);
  }

  double get animationValue => _curvedAnimationController.value;

  double get inputBoxValue => _inputBoxMoveAnimation.value;

  double get mainActionButtonMoveValue => _mainActionButtonMoveAnimation.value;

  double get mainActionButtonWidthValue =>
      _mainActionButtonWidthAnimation.value;

  double get mainActionButtonHeightValue =>
      _mainActionButtonHeightAnimation.value;

  double get backButtonValue => _backButtonAnimation.value;
}
