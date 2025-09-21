// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Local imports
import 'models/address.dart';
import 'models/user.dart';
import 'widgets/address_field.dart';
import 'widgets/buttons.dart';
import 'widgets/phone_field.dart';
import 'widgets/working_hours_selector.dart';
import 'widgets/working_hours_models.dart';
import 'widgets/text_form_entries.dart';
import 'widgets/selection_form_entries.dart';
import 'widgets/interactive_form_entries.dart';
import 'widgets/media_form_entries.dart';

/// Abstract base class for creating forms with consistent styling and functionality
abstract class InfoForm extends StatefulWidget {
  const InfoForm({
    super.key,
    this.onImageSelected,
    required this.formKey,
    this.editFunctionality = false,
    this.saveFunctionality = false,
    this.onModified,
  });

  final Function(File? image)? onImageSelected;
  final Function()? onModified;
  final GlobalKey<FormState> formKey;
  final bool editFunctionality;
  final bool saveFunctionality;
}

/// Abstract state class that provides form entry methods and common functionality
abstract class InfoFormState<T extends InfoForm> extends State<T> {
  String heading = 'Form';
  late bool isEdit;

  @override
  void initState() {
    super.initState();
    isEdit = !widget.editFunctionality;
  }

  // Image handling properties
  File? selectedImage;
  Uint8List? selectedImageBytes; // For web compatibility
  List<XFile> _webSelectedImages = []; // For web multi-image support

  /// Override this method to implement save functionality
  Future<void> save() async {}

  /// Builds the form heading with edit and save buttons
  Widget buildHeading() {
    return Row(
      children: [
        Expanded(
          child: Text(
            heading,
            style: Theme.of(context).textTheme.headlineMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (widget.editFunctionality)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TertiaryIconButton(
              onPressed: () {
                setState(() {
                  isEdit = !isEdit;
                });
              },
              iconData: isEdit ? Icons.edit : Icons.edit_off,
            ),
          ),
        if (widget.saveFunctionality)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TertiaryIconButton(
              onPressed: isEdit ? () => save() : null,
              iconData: Icons.save,
            ),
          ),
      ],
    );
  }

  /// Removes the currently selected profile picture
  void removeProfilePicture() {
    setState(() {
      selectedImage = null;
      selectedImageBytes = null;
      if (widget.onImageSelected != null) {
        widget.onImageSelected!(selectedImage);
      }
      if (widget.onModified != null) {
        widget.onModified!();
      }
    });
  }

  /// Picks an image from gallery with web compatibility
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        if (kIsWeb) {
          // For web, store bytes instead of File
          image.readAsBytes().then((bytes) {
            setState(() {
              selectedImageBytes = bytes;
              selectedImage = null; // Clear file reference on web
            });
          });
        } else {
          // For mobile platforms
          selectedImage = File(image.path);
          selectedImageBytes = null;
        }

        if (widget.onImageSelected != null) {
          widget.onImageSelected!(selectedImage);
        }
        if (widget.onModified != null) {
          widget.onModified!();
        }
      });
    }
  }

  // ============================================================================
  // FORM ENTRY METHODS
  // ============================================================================

  /// Generic form entry wrapper for consistent styling
  Widget formEntry({String? title, String? subTitle, Widget? inputWidget}) {
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

  // ============================================================================
  // TEXT FORM ENTRIES
  // ============================================================================

  /// Generic text form field
  Widget textFormEntry({
    String title = 'Text',
    String subTitle = 'Enter text',
    String hint = 'Text',
    IconData iconData = Icons.text_fields,
    Function(String?)? onSaved,
    String? Function(String?)? validator,
    String? defaultValue,
  }) {
    return TextFormEntries.textFormEntry(
      title: title,
      subTitle: subTitle,
      hint: hint,
      iconData: iconData,
      onSaved: onSaved,
      validator: validator,
      defaultValue: defaultValue,
      enabled: isEdit,
      formKey: widget.formKey,
      onModified: widget.onModified,
      context: context,
    );
  }

  /// Email form field with validation
  Widget emailFormEntry({
    String title = 'Email',
    String subTitle = 'Enter email address',
    String hint = 'email@example.com',
    Function(String?)? onSaved,
    String? Function(String?)? validator,
    String? defaultValue,
  }) {
    return TextFormEntries.emailFormEntry(
      title: title,
      subTitle: subTitle,
      hint: hint,
      onSaved: onSaved,
      validator: validator,
      defaultValue: defaultValue,
      enabled: isEdit,
      formKey: widget.formKey,
      onModified: widget.onModified,
      context: context,
    );
  }

  /// Website URL form field
  Widget websiteUrlFormEntry({
    String title = 'Website URL',
    String subTitle = 'Enter website URL',
    String hint = 'https://example.com',
    Function(String?)? onSaved,
    String? Function(String?)? validator,
    String? defaultValue,
  }) {
    return TextFormEntries.websiteUrlFormEntry(
      title: title,
      subTitle: subTitle,
      hint: hint,
      onSaved: onSaved,
      validator: validator,
      defaultValue: defaultValue,
      enabled: isEdit,
      formKey: widget.formKey,
      onModified: widget.onModified,
      context: context,
    );
  }

  /// Multi-line description form field
  Widget descriptionFormEntry({
    String title = 'Description',
    String subTitle = 'Enter description',
    String hint = 'Enter detailed description...',
    Function(String?)? onSaved,
    String? Function(String?)? validator,
    String? defaultValue,
    int maxLines = 4,
  }) {
    return TextFormEntries.descriptionFormEntry(
      title: title,
      subTitle: subTitle,
      hint: hint,
      onSaved: onSaved,
      validator: validator,
      defaultValue: defaultValue,
      maxLines: maxLines,
      enabled: isEdit,
      formKey: widget.formKey,
      onModified: widget.onModified,
      context: context,
    );
  }

  // ============================================================================
  // SELECTION FORM ENTRIES
  // ============================================================================

  /// Single select dropdown form field
  Widget singleSelectFormEntry({
    String title = 'Select Option',
    String subTitle = 'Choose one option from the list',
    required List<String> options,
    String? hintText,
    IconData iconData = Icons.list,
    Function(String?)? onChanged,
    String? defaultValue,
    String? Function(String?)? validator,
    bool isRequired = false,
  }) {
    return SelectionFormEntries.singleSelectFormEntry(
      title: title,
      subTitle: subTitle,
      options: options,
      hintText: hintText,
      iconData: iconData,
      onChanged: onChanged,
      defaultValue: defaultValue,
      validator: validator,
      isRequired: isRequired,
      enabled: isEdit,
      formKey: widget.formKey,
      onModified: widget.onModified,
      context: context,
    );
  }

  /// Multi-select form field
  Widget multiSelectFormEntry({
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
  }) {
    return SelectionFormEntries.multiSelectFormEntry(
      title: title,
      subTitle: subTitle,
      options: options,
      onChanged: onChanged,
      validator: validator,
      defaultValues: defaultValues,
      searchable: searchable,
      confirmText: confirmText,
      cancelText: cancelText,
      isRequired: isRequired,
      enabled: isEdit,
      formKey: widget.formKey,
      onModified: widget.onModified,
      context: context,
    );
  }

  /// Generic radio button form field
  Widget radioButtonFormEntry<R>({
    String title = 'Radio Selection',
    String subTitle = 'Choose one option',
    required List<R> options,
    required String Function(R) getDisplayText,
    required Function(R?) onChanged,
    R? defaultValue,
    String? Function(R?)? validator,
    bool isRequired = false,
  }) {
    return SelectionFormEntries.radioButtonFormEntry<R>(
      title: title,
      subTitle: subTitle,
      options: options,
      getDisplayText: getDisplayText,
      onChanged: onChanged,
      defaultValue: defaultValue,
      validator: validator,
      isRequired: isRequired,
      enabled: isEdit,
      formKey: widget.formKey,
      onModified: widget.onModified,
      context: context,
    );
  }

  // ============================================================================
  // INTERACTIVE FORM ENTRIES
  // ============================================================================

  /// Switch/toggle form field
  Widget switchFormEntry({
    String title = 'Switch',
    String subTitle = 'Toggle option',
    required Function(bool) onToggle,
    bool defaultValue = false,
  }) {
    return InteractiveFormEntries.switchFormEntry(
      title: title,
      subTitle: subTitle,
      onToggle: onToggle,
      defaultValue: defaultValue,
      enabled: isEdit,
      formKey: widget.formKey,
      onModified: widget.onModified,
      context: context,
    );
  }

  /// Checkbox form field
  Widget checkBoxFormEntry({
    String title = 'Checkbox',
    String subTitle = 'Select/Deselect',
    Function(bool?)? onChanged,
    bool defaultValue = false,
  }) {
    return InteractiveFormEntries.checkBoxFormEntry(
      title: title,
      subTitle: subTitle,
      onChanged: onChanged,
      defaultValue: defaultValue,
      enabled: isEdit,
      formKey: widget.formKey,
      onModified: widget.onModified,
      context: context,
    );
  }

  /// Number spinner form field
  Widget numberSpinnerFormEntry({
    String title = 'Number',
    String subTitle = 'Select a number',
    double min = 1,
    double max = 100,
    double step = 1,
    int decimals = 0,
    Function(double?)? onChanged,
    String? Function(String?)? validator,
    double? defaultValue,
  }) {
    return InteractiveFormEntries.numberSpinnerFormEntry(
      title: title,
      subTitle: subTitle,
      min: min,
      max: max,
      step: step,
      decimals: decimals,
      onChanged: onChanged,
      validator: validator,
      defaultValue: defaultValue,
      enabled: isEdit,
      formKey: widget.formKey,
      onModified: widget.onModified,
      context: context,
    );
  }

  // ============================================================================
  // MEDIA FORM ENTRIES
  // ============================================================================

  /// Single picture form field
  Widget pictureFormEntry({
    String title = 'Picture',
    String subTitle = 'Upload a picture',
    String? defaultValue,
  }) {
    return MediaFormEntries.pictureFormEntry(
      title: title,
      subTitle: subTitle,
      defaultValue: defaultValue,
      selectedImage: selectedImage,
      selectedImageBytes: selectedImageBytes,
      onPickImage: pickImage,
      onRemoveImage: removeProfilePicture,
      enabled: isEdit,
      context: context,
    );
  }

  /// Multi-photo form field
  Widget multiPhotoFormEntry({
    String title = 'Photos',
    String subTitle = 'Upload multiple photos',
    List<File>? selectedImages,
    Function(List<File>)? onImagesSelected,
    Function(List<XFile>)? onXFilesSelected,
    int maxImages = 5,
  }) {
    return MediaFormEntries.multiPhotoFormEntry(
      title: title,
      subTitle: subTitle,
      selectedImages: selectedImages,
      webSelectedImages: _webSelectedImages,
      onImagesSelected: onImagesSelected,
      onXFilesSelected: (xFiles) {
        _webSelectedImages = xFiles;
        onXFilesSelected?.call(xFiles);
      },
      maxImages: maxImages,
      enabled: isEdit,
      formKey: widget.formKey,
      onModified: widget.onModified,
      context: context,
    );
  }

  // ============================================================================
  // SPECIALIZED FORM ENTRIES
  // ============================================================================

  /// Address form field
  Widget addressFormEntry({
    String title = 'Address',
    String subTitle = 'Enter address',
    Address? defaultValue,
  }) {
    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: AddressField(
        formKey: widget.formKey,
        onModified: widget.onModified,
        defaultValue: defaultValue,
        isEdit: isEdit,
      ),
    );
  }

  /// Phone number form field
  Widget phoneFormEntry({
    String title = 'Phone Number',
    String subTitle = 'Enter phone number',
    String? defaultValue,
  }) {
    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: PhoneField(
        isRequired: false,
        isEditable: isEdit,
        defaultNumber: defaultValue,
      ),
    );
  }

  /// Working hours form field
  Widget workingHoursFormEntry({
    String title = 'Working Hours',
    String subTitle = 'Set working hours',
    Function(List<WorkingHour>)? onChanged,
    List<WorkingHour>? defaultValue,
    WorkingHoursLayout layout = WorkingHoursLayout.daysAsRows,
  }) {
    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: WorkingHoursWidget(
        isEnabled: isEdit,
        onChanged: (value) {
          onChanged!(value);
          widget.formKey.currentState!.save();
          if (widget.onModified != null) {
            widget.onModified!();
          }
        },
        workingHours: defaultValue ?? [],
        layout: layout,
      ),
    );
  }

  /// Postal code form field
  Widget postalCodeFormEntry({
    String title = 'Postal Code',
    String subTitle = 'Enter postal code',
    Function(String?)? onSaved,
    String? defaultValue,
  }) {
    return TextFormEntries.textFormEntry(
      title: title,
      subTitle: subTitle,
      hint: 'Postal Code (numbers only)',
      iconData: Icons.post_add,
      onSaved: onSaved,
      defaultValue: defaultValue,
      enabled: isEdit,
      formKey: widget.formKey,
      onModified: widget.onModified,
      context: context,
      validator: (value) => value?.isEmpty == true
          ? 'Postal code is required'
          : (value!.length < 5 || value.length > 10
                ? 'Postal code must be 5-10 digits'
                : null),
    );
  }
}
