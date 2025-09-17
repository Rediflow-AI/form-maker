import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../utils/input_styles.dart';

/// A collection of selection-based form entry widgets
class SelectionFormEntries {
  /// Single select dropdown form field
  static Widget singleSelectFormEntry({
    String title = 'Select Option',
    String subTitle = 'Choose one option from the list',
    required List<String> options,
    String? hintText,
    IconData iconData = Icons.list,
    Function(String?)? onChanged,
    String? defaultValue,
    String? Function(String?)? validator,
    bool isRequired = false,
    bool enabled = true,
    GlobalKey<FormState>? formKey,
    VoidCallback? onModified,
    required BuildContext context,
  }) {
    if (options.isEmpty) {
      throw ArgumentError('Options list cannot be empty');
    }

    if (!options.contains(defaultValue)) {
      defaultValue = null;
    }

    return _FormEntryWrapper.formEntry(
      title: title,
      subTitle: subTitle,
      context: context,
      inputWidget: DropdownButtonFormField<String>(
        value: defaultValue,
        dropdownColor: Colors.white,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        hint: Text(
          hintText ?? 'Select an option',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey[600],
          size: 24,
        ),
        decoration: elegantInputDecoration(
          hintText: '',
          prefix: Icon(iconData, color: Colors.grey[600]),
        ),
        menuMaxHeight: 300,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Text(
                option,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: enabled
            ? (value) {
                onChanged?.call(value);
                formKey?.currentState?.save();
                onModified?.call();
              }
            : null,
        validator:
            validator ??
            (isRequired
                ? (value) => value == null || value.isEmpty
                      ? '$title is required'
                      : null
                : null),
      ),
    );
  }

  /// Multi-select form field
  static Widget multiSelectFormEntry({
    String title = 'Multi Select',
    String subTitle = 'Choose multiple options from the list',
    required List<String> options,
    required void Function(List<String>) onChanged,
    String? Function(List<String>?)? validator,
    List<String>? defaultValues,
    bool searchable = true,
    String confirmText = 'Select',
    String cancelText = 'Cancel',
    bool isRequired = false,
    bool enabled = true,
    GlobalKey<FormState>? formKey,
    VoidCallback? onModified,
    required BuildContext context,
  }) {
    if (options.isEmpty) {
      throw ArgumentError('Options list cannot be empty');
    }

    defaultValues ??= [];

    return _FormEntryWrapper.formEntry(
      title: title,
      subTitle: subTitle,
      context: context,
      inputWidget: MultiSelectBottomSheetField<String>(
        initialChildSize: 0.4,
        listType: MultiSelectListType.CHIP,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        buttonText: Text(
          defaultValues.isEmpty
              ? 'Select $title'
              : '${defaultValues.length} selected',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        buttonIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 1.0),
          color: Colors.grey[50],
        ),
        items: options
            .map((item) => MultiSelectItem<String>(item, item))
            .toList(),
        selectedColor: Colors.blue[100],
        separateSelectedItems: true,
        selectedItemsTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        itemsTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        searchTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        searchable: searchable,
        confirmText: Text(
          confirmText,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        cancelText: Text(
          cancelText,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        chipDisplay: MultiSelectChipDisplay(
          items: options
              .map((item) => MultiSelectItem<String>(item, item))
              .toList(),
          chipColor: Colors.blue[50],
          textStyle: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          icon: const Icon(Icons.close, size: 18, color: Colors.grey),
        ),
        initialValue: defaultValues,
        onConfirm: (values) {
          if (enabled) {
            onChanged(values);
            formKey?.currentState?.save();
            onModified?.call();
          }
        },
        validator:
            validator ??
            (isRequired
                ? (values) => values?.isEmpty == true
                      ? 'Please select at least one $title'
                      : null
                : null),
      ),
    );
  }

  /// Generic radio button form field
  static Widget radioButtonFormEntry<T>({
    String title = 'Radio Selection',
    String subTitle = 'Choose one option',
    required List<T> options,
    required String Function(T) getDisplayText,
    required Function(T?) onChanged,
    T? defaultValue,
    String? Function(T?)? validator,
    bool isRequired = false,
    bool enabled = true,
    GlobalKey<FormState>? formKey,
    VoidCallback? onModified,
    required BuildContext context,
  }) {
    if (options.isEmpty) {
      throw ArgumentError('Options list cannot be empty');
    }

    return _FormEntryWrapper.formEntry(
      title: title,
      subTitle: subTitle,
      context: context,
      inputWidget: Column(
        children: options.map((T option) {
          return RadioListTile<T>(
            title: Text(
              getDisplayText(option),
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            value: option,
            groupValue: defaultValue,
            onChanged: enabled
                ? (T? value) {
                    onChanged(value);
                    formKey?.currentState?.save();
                    onModified?.call();
                  }
                : null,
            activeColor: Colors.blue,
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ),
    );
  }

  /// Generic checkbox list form field
  static Widget checkboxListFormEntry({
    String title = 'Checkbox List',
    String subTitle = 'Select multiple options',
    required List<String> options,
    required Map<String, bool> selectedOptions,
    required Function(String, bool) onChanged,
    String? Function(Map<String, bool>?)? validator,
    bool isRequired = false,
    bool enabled = true,
    GlobalKey<FormState>? formKey,
    VoidCallback? onModified,
    required BuildContext context,
  }) {
    if (options.isEmpty) {
      throw ArgumentError('Options list cannot be empty');
    }

    return _FormEntryWrapper.formEntry(
      title: title,
      subTitle: subTitle,
      context: context,
      inputWidget: Column(
        children: options.map((String option) {
          return CheckboxListTile(
            title: Text(
              option,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            value: selectedOptions[option] ?? false,
            onChanged: enabled
                ? (bool? value) {
                    onChanged(option, value ?? false);
                    formKey?.currentState?.save();
                    onModified?.call();
                  }
                : null,
            activeColor: Colors.blue,
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ),
    );
  }
}

/// Internal wrapper for consistent form entry styling
class _FormEntryWrapper {
  static Widget formEntry({
    String? title,
    String? subTitle,
    Widget? inputWidget,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
          ],
          if (subTitle != null) ...[
            Text(
              subTitle,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
          ],
          if (inputWidget != null) inputWidget,
        ],
      ),
    );
  }
}
