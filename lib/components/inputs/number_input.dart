import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klontong_mobile/components/inputs/text_form.dart';

class XNumberForm extends StatelessWidget {
  const XNumberForm({
    super.key,
    this.controller,
    this.initialValue,
    this.secureText = false,
    this.validator,
    this.label,
    this.hintText,
    this.placeholder,
    this.prefixIcon,
    this.suffixIconButton,
    this.enabled = true,
    this.textInputAction,
    this.onSaved,
    this.isRequired = false,
    this.isDecimal = false,
    this.keyboardType,
    this.inputFormatters,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final bool secureText;
  final FormFieldValidator<String>? validator;
  final String? label;
  final String? hintText;
  final String? placeholder;
  final Widget? prefixIcon;
  final Widget? suffixIconButton;
  final bool enabled;
  final TextInputAction? textInputAction;
  final void Function(String? newValue)? onSaved;
  final bool isRequired;
  final bool isDecimal;

  /// Custom keyboardType
  final TextInputType? keyboardType;

  /// Custom inputFormatters
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return XTextForm(
      controller: controller,
      enabled: enabled,
      hintText: hintText,
      initialValue: initialValue,
      inputFormatters: inputFormatters ??
          [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
            FilteringTextInputFormatter.deny(','),
          ],
      isRequired: isRequired,
      keyboardType:
          keyboardType ?? TextInputType.numberWithOptions(decimal: isDecimal),
      label: label,
      onSaved: onSaved,
      placeholder: placeholder,
      prefixIcon: prefixIcon,
      secureText: secureText,
      suffixIconButton: suffixIconButton,
      textInputAction: textInputAction,
      validator: validator,
    );
  }
}
