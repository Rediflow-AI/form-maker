import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/input_styles.dart';
import '../utils/extensions.dart';

class PhoneField extends StatefulWidget {
  final bool isRequired;
  final bool isEditable;
  final String? defaultNumber;
  final String? defaultCountryCode;
  final Function(String)? onChanged;
  final Function(String?)? onSaved;

  const PhoneField({
    Key? key,
    this.isRequired = false,
    this.isEditable = true,
    this.defaultNumber,
    this.defaultCountryCode,
    this.onChanged,
    this.onSaved,
  }) : super(key: key);

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  late TextEditingController countryCodeController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    countryCodeController = TextEditingController(text: widget.defaultCountryCode ?? '+1');
    phoneController = TextEditingController(text: widget.defaultNumber ?? '');
  }

  @override
  void dispose() {
    countryCodeController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _onChanged() {
    final fullNumber = '${countryCodeController.text}${phoneController.text}';
    widget.onChanged?.call(fullNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: TextFormField(
            controller: countryCodeController,
            enabled: widget.isEditable,
            decoration: elegantInputDecoration(
              hintText: '+1',
            ),
            onChanged: (_) => _onChanged(),
            validator: widget.isRequired
                ? (value) => value?.isEmpty == true ? 'Required' : null
                : null,
          ),
        ),
        SizedBox(width: smallPadding),
        Expanded(
          child: TextFormField(
            controller: phoneController,
            enabled: widget.isEditable,
            keyboardType: TextInputType.phone,
            decoration: elegantInputDecoration(
              hintText: 'Phone Number',
              prefix: const Icon(Icons.phone),
            ),
            onChanged: (_) => _onChanged(),
            validator: widget.isRequired
                ? (value) {
                    if (value?.isEmpty == true) return 'Phone is required';
                    if (value != null && value.isValidNumber() == false) {
                      return 'Invalid phone number';
                    }
                    return null;
                  }
                : null,
            onSaved: (value) {
              final fullNumber = '${countryCodeController.text}${phoneController.text}';
              widget.onSaved?.call(fullNumber);
            },
          ),
        ),
      ],
    );
  }
}
