import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool enabled;
  final FocusNode? focusNode;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final bool filled;
  final String? helperText;
  final String? errorText;
  final bool showCounter;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.focusNode,
    this.style,
    this.hintStyle,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius,
    this.contentPadding,
    this.filled = true,
    this.helperText,
    this.errorText,
    this.showCounter = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultBorderColor = widget.borderColor ?? AppColors.border;
    final defaultFocusedBorderColor = widget.focusedBorderColor ?? AppColors.primary;
    final defaultFillColor = widget.fillColor ?? AppColors.background;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          validator: widget.validator,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          enabled: widget.enabled,
          style: widget.style ?? TextStyle(
            fontSize: 16.sp,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: widget.hintStyle ?? TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: _isFocused
                        ? defaultFocusedBorderColor
                        : AppColors.textSecondary,
                    size: 20.w,
                  )
                : null,
            suffixIcon: _buildSuffixIcon(),
            filled: widget.filled,
            fillColor: defaultFillColor,
            contentPadding: widget.contentPadding ?? EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.r),
              borderSide: BorderSide(
                color: defaultBorderColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.r),
              borderSide: BorderSide(
                color: defaultBorderColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.r),
              borderSide: BorderSide(
                color: defaultFocusedBorderColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.r),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.r),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.r),
              borderSide: BorderSide(
                color: AppColors.border.withOpacity(0.5),
                width: 1,
              ),
            ),
            helperText: widget.helperText,
            errorText: widget.errorText,
            counterText: widget.showCounter ? null : '',
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textSecondary,
          size: 20.w,
        ),
        onPressed: _toggleObscureText,
      );
    }
    return widget.suffixIcon;
  }
}

// 预定义的文本框样式
class SearchTextField extends CustomTextField {
  SearchTextField({
    super.key,
    super.controller,
    super.hintText = '搜索...',
    super.onChanged,
    super.onSubmitted,
  }) : super(
          prefixIcon: Icons.search,
          borderRadius: 20,
          fillColor: AppColors.background,
        );
}

class PasswordTextField extends CustomTextField {
  PasswordTextField({
    super.key,
    super.controller,
    super.hintText = '请输入密码',
    super.validator,
    super.onChanged,
  }) : super(
          obscureText: true,
          prefixIcon: Icons.lock_outline,
        );
}

class EmailTextField extends CustomTextField {
  EmailTextField({
    super.key,
    super.controller,
    super.hintText = '请输入邮箱',
    super.validator,
    super.onChanged,
  }) : super(
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
        );
}

class PhoneTextField extends CustomTextField {
  PhoneTextField({
    super.key,
    super.controller,
    super.hintText = '请输入手机号',
    super.validator,
    super.onChanged,
  }) : super(
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone_outlined,
          inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
        ],
        );
}

class MultilineTextField extends CustomTextField {
  MultilineTextField({
    super.key,
    super.controller,
    super.hintText,
    super.validator,
    super.onChanged,
    super.maxLength,
    int maxLines = 5,
    int minLines = 3,
  }) : super(
          maxLines: maxLines,
          minLines: minLines,
          keyboardType: TextInputType.multiline,
          showCounter: true,
        );
}