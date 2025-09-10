import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../utils/constants.dart';
import '../utils/input_styles.dart';

/// A collection of interactive form entry widgets (switches, numbers, etc.)
class InteractiveFormEntries {
  
  /// Switch/toggle form field
  static Widget switchFormEntry({
    String title = 'Switch',
    String subTitle = 'Toggle option',
    required Function(bool) onToggle,
    bool defaultValue = false,
    bool enabled = true,
    GlobalKey<FormState>? formKey,
    VoidCallback? onModified,
    required BuildContext context,
  }) {
    return _FormEntryWrapper.formEntry(
      title: title,
      subTitle: subTitle,
      context: context,
      inputWidget: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (subTitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subTitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
            MouseRegion(
              cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
              child: FlutterSwitch(
                value: defaultValue,
                onToggle: enabled ? (value) {
                  onToggle(value);
                  formKey?.currentState?.save();
                  onModified?.call();
                } : (value) {},
                activeColor: primaryActiveColor,
                inactiveColor: Colors.grey[300]!,
                disabled: !enabled,
                width: 50,
                height: 30,
                borderRadius: 15,
                padding: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Checkbox form field
  static Widget checkBoxFormEntry({
    String title = 'Checkbox',
    String subTitle = 'Select/Deselect',
    Function(bool?)? onChanged,
    bool defaultValue = false,
    bool enabled = true,
    GlobalKey<FormState>? formKey,
    VoidCallback? onModified,
    required BuildContext context,
  }) {
    return _FormEntryWrapper.formEntry(
      title: title,
      subTitle: subTitle,
      context: context,
      inputWidget: CheckboxListTile(
        visualDensity: VisualDensity.compact,
        title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        value: defaultValue,
        enabled: enabled,
        onChanged: (value) {
          onChanged?.call(value);
          formKey?.currentState?.save();
          onModified?.call();
        },
      ),
    );
  }

  /// Number spinner form field
  static Widget numberSpinnerFormEntry({
    String title = 'Number',
    String subTitle = 'Select a number',
    double min = 1,
    double max = 100,
    double step = 1,
    int decimals = 0,
    Function(double?)? onChanged,
    String? Function(String?)? validator,
    double? defaultValue,
    bool enabled = true,
    GlobalKey<FormState>? formKey,
    VoidCallback? onModified,
    required BuildContext context,
  }) {
    return _FormEntryWrapper.formEntry(
      title: title,
      subTitle: subTitle,
      context: context,
      inputWidget: SpinBox(
        enabled: enabled,
        min: min,
        max: max,
        decimals: decimals,
        value: defaultValue ?? min,
        step: step,
        onChanged: (value) {
          onChanged?.call(value);
          formKey?.currentState?.save();
          onModified?.call();
        },
        validator: validator,
        decoration: elegantInputDecoration(hintText: '', isSpinner: true),
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
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (inputWidget != null) inputWidget,
        ],
      ),
    );
  }
}
