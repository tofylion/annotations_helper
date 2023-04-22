import 'package:annotations_helper/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InputBox extends ConsumerStatefulWidget {
  const InputBox(
      {super.key, this.onFieldSubmitted, this.controller, this.onChanged});

  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InputBoxState();
}

class _InputBoxState extends ConsumerState<InputBox> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FocusNode focusNode;
  bool isHovering = false;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode()..addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Timing.inputShadowDuration,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius6),
          boxShadow: [
            ...(focusNode.hasFocus
                ? [
                    BoxShadow(
                        offset: const Offset(0, 0),
                        blurRadius: 8,
                        spreadRadius: 0,
                        color: AppColors.teal.withOpacity(0.25))
                  ]
                : []),
          ]),
      child: Form(
        key: _formKey,
        child: InkWell(
          onTap: () => null,
          onHover: (value) => setState(() {
            isHovering = value;
          }),
          child: TextFormField(
            controller: widget.controller,
            focusNode: focusNode,
            cursorColor: AppColors.teal,
            onChanged: widget.onChanged,
            style: AppTextStyles.inputBoxTextStyle,
            decoration: InputDecoration(
              constraints: BoxConstraints(
                maxHeight: Dimensions.inputBoxHeight,
                minHeight: Dimensions.inputBoxHeight,
                maxWidth: Dimensions.inputBoxWidth,
                minWidth: Dimensions.inputBoxWidth,
              ),
              alignLabelWithHint: true,
              contentPadding:
                  // widget.contentPadding ??
                  EdgeInsets.symmetric(
                vertical: Dimensions.spacingXS,
                horizontal: Dimensions.spacingS,
              ),
              hintText: 'Enter image name'
              // widget.hintText
              ,
              hintStyle: AppTextStyles.inputBoxTextStyle,
              // labelStyle: appTextStyle.dp16Reg60,
              // floatingLabelStyle: appTextStyle.dp10Reg100,
              fillColor: AppColors.grey,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius6),
                borderSide: BorderSide(
                    color: isHovering
                        ? AppColors.slimeGreen
                        : AppColors.spaceGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius6),
                borderSide: const BorderSide(color: AppColors.teal),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius6),
                borderSide: const BorderSide(color: AppColors.roboRed),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius6),
                borderSide: const BorderSide(color: AppColors.roboRed),
              ),
            ),
            onFieldSubmitted: widget.onFieldSubmitted,
          ),
        ),
      ),
    );
  }
}
