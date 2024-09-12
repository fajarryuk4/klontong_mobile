import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class XTextForm extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final TextInputType? keyboardType;
  final bool secureText;
  final FormFieldValidator<String>? validator;
  final String? label;
  final String? hintText;
  final String? placeholder;
  final Widget? prefixIcon;
  final Widget? suffixIconButton;
  final bool enabled;
  final bool isRequired;
  final bool readOnly;
  final TextInputAction? textInputAction;
  final void Function(String? newValue)? onSaved;
  final void Function(String? newValue)? onChanged;
  final void Function(String? newValue)? onSubmit;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsets? margin;

  const XTextForm({
    super.key,
    this.controller,
    this.initialValue,
    this.keyboardType,
    this.secureText = false,
    this.validator,
    this.label,
    this.hintText,
    this.placeholder,
    this.prefixIcon,
    this.suffixIconButton,
    this.enabled = true,
    this.isRequired = false,
    this.textInputAction,
    this.onSaved,
    this.inputFormatters,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.onSubmit,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        children: [
          if (label != null || hintText != null)
            Row(
              children: [
                Expanded(flex: 2, child: Text((label ?? ''))),
                Flexible(
                  flex: 1,
                  child: Text(
                    hintText ?? '',
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
          TextFormField(
            onTap: onTap,
            onSaved: onSaved,
            onChanged: onChanged,
            onFieldSubmitted: onSubmit,
            controller: controller,
            initialValue: initialValue,
            keyboardType: keyboardType,
            obscureText: secureText,
            textInputAction: textInputAction,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (isRequired)
                ? (v) => ((v ?? '').isEmpty) ? 'Input is required' : null
                : validator,
            inputFormatters: inputFormatters,
            readOnly: readOnly,
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              hintText: placeholder ?? '',
              suffixIcon: suffixIconButton,
              enabled: enabled,
            ),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const Gap(12),
        ],
      ),
    );
  }
}
