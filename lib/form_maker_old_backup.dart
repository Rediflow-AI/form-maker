// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

// Local imports
import 'models/address.dart';
import 'models/currencies.dart';
import 'models/user.dart';
import 'utils/constants.dart';
import 'utils/extensions.dart';
import 'utils/input_styles.dart';
import 'widgets/address_field.dart';
import 'widgets/buttons.dart';
import 'widgets/expandable_dropdown_textfield.dart';
import 'widgets/phone_field.dart';
import 'widgets/working_hours_selector.dart';
import 'widgets/working_hours_models.dart';

abstract class InfoForm extends StatefulWidget {
  InfoForm({
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

abstract class InfoFormState<T extends InfoForm> extends State<T> {
  final double LABEL_COLUMN_WIDTH = 0.2;
  final double INPUT_WIDGET_WIDTH = 0.6;

  String heading = 'Form';
  late bool isEdit;

  @override
  void initState() {
    super.initState();
    isEdit = !widget.editFunctionality;
  }

  File? selectedImage;
  Uint8List? selectedImageBytes; // For web compatibility
  List<XFile> _webSelectedImages = []; // For web multi-image support

  Future<void> save() async {}

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

  Widget labelColumnEntry(String title, String subTitle) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * LABEL_COLUMN_WIDTH,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: smallPadding, bottom: smallPadding),
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          Padding(
            padding: EdgeInsets.only(top: tinyPadding, bottom: tinyPadding),
            child: Text(subTitle, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }

  Widget formEntry({String? title, String? subTitle, Widget? inputWidget}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: normalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelColumnEntry(title!, subTitle!),
          SizedBox(width: largePadding),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: smallPadding),
              child: inputWidget,
            ),
          ),
        ],
      ),
    );
  }

  Widget pictureFormEntry({
    String title = 'Picture',
    String subTitle = 'you can change the picture',
    String? defaultValue,
  }) {
    bool hasImage =
        (defaultValue != null && defaultValue.isNotEmpty) ||
        selectedImage != null ||
        selectedImageBytes != null;

    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            // Image Display Section
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: hasImage
                  ? CircleAvatar(
                      radius: 60,
                      backgroundImage: kIsWeb && selectedImageBytes != null
                          ? MemoryImage(selectedImageBytes!)
                          : selectedImage != null
                          ? FileImage(selectedImage!)
                          : CachedNetworkImageProvider(defaultValue!),
                    )
                  : CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[100],
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                    ),
            ),
            SizedBox(height: 24),

            // Action Buttons Section
            Row(
              children: [
                // Select/Change Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isEdit ? pickImage : null,
                    icon: Icon(
                      hasImage ? Icons.edit : Icons.add_a_photo,
                      size: 20,
                    ),
                    label: Text(
                      hasImage ? 'Change Photo' : 'Add Photo',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryActiveColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      shadowColor: primaryActiveColor.withOpacity(0.3),
                    ),
                  ),
                ),

                if (hasImage) ...[
                  SizedBox(width: 12),
                  // Remove Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isEdit ? removeProfilePicture : null,
                      icon: Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: Colors.red[600],
                      ),
                      label: Text(
                        'Remove',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.red[600],
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.red[300]!),
                      ),
                    ),
                  ),
                ],
              ],
            ),

            // Helper Text
            if (!hasImage) ...[
              SizedBox(height: 12),
              Text(
                'Upload a photo to personalize your profile',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget textFormEntry({
    String title = 'Text',
    String subTitle = 'the text',
    String hint = 'Text',
    IconData iconData = Icons.text_fields,
    Function(String?)? onSaved,
    String? Function(String?)? validator,
    String? defaultValue,
    TextEditingController? controller,
  }) {
    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: TextFormField(
        onChanged: (_) {
          widget.formKey.currentState!.save();
          if (widget.onModified != null) {
            widget.onModified!();
          }
        },
        style: Theme.of(context).textTheme.bodyLarge,
        enabled: isEdit,
        controller: controller ?? TextEditingController(text: defaultValue),
        decoration: elegantInputDecoration(
          hintText: hint,
          prefix: Icon(iconData),
        ),
        validator: validator ?? (value) => value!.isEmpty ? 'Required' : null,
        onSaved: onSaved,
      ),
    );
  }

  Widget nameFormEntry({
    String title = 'Name',
    String subTitle = 'the name',
    Function(String?)? onSaved,
    String? Function(String?)? validator,
    String? defaultValue,
  }) {
    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: TextFormField(
        onChanged: (_) {
          widget.formKey.currentState!.save();
          if (widget.onModified != null) {
            widget.onModified!();
          }
        },
        style: Theme.of(context).textTheme.bodyLarge,
        enabled: isEdit,
        controller: TextEditingController(text: defaultValue),
        decoration: elegantInputDecoration(
          hintText: 'Name',
          prefix: const Icon(Icons.person),
        ),
        validator:
            validator ??
            (value) => value!.isEmpty
                ? 'Name is required'
                : (value.isValidName() ? null : 'Invalid name'),
        onSaved: onSaved,
      ),
    );
  }

  Widget emailFormEntry({
    String title = 'Email',
    String subTitle = 'the email address',
    Function(String?)? onSaved,
    String? defaultValue,
    bool verified = false,
    bool showVerifyButton = true,
    VoidCallback? onVerify,
  }) {
    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: showVerifyButton
          ? Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: Theme.of(context).textTheme.bodyLarge,
                    onChanged: (_) {
                      widget.formKey.currentState!.save();
                      if (widget.onModified != null) {
                        widget.onModified!();
                      }
                    },
                    enabled: isEdit,
                    controller: TextEditingController(text: defaultValue),
                    decoration: elegantInputDecoration(
                      hintText: 'Email',
                      prefix: const Icon(Icons.email),
                    ),
                    validator: (value) => value!.isEmpty
                        ? 'Email is required'
                        : (value.isValidEmail() ? null : 'Invalid email'),
                    onSaved: onSaved,
                  ),
                ),
                if (verified)
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.check_circle, color: Colors.green),
                  )
                else if (showVerifyButton)
                  Padding(
                    padding: EdgeInsets.only(left: smallPadding),
                    child: SecondaryFlatButton(
                      onPressed: onVerify,
                      child: const Text('Verify'),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.check_circle, color: Colors.transparent),
                  ),
              ],
            )
          : TextFormField(
              style: Theme.of(context).textTheme.bodyLarge,
              onChanged: (_) {
                widget.formKey.currentState!.save();
                if (widget.onModified != null) {
                  widget.onModified!();
                }
              },
              enabled: isEdit,
              controller: TextEditingController(text: defaultValue),
              decoration: elegantInputDecoration(
                hintText: 'Email',
                prefix: const Icon(Icons.email),
              ),
              validator: (value) => value!.isEmpty
                  ? 'Email is required'
                  : (value.isValidEmail() ? null : 'Invalid email'),
              onSaved: onSaved,
            ),
    );
  }

  Widget phoneFormEntry({
    String title = 'Phone',
    String subTitle = 'the phone number',
    Function(String?)? onSaved,
    String? defaultValue,
    bool verified = false,
    bool showVerifyButton = true,
    VoidCallback? onVerify,
  }) {
    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: showVerifyButton
          ? Row(
              children: [
                Expanded(
                  child: PhoneField(
                    isRequired: true,
                    isEditable: isEdit,
                    defaultNumber:
                        defaultValue != null &&
                            defaultValue.isNotEmpty &&
                            defaultValue.length > 10
                        ? defaultValue.substring(
                            defaultValue.length - 10,
                            defaultValue.length,
                          )
                        : null,
                    defaultCountryCode:
                        defaultValue != null &&
                            defaultValue.isNotEmpty &&
                            defaultValue.length > 10
                        ? defaultValue.substring(0, defaultValue.length - 10)
                        : null,
                    onChanged: (value) {
                      widget.formKey.currentState!.save();
                      if (widget.onModified != null) {
                        widget.onModified!();
                      }
                    },
                    onSaved: onSaved,
                  ),
                ),
                if (defaultValue != null && defaultValue.isNotEmpty)
                  if (verified)
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.check_circle, color: Colors.green),
                    )
                  else if (showVerifyButton)
                    Padding(
                      padding: EdgeInsets.only(left: smallPadding),
                      child: SecondaryFlatButton(
                        onPressed: onVerify,
                        child: const Text('Verify'),
                      ),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.transparent,
                      ),
                    ),
              ],
            )
          : PhoneField(
              isRequired: true,
              isEditable: isEdit,
              defaultNumber:
                  defaultValue != null &&
                      defaultValue.isNotEmpty &&
                      defaultValue.length > 10
                  ? defaultValue.substring(
                      defaultValue.length - 10,
                      defaultValue.length,
                    )
                  : null,
              defaultCountryCode:
                  defaultValue != null &&
                      defaultValue.isNotEmpty &&
                      defaultValue.length > 10
                  ? defaultValue.substring(0, defaultValue.length - 10)
                  : null,
              onChanged: (value) {
                widget.formKey.currentState!.save();
                if (widget.onModified != null) {
                  widget.onModified!();
                }
              },
              onSaved: onSaved,
            ),
    );
  }

  Widget sSNFormEntry({
    String title = 'SSN',
    String subTitle = 'the social security number',
    Function(String?)? onSaved,
    String? defaultValue,
  }) {
    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: TextFormField(
        style: Theme.of(context).textTheme.bodyLarge,
        enabled: isEdit,
        onChanged: (_) {
          widget.formKey.currentState!.save();
          if (widget.onModified != null) {
            widget.onModified!();
          }
        },
        controller: TextEditingController(text: defaultValue),
        decoration: elegantInputDecoration(
          hintText: 'SSN e.g. XXX-XX-XXXX',
          prefix: const Icon(Icons.security),
        ),
        validator: (value) => value!.isEmpty
            ? null
            : (value.isValidSSNNumber() ? null : 'Invalid SSN'),
        onSaved: onSaved,
      ),
    );
  }

  Widget addressFormEntry({
    String title = 'Address',
    String subTitle = 'the address',
    // Function(String?)? onSaved,
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
      // inputWidget: Row(
      //   children: [
      //     Expanded(
      //       child: TextFormField(
      //         style: Theme.of(context).textTheme.bodyLarge,
      //         controller: TextEditingController(text: defaultValue!.street),
      //         onChanged: (_) {
      //           widget.formKey.currentState!.save();
      //           if (widget.onModified != null) {
      //             widget.onModified!();
      //           }
      //         },
      //         enabled: isEdit,
      //         decoration: elegentInputDecoration(
      //           hintText: 'Street',
      //           prefix: const Icon(Icons.add_business_outlined),
      //         ),
      //         validator: (value) =>
      //             value!.isEmpty ? 'Street is required' : null,
      //         onSaved: (street) => defaultValue.street = street!,
      //       ),
      //     ),
      //     SizedBox(width: smallPadding),
      //     Expanded(
      //       child: TextFormField(
      //         style: Theme.of(context).textTheme.bodyLarge,
      //         enabled: isEdit,
      //         controller: TextEditingController(text: defaultValue.city),
      //         onChanged: (_) {
      //           widget.formKey.currentState!.save();
      //           if (widget.onModified != null) {
      //             widget.onModified!();
      //           }
      //         },
      //         decoration: elegentInputDecoration(
      //           hintText: 'City',
      //           prefix: const Icon(Icons.location_on_outlined),
      //         ),
      //         validator: (value) => value!.isEmpty ? 'City is required' : null,
      //         onSaved: (city) => defaultValue.city = city!,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Widget postalCodeFormEntry({
    String title = 'Postal code',
    String subTitle = 'the postal code',
    Function(String?)? onSaved,
    String? defaultValue,
  }) {
    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: TextFormField(
        style: Theme.of(context).textTheme.bodyLarge,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10), // Limit to 10 digits
        ],
        onChanged: (_) {
          widget.formKey.currentState!.save();
          if (widget.onModified != null) {
            widget.onModified!();
          }
        },
        enabled: isEdit,
        controller: TextEditingController(text: defaultValue),
        decoration: elegantInputDecoration(
          hintText: 'Postal Code (numbers only)',
          prefix: const Icon(Icons.post_add),
        ),
        validator: (value) => value!.isEmpty
            ? 'Postal code is required'
            : (value.length < 5 || value.length > 10
                  ? 'Postal code must be 5-10 digits'
                  : null),
        onSaved: onSaved,
      ),
    );
  }

  Widget websiteUrlFormEntry({
    String title = 'Website URL',
    String subTitle = 'the website URL',
    Function(String?)? onSaved,
    String? defaultValue,
  }) {
    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: TextFormField(
        style: Theme.of(context).textTheme.bodyLarge,
        onChanged: (_) {
          widget.formKey.currentState!.save();
          if (widget.onModified != null) {
            widget.onModified!();
          }
        },
        enabled: isEdit,
        controller: TextEditingController(text: defaultValue),
        decoration: elegantInputDecoration(
          hintText: 'Website URL',
          prefix: const Icon(Icons.web),
        ),
        validator: (value) =>
            value!.isValidUrl() || value.isEmpty ? null : 'Invalid URL',
        onSaved: onSaved,
      ),
    );
  }

  Widget cuisineTypeFormEntry({
    String title = 'Cuisine Type',
    String subTitle = 'the cuisine type',
    Function(String?)? onChanged,
    String? defaultValue,
  }) {
    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: DropdownButtonFormField<String>(
        dropdownColor: Theme.of(context).primaryColor,
        style: Theme.of(context).textTheme.bodyLarge,
        hint: Text(
          'Select Cuisine Type',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        value: defaultValue,
        decoration: elegantInputDecoration(
          hintText: '',
          prefix: const Icon(Icons.perm_contact_calendar_sharp),
        ),
        menuMaxHeight: 300,
        items: CUISINE_TYPES.map((String role) {
          return DropdownMenuItem<String>(value: role, child: Text(role));
        }).toList(),
        onChanged: isEdit
            ? (value) {
                onChanged!(value);
                widget.formKey.currentState!.save();
                if (widget.onModified != null) {
                  widget.onModified!();
                }
              }
            : null,
        validator: (value) =>
            value == null || value.isEmpty ? 'Cuisine is required' : null,
      ),
    );
  }

  Widget branchCodeFormEntry({
    String title = 'Branch Code',
    String subTitle = 'the branch code',
    Function(String?)? onSaved,
    String? defaultValue,
  }) {
    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: TextFormField(
        onChanged: (_) {
          widget.formKey.currentState!.save();
          if (widget.onModified != null) {
            widget.onModified!();
          }
        },
        style: Theme.of(context).textTheme.bodyLarge,
        enabled: isEdit,
        controller: TextEditingController(text: defaultValue),
        decoration: elegantInputDecoration(
          hintText: 'Branch Code',
          prefix: const Icon(Icons.code),
        ),
        validator: (value) => value!.isEmpty
            ? 'Branch code is required'
            : (value.isValidNumber() ? null : 'Invalid branch code'),
        onSaved: onSaved,
      ),
    );
  }

  Widget switchFormEntry({
    String title = 'Switch',
    String subTitle = 'the switch',
    required Function(bool) onToggle,
    bool defaultValue = false,
  }) {
    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: Container(
        padding: EdgeInsets.all(16),
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (subTitle.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Text(
                      subTitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 16),
            MouseRegion(
              cursor: isEdit
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic,
              child: FlutterSwitch(
                value: defaultValue,
                onToggle: isEdit ? onToggle : (value) {},
                activeColor: primaryActiveColor,
                inactiveColor: Colors.grey[300]!,
                disabled: !isEdit,
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

  Widget checkBoxFormEntry({
    String title = 'Checkbox',
    String subTitle = 'Select/Deselect',
    Function(bool?)? onChanged,
    bool defaultValue = false,
  }) {
    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: CheckboxListTile(
        visualDensity: VisualDensity.compact,
        title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        value: defaultValue,
        enabled: isEdit,
        onChanged: (value) {
          onChanged!(value);
          widget.formKey.currentState!.save();
          if (widget.onModified != null) {
            widget.onModified!();
          }
        },
      ),
    );
  }

  Widget openDetailsFormEntry({
    String title = 'Open details',
    String subTitle = 'Goto necessary details',
    String hintText = 'Open details',
    String displayText = '',
    IconData icon = Icons.details,
    GestureTapCallback? onTap,
  }) => formEntry(
    title: title,
    subTitle: subTitle,
    inputWidget: TextFormField(
      decoration: elegantInputDecoration(
        hintText: hintText,
        prefix: Icon(icon),
      ).copyWith(suffixIcon: const Icon(Icons.arrow_forward)),
      controller: TextEditingController(text: displayText),
      mouseCursor: SystemMouseCursors.click,
      readOnly: true,
      onTap: onTap,
    ),
  );

  Widget foodModeFormEntry({
    String title = 'Food Mode',
    String subTitle = 'Select the food modes available',
    Function(bool?)? onSeatingChanged,
    Function(bool?)? onDeliveryChanged,
    bool hasSeating = false,
    bool hasDelivery = false,
  }) {
    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: Flex(
        direction: Axis.vertical,
        children: [
          CheckboxListTile(
            visualDensity: VisualDensity.compact,
            title: Text(
              'Dine-In',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            value: hasSeating,
            enabled: isEdit,
            onChanged: (value) {
              onSeatingChanged!(value);
              widget.formKey.currentState!.save();
              if (widget.onModified != null) {
                widget.onModified!();
              }
            },
          ),
          SizedBox(height: smallPadding),
          CheckboxListTile(
            enabled: isEdit,
            visualDensity: VisualDensity.compact,
            title: Text(
              'Delivery',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            value: hasDelivery,
            onChanged: (value) {
              onDeliveryChanged!(value);
              widget.formKey.currentState!.save();
              if (widget.onModified != null) {
                widget.onModified!();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget numberSpinnerFormEntry({
    String title = 'Seating Capacity',
    String subTitle = 'the seating capacity',
    double min = 1,
    double max = 500,
    double step = 1,
    int decimals = 0,
    Function(double?)? onChanged,
    String? Function(String?)? validator,
    double? defaultValue,
  }) {
    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: SpinBox(
        enabled: isEdit,
        min: min,
        max: max,
        decimals: decimals,
        value: defaultValue ?? min,
        step: step,
        onChanged: onChanged,
        validator: validator,
        decoration: elegantInputDecoration(hintText: '', isSpinner: true),
      ),
    );
  }

  Widget workingHoursFormEntry({
    String title = 'Working Hours',
    String subTitle = 'the working hours',
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
        workingHours: defaultValue,
        layout: layout,
      ),
    );
  }

  Widget roleFormEntry({
    String title = 'Role',
    String subTitle = 'the role',
    Function(UserRoles?)? onChanged,
    UserRoles? defaultValue,
    UserRoles? preDefinedRole,
  }) {
    return formEntry(
      title: 'Select Role',
      subTitle: 'the role of the employee',
      inputWidget: DropdownButtonFormField<UserRoles>(
        value: preDefinedRole ?? defaultValue,
        style: Theme.of(context).textTheme.bodyLarge,
        dropdownColor: Theme.of(context).primaryColor,
        hint: Text(
          'Select Role',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        decoration: elegantInputDecoration(
          hintText: '',
          prefix: const Icon(Icons.perm_contact_calendar_sharp),
        ),
        items: ROLES.map((UserRoles role) {
          return DropdownMenuItem<UserRoles>(
            enabled: role == UserRoles.Admin || role == UserRoles.Owner
                ? false
                : (preDefinedRole != null ? role == preDefinedRole : true),
            value: role,
            child: Text(role.name),
          );
        }).toList(),
        onChanged: isEdit
            ? (value) {
                onChanged!(value);
                widget.formKey.currentState!.save();
                if (widget.onModified != null) {
                  widget.onModified!();
                }
              }
            : null,
        validator: (value) => (value == null) ? 'Role is required' : null,
      ),
    );
  }

  Widget categoryFormEntry(
    List<String> categories, {
    String title = 'Category',
    String subTitle = 'the category in which this meal will be placed',
    String? hintText,
    IconData iconData = Icons.category,
    Function(String?)? onChanged,
    String? defaultValue,
    Function(bool expand)? onExpandChanged,
    VoidCallback? onPressed,
    FocusNode? focusNode,
    Widget? suffix,
  }) {
    if (!categories.contains(defaultValue)) {
      defaultValue = null;
    }
    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: Row(
        children: [
          Expanded(
            child: ExpandableDropdownTextfield<String>(
              items: categories,
              defaultValue: defaultValue,
              onExpandChanged: onExpandChanged,
              iconData: Icons.category,
              onChanged: isEdit ? onChanged : null,
              validator: (value) => value == null || value.isEmpty
                  ? 'Category is required'
                  : null,
              builder: (item) =>
                  Text(item, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
          if (suffix != null) ...[SizedBox(width: smallPadding), suffix],
        ],
      ),
    );
  }

  Widget descriptionFormEntry({
    String title = 'Description',
    String subTitle =
        'the description of your meal that will be displayed below the name',
    Function(String?)? onSaved,
    Function(String?)? onChanged,
    int maxLines = 1,
    String? defaultValue,
  }) {
    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: TextFormField(
        maxLines: maxLines,
        onChanged: (value) {
          widget.formKey.currentState!.save();
          if (widget.onModified != null) {
            widget.onModified!();
          }
          onChanged?.call(value);
        },
        style: Theme.of(context).textTheme.bodyLarge,
        enabled: isEdit,
        controller: TextEditingController(text: defaultValue),
        decoration: elegantInputDecoration(
          hintText: 'Description',
          prefix: const Icon(Icons.description),
        ).copyWith(alignLabelWithHint: true),
        onSaved: onSaved,
      ),
    );
  }

  Widget multiSelectChipfieldFormEntry({
    String title = 'Chipfield',
    String subTitle = '',
    required void Function(List<String>) onChanged,
    required List<String> items,
    String? Function(List<String>?)? validator,
    List<String>? defaultValues,
  }) => formEntry(
    title: title,
    subTitle: subTitle,
    inputWidget: MultiSelectDialogField<String>(
      validator: validator,
      items: items.map((item) => MultiSelectItem<String>(item, item)).toList(),
      // title: Text("Animals"),
      selectedColor: primaryCardColor,
      separateSelectedItems: true,
      selectedItemsTextStyle: subHeadingDark,
      itemsTextStyle: subHeadingDark,
      searchTextStyle: subHeadingDark,
      decoration: BoxDecoration(
        borderRadius: primaryBorderRadius,
        border: Border.all(color: primaryGray, width: 0.6),
      ),
      searchable: true,
      confirmText: Text('Select', style: Theme.of(context).textTheme.bodyLarge),
      cancelText: Text('Cancel', style: Theme.of(context).textTheme.bodyLarge),
      dialogWidth: 800 * scalingFactor,
      chipDisplay: MultiSelectChipDisplay(
        items: items
            .map((item) => MultiSelectItem<String>(item, item))
            .toList(),
        chipColor: primaryCardColor,
        textStyle: subHeadingDark,
        shape: RoundedRectangleBorder(
          borderRadius: primaryBorderRadius,
          side: const BorderSide(color: primaryGray, width: 0.6),
        ),
      ),
      listType: MultiSelectListType.CHIP,
      buttonIcon: const Icon(Icons.list),
      buttonText: Text("Select", style: Theme.of(context).textTheme.bodyLarge),
      onConfirm: onChanged,
      initialValue: defaultValues ?? [],
    ),
  );

  Widget datePickerEntry({
    String title = 'Date',
    String subTitle = 'the date',
    Function(DateTime?)? onChanged,
    DateTime? firstDate,
    DateTime? lastDate,
    Function? onPressed,
    DateTime? defaultValue,
  }) {
    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: TertiaryFlatButton(
        onPressed: () async {
          onPressed?.call();
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: defaultValue ?? firstDate,
            firstDate: firstDate ?? DateTime(2021),
            lastDate: lastDate ?? DateTime(2101),
          );
          onChanged?.call(pickedDate);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.watch_later_outlined),
            SizedBox(width: smallPadding),
            Text(
              defaultValue != null
                  ? '${defaultValue.day.toString().padLeft(2, '0')}-${defaultValue.month.toString().padLeft(2, '0')}-${defaultValue.year}'
                  : 'Select date',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget currencyDropDownEntry({
    String title = 'Currency',
    String subTitle = 'Select the currency for your menu',
    Function(String?)? onChanged,
    String? defaultValue,
  }) => categoryFormEntry(
    Currencies.values
        .map((currency_enum) => currency_enum.name.toUpperCase())
        .toList(),
    title: title,
    subTitle: subTitle,
    iconData: Icons.currency_exchange,
    hintText: 'Select currency',
    onChanged: onChanged,
    defaultValue: defaultValue,
  );

  // Generic single select dropdown
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
    if (options.isEmpty) {
      throw ArgumentError('Options list cannot be empty');
    }

    if (!options.contains(defaultValue)) {
      defaultValue = null;
    }

    return formEntry(
      title: title,
      subTitle: subTitle,
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
        onChanged: isEdit
            ? (value) {
                onChanged?.call(value);
                widget.formKey.currentState?.save();
                widget.onModified?.call();
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

  // Generic multi select form entry
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
    if (options.isEmpty) {
      throw ArgumentError('Options list cannot be empty');
    }

    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: MultiSelectDialogField<String>(
        validator:
            validator ??
            (isRequired
                ? (values) => values == null || values.isEmpty
                      ? '$title is required'
                      : null
                : null),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 1.0),
          color: Colors.grey[50],
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
        dialogWidth: 400,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.blue[200]!, width: 1.0),
          ),
        ),
        listType: MultiSelectListType.CHIP,
        buttonIcon: const Icon(Icons.list),
        buttonText: Text(
          'Select $title',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        onConfirm: (values) {
          onChanged(values);
          widget.formKey.currentState?.save();
          widget.onModified?.call();
        },
        initialValue: defaultValues ?? [],
      ),
    );
  }

  // Generic radio button form entry
  Widget radioButtonFormEntry<T>({
    String title = 'Radio Selection',
    String subTitle = 'Choose one option',
    required List<T> options,
    required String Function(T) getDisplayText,
    required Function(T?) onChanged,
    T? defaultValue,
    String? Function(T?)? validator,
    bool isRequired = false,
  }) {
    if (options.isEmpty) {
      throw ArgumentError('Options list cannot be empty');
    }

    return formEntry(
      title: title,
      subTitle: subTitle,
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
            activeColor: Colors.blue,
            onChanged: isEdit
                ? (T? value) {
                    onChanged(value);
                    widget.formKey.currentState?.save();
                    widget.onModified?.call();
                  }
                : null,
          );
        }).toList(),
      ),
    );
  }

  // Generic checkbox list form entry
  Widget checkboxListFormEntry({
    String title = 'Checkbox List',
    String subTitle = 'Select multiple options',
    required List<String> options,
    required Map<String, bool> selectedOptions,
    required Function(String, bool) onChanged,
    String? Function(Map<String, bool>?)? validator,
    bool isRequired = false,
  }) {
    if (options.isEmpty) {
      throw ArgumentError('Options list cannot be empty');
    }

    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: Column(
        children: options.map((String option) {
          return CheckboxListTile(
            title: Text(option, style: Theme.of(context).textTheme.bodyLarge),
            value: selectedOptions[option] ?? false,
            enabled: isEdit,
            onChanged: (bool? value) {
              onChanged(option, value ?? false);
              widget.formKey.currentState?.save();
              widget.onModified?.call();
            },
          );
        }).toList(),
      ),
    );
  }

  // Multi-photo selection form entry
  Widget multiPhotoFormEntry({
    String title = 'Photos',
    String subTitle = 'Upload multiple photos',
    List<File>? selectedImages,
    Function(List<File>)? onImagesSelected,
    Function(List<XFile>)? onXFilesSelected, // For web compatibility
    int maxImages = 5,
  }) {
    selectedImages ??= [];

    return formEntry(
      title: title,
      subTitle: subTitle,
      inputWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display selected images
          if ((selectedImages.isNotEmpty) ||
              (kIsWeb && _webSelectedImages.isNotEmpty))
            Container(
              height: 140,
              margin: EdgeInsets.only(bottom: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: kIsWeb
                    ? _webSelectedImages.length
                    : selectedImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 12),
                    width: 110,
                    height: 110,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: kIsWeb
                                ? FutureBuilder<Uint8List>(
                                    future: _webSelectedImages[index]
                                        .readAsBytes(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Image.memory(
                                          snapshot.data!,
                                          width: 110,
                                          height: 110,
                                          fit: BoxFit.cover,
                                        );
                                      }
                                      return Container(
                                        width: 110,
                                        height: 110,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  primaryActiveColor,
                                                ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Image.file(
                                    selectedImages![index],
                                    width: 110,
                                    height: 110,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        if (isEdit)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: GestureDetector(
                              onTap: () {
                                if (kIsWeb) {
                                  final updatedXFiles = List<XFile>.from(
                                    _webSelectedImages,
                                  );
                                  updatedXFiles.removeAt(index);
                                  _webSelectedImages = updatedXFiles;
                                  onXFilesSelected?.call(updatedXFiles);
                                } else {
                                  final updatedImages = List<File>.from(
                                    selectedImages!,
                                  );
                                  updatedImages.removeAt(index);
                                  onImagesSelected?.call(updatedImages);
                                }
                                widget.formKey.currentState?.save();
                                widget.onModified?.call();
                              },
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.red[600],
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          SizedBox(height: normalPadding),
          // Add photo buttons
          if (((kIsWeb && _webSelectedImages.length < maxImages) ||
                  (!kIsWeb && selectedImages.length < maxImages)) &&
              isEdit)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                              source: ImageSource.camera,
                            );

                            if (image != null) {
                              if (kIsWeb) {
                                final updatedXFiles = List<XFile>.from(
                                  _webSelectedImages,
                                )..add(image);
                                _webSelectedImages = updatedXFiles;
                                onXFilesSelected?.call(updatedXFiles);
                              } else {
                                final newFile = File(image.path);
                                final updatedImages = List<File>.from(
                                  selectedImages!,
                                )..add(newFile);
                                onImagesSelected?.call(updatedImages);
                              }
                              widget.formKey.currentState?.save();
                              widget.onModified?.call();
                            }
                          },
                          icon: Icon(Icons.camera_alt, size: 18),
                          label: Text(
                            'Camera',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryActiveColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final List<XFile> images = await picker
                                .pickMultiImage();

                            if (images.isNotEmpty) {
                              if (kIsWeb) {
                                final updatedXFiles = List<XFile>.from(
                                  _webSelectedImages,
                                )..addAll(images);

                                // Ensure we don't exceed max images
                                if (updatedXFiles.length > maxImages) {
                                  updatedXFiles.removeRange(
                                    maxImages,
                                    updatedXFiles.length,
                                  );
                                }

                                _webSelectedImages = updatedXFiles;
                                onXFilesSelected?.call(updatedXFiles);
                              } else {
                                final newFiles = images
                                    .map((image) => File(image.path))
                                    .toList();
                                final updatedImages = List<File>.from(
                                  selectedImages!,
                                )..addAll(newFiles);

                                // Ensure we don't exceed max images
                                if (updatedImages.length > maxImages) {
                                  updatedImages.removeRange(
                                    maxImages,
                                    updatedImages.length,
                                  );
                                }

                                onImagesSelected?.call(updatedImages);
                              }
                              widget.formKey.currentState?.save();
                              widget.onModified?.call();
                            }
                          },
                          icon: Icon(Icons.photo_library, size: 18),
                          label: Text(
                            'Gallery',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        'You can select multiple photos from gallery',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          SizedBox(height: smallPadding),
          // Photo count indicator
          Text(
            kIsWeb
                ? 'Photos: ${_webSelectedImages.length}/$maxImages'
                : 'Photos: ${selectedImages.length}/$maxImages',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
