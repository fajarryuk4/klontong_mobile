import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class XDropdownForm<T> extends StatelessWidget {
  final String? label;
  final String? hintText;
  final String? placeholder;
  final bool enabled;
  final bool isRequired;
  final Widget? suffixIconButton;
  final EdgeInsets? margin;
  final String? Function(T? v)? validator;
  final Function(T? v)? onSaved;
  final Function(T? v)? onChanged;

  /// Function for request Item with search query params
  /// Function must return list of item
  final Future<List<T>> Function(String search)? requestItems;
  final List<T> items;

  /// Function for select attribute of object
  /// that dispayed in dropdown item text
  final String Function(T object)? displayText;

  /// Function for compare initial item
  /// for choose item that selected in list item
  final bool Function(T item, T selected)? initCompareItem;
  final T? initialValue;
  final AutovalidateMode? autovalidateMode;

  /// Function for checking disable item condition
  /// that you want to disable some item in list
  final bool Function(T v)? disabledItem;

  /// Function for checking displayed item
  /// that you want to filter some item in list
  final bool Function(T v, String search)? filter;

  final bool? showSearchBox;
  final bool isFilterOnline;

  const XDropdownForm({
    super.key,
    this.label,
    this.hintText,
    this.placeholder,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.enabled = true,
    this.isRequired = false,
    this.suffixIconButton,
    this.requestItems,
    this.displayText,
    this.initCompareItem,
    this.initialValue,
    this.autovalidateMode,
    this.disabledItem,
    this.items = const [],
    this.showSearchBox,
    this.isFilterOnline = false,
    this.filter,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final showSelectItem = (initialValue != null && initCompareItem != null);

    return Container(
      margin: margin,
      child: Column(
        children: [
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
          DropdownSearch<T>(
            autoValidateMode:
                autovalidateMode ?? AutovalidateMode.onUserInteraction,
            enabled: enabled,
            clearButtonProps: ClearButtonProps(
              icon: const Icon(Icons.close),
              isVisible: enabled,
            ),
            popupProps: PopupProps.menu(
              searchFieldProps: TextFieldProps(
                showCursor: true,
                decoration: InputDecoration(
                  hintText: placeholder ?? '',
                  suffixIcon: suffixIconButton,
                  enabled: enabled,
                ),
              ),
              isFilterOnline: isFilterOnline,
              showSelectedItems: showSelectItem,
              showSearchBox: showSearchBox ?? requestItems != null,
              disabledItemFn: disabledItem,
              errorBuilder: (context, searchEntry, exception) {
                if (exception is DioException) {
                  if (exception.type == DioExceptionType.badResponse) {
                    return Center(
                      child: Text(exception.response?.data['message']),
                    );
                  }

                  return const Center(
                    child: Text('Please Check Connection'),
                  );
                }

                return const Center(
                  child: Text('No Data Available'),
                );
              },
            ),
            filterFn: filter,
            asyncItems: requestItems,
            items: items,
            itemAsString: displayText,
            onSaved: onSaved,
            onChanged: onChanged,
            compareFn: initCompareItem,
            validator: (isRequired)
                ? (v) => (v == null) ? 'Input is required' : null
                : validator,
            selectedItem: initialValue,
          ),
          const Gap(12),
        ],
      ),
    );
  }
}
