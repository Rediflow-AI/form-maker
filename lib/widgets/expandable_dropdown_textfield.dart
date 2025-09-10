import 'package:flutter/material.dart';
import '../utils/input_styles.dart';

class ExpandableDropdownTextfield<T> extends StatefulWidget {
  final List<T> items;
  final T? defaultValue;
  final Function(bool)? onExpandChanged;
  final IconData iconData;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final Widget Function(T) builder;

  const ExpandableDropdownTextfield({
    Key? key,
    required this.items,
    this.defaultValue,
    this.onExpandChanged,
    required this.iconData,
    this.onChanged,
    this.validator,
    required this.builder,
  }) : super(key: key);

  @override
  State<ExpandableDropdownTextfield<T>> createState() =>
      _ExpandableDropdownTextfieldState<T>();
}

class _ExpandableDropdownTextfieldState<T>
    extends State<ExpandableDropdownTextfield<T>> {
  T? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: selectedValue,
      items: widget.items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: widget.builder(item),
        );
      }).toList(),
      onChanged: (T? newValue) {
        setState(() {
          selectedValue = newValue;
        });
        widget.onChanged?.call(newValue);
      },
      validator: widget.validator,
      decoration: elegantInputDecoration(
        prefix: Icon(widget.iconData),
      ),
    );
  }
}
