import 'package:flutter/material.dart';
import '../models/address.dart';
import '../utils/constants.dart';
import '../utils/input_styles.dart';

class AddressField extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback? onModified;
  final Address? defaultValue;
  final bool isEdit;

  const AddressField({
    Key? key,
    required this.formKey,
    this.onModified,
    this.defaultValue,
    this.isEdit = true,
  }) : super(key: key);

  @override
  State<AddressField> createState() => _AddressFieldState();
}

class _AddressFieldState extends State<AddressField> {
  late Address address;

  @override
  void initState() {
    super.initState();
    address = widget.defaultValue ?? Address();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                enabled: widget.isEdit,
                initialValue: address.street,
                decoration: elegantInputDecoration(
                  hintText: 'Street Address',
                  prefix: const Icon(Icons.add_business_outlined),
                ),
                validator: (value) =>
                    value?.isEmpty == true ? 'Street is required' : null,
                onSaved: (value) => address.street = value ?? '',
                onChanged: (value) {
                  address.street = value;
                  widget.formKey.currentState?.save();
                  widget.onModified?.call();
                },
              ),
            ),
            SizedBox(width: normalPadding),
            Expanded(
              child: TextFormField(
                enabled: widget.isEdit,
                initialValue: address.city,
                decoration: elegantInputDecoration(
                  hintText: 'City',
                  prefix: const Icon(Icons.location_city),
                ),
                validator: (value) =>
                    value?.isEmpty == true ? 'City is required' : null,
                onSaved: (value) => address.city = value ?? '',
                onChanged: (value) {
                  address.city = value;
                  widget.formKey.currentState?.save();
                  widget.onModified?.call();
                },
              ),
            ),
          ],
        ),
        SizedBox(height: normalPadding),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                enabled: widget.isEdit,
                initialValue: address.state,
                decoration: elegantInputDecoration(
                  hintText: 'State/Province',
                  prefix: const Icon(Icons.map),
                ),
                onSaved: (value) => address.state = value ?? '',
                onChanged: (value) {
                  address.state = value;
                  widget.formKey.currentState?.save();
                  widget.onModified?.call();
                },
              ),
            ),
            SizedBox(width: normalPadding),
            Expanded(
              child: TextFormField(
                enabled: widget.isEdit,
                initialValue: address.postalCode,
                decoration: elegantInputDecoration(
                  hintText: 'Postal Code',
                  prefix: const Icon(Icons.local_post_office),
                ),
                validator: (value) =>
                    value?.isEmpty == true ? 'Postal code is required' : null,
                onSaved: (value) => address.postalCode = value ?? '',
                onChanged: (value) {
                  address.postalCode = value;
                  widget.formKey.currentState?.save();
                  widget.onModified?.call();
                },
              ),
            ),
          ],
        ),
        SizedBox(height: normalPadding),
        TextFormField(
          enabled: widget.isEdit,
          initialValue: address.country,
          decoration: elegantInputDecoration(
            hintText: 'Country',
            prefix: const Icon(Icons.public),
          ),
          onSaved: (value) => address.country = value ?? '',
          onChanged: (value) {
            address.country = value;
            widget.formKey.currentState?.save();
            widget.onModified?.call();
          },
        ),
      ],
    );
  }
}
