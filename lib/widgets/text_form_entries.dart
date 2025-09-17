import 'package:flutter/material.dart';
import '../utils/input_styles.dart';

/// A collection of text-based form entry widgets
class TextFormEntries {
  /// Generic text form field
  static Widget textFormEntry({
    String title = 'Text',
    String subTitle = 'Enter text',
    String hint = 'Text',
    IconData iconData = Icons.text_fields,
    Function(String?)? onSaved,
    String? Function(String?)? validator,
    String? defaultValue,
    bool enabled = true,
    GlobalKey<FormState>? formKey,
    VoidCallback? onModified,
    required BuildContext context,
  }) {
    return _FormEntryWrapper.formEntry(
      title: title,
      subTitle: subTitle,
      context: context,
      inputWidget: TextFormField(
        onChanged: (_) {
          formKey?.currentState?.save();
          onModified?.call();
        },
        style: Theme.of(context).textTheme.bodyLarge,
        enabled: enabled,
        controller: TextEditingController(text: defaultValue),
        decoration: elegantInputDecoration(
          hintText: hint,
          prefix: Icon(iconData),
        ),
        validator:
            validator ?? (value) => value?.isEmpty == true ? 'Required' : null,
        onSaved: onSaved,
      ),
    );
  }

  /// Email form field with validation
  static Widget emailFormEntry({
    String title = 'Email',
    String subTitle = 'Enter email address',
    String hint = 'email@example.com',
    Function(String?)? onSaved,
    String? Function(String?)? validator,
    String? defaultValue,
    bool enabled = true,
    GlobalKey<FormState>? formKey,
    VoidCallback? onModified,
    required BuildContext context,
  }) {
    return _FormEntryWrapper.formEntry(
      title: title,
      subTitle: subTitle,
      context: context,
      inputWidget: TextFormField(
        onChanged: (_) {
          formKey?.currentState?.save();
          onModified?.call();
        },
        style: Theme.of(context).textTheme.bodyLarge,
        enabled: enabled,
        controller: TextEditingController(text: defaultValue),
        decoration: elegantInputDecoration(
          hintText: hint,
          prefix: const Icon(Icons.email),
        ),
        validator:
            validator ??
            (value) {
              if (value?.isEmpty == true) return 'Email is required';
              if (value?.contains('@') != true)
                return 'Please enter a valid email';
              return null;
            },
        onSaved: onSaved,
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  /// Website URL form field
  static Widget websiteUrlFormEntry({
    String title = 'Website URL',
    String subTitle = 'Enter website URL',
    String hint = 'https://example.com',
    Function(String?)? onSaved,
    String? Function(String?)? validator,
    String? defaultValue,
    bool enabled = true,
    GlobalKey<FormState>? formKey,
    VoidCallback? onModified,
    required BuildContext context,
  }) {
    return _FormEntryWrapper.formEntry(
      title: title,
      subTitle: subTitle,
      context: context,
      inputWidget: TextFormField(
        onChanged: (_) {
          formKey?.currentState?.save();
          onModified?.call();
        },
        style: Theme.of(context).textTheme.bodyLarge,
        enabled: enabled,
        controller: TextEditingController(text: defaultValue),
        decoration: elegantInputDecoration(
          hintText: hint,
          prefix: const Icon(Icons.web),
        ),
        validator:
            validator ??
            (value) {
              if (value?.isNotEmpty == true && !value!.startsWith('http')) {
                return 'Please enter a valid URL';
              }
              return null;
            },
        onSaved: onSaved,
        keyboardType: TextInputType.url,
      ),
    );
  }

  /// Multi-line description/text area form field
  static Widget descriptionFormEntry({
    String title = 'Description',
    String subTitle = 'Enter description',
    String hint = 'Enter detailed description...',
    Function(String?)? onSaved,
    String? Function(String?)? validator,
    String? defaultValue,
    int maxLines = 4,
    bool enabled = true,
    GlobalKey<FormState>? formKey,
    VoidCallback? onModified,
    required BuildContext context,
  }) {
    return _FormEntryWrapper.formEntry(
      title: title,
      subTitle: subTitle,
      context: context,
      inputWidget: TextFormField(
        onChanged: (_) {
          formKey?.currentState?.save();
          onModified?.call();
        },
        style: Theme.of(context).textTheme.bodyLarge,
        enabled: enabled,
        controller: TextEditingController(text: defaultValue),
        decoration: elegantInputDecoration(
          hintText: hint,
          prefix: const Icon(Icons.description),
        ),
        validator: validator,
        onSaved: onSaved,
        maxLines: maxLines,
        keyboardType: TextInputType.multiline,
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
