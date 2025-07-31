import 'package:drift_bottle_app/presentation/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final Widget? icon;
  final bool outlined;
  final Color? borderColor;
  final double? elevation;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.icon,
    this.outlined = false,
    this.borderColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBackgroundColor = outlined
        ? Colors.transparent
        : (backgroundColor ?? AppColors.primary);
    final defaultTextColor = outlined
        ? (textColor ?? AppColors.primary)
        : (textColor ?? Colors.white);
    final defaultBorderColor = outlined
        ? (borderColor ?? AppColors.primary)
        : Colors.transparent;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 48.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: defaultBackgroundColor,
          foregroundColor: defaultTextColor,
          elevation: elevation ?? (outlined ? 0 : 2),
          shadowColor: Colors.black.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
            side: BorderSide(
              color: defaultBorderColor,
              width: outlined ? 1.5 : 0,
            ),
          ),
          padding: padding ?? EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    outlined ? AppColors.primary : Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    SizedBox(width: 8.w),
                  ],
                  Text(
                    text,
                    style: textStyle ??
                        TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: defaultTextColor,
                        ),
                  ),
                ],
              ),
      ),
    );
  }
}

// 预定义的按钮样式
class PrimaryButton extends CustomButton {
  const PrimaryButton({
    super.key,
    required super.text,
    super.onPressed,
    super.isLoading = false,
    super.width,
    super.height,
    super.icon,
  }) : super(
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
        );
}

class SecondaryButton extends CustomButton {
  const SecondaryButton({
    super.key,
    required super.text,
    super.onPressed,
    super.isLoading = false,
    super.width,
    super.height,
    super.icon,
  }) : super(
          outlined: true,
          borderColor: AppColors.primary,
          textColor: AppColors.primary,
        );
}

class DangerButton extends CustomButton {
  const DangerButton({
    super.key,
    required super.text,
    super.onPressed,
    super.isLoading = false,
    super.width,
    super.height,
    super.icon,
  }) : super(
          backgroundColor: AppColors.error,
          textColor: Colors.white,
        );
}

class SuccessButton extends CustomButton {
  const SuccessButton({
    super.key,
    required super.text,
    super.onPressed,
    super.isLoading = false,
    super.width,
    super.height,
    super.icon,
  }) : super(
          backgroundColor: AppColors.success,
          textColor: Colors.white,
        );
}

class WarningButton extends CustomButton {
  const WarningButton({
    super.key,
    required super.text,
    super.onPressed,
    super.isLoading = false,
    super.width,
    super.height,
    super.icon,
  }) : super(
          backgroundColor: AppColors.warning,
          textColor: Colors.white,
        );
}