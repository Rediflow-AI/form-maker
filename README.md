# Form Maker

A comprehensive Flutter package for creating beautiful and functional forms with pre-built components like text fields, dropdowns, image pickers, and more.

## Features

- **Pre-built Form Components**: Text fields, dropdowns, switches, spinners, and more
- **Image Picker Integration**: Easy profile picture and image selection
- **Address Fields**: Complete address input with validation
- **Phone Number Fields**: International phone number support with country codes
- **Working Hours Selector**: Interactive working hours configuration
- **Multi-Select Options**: Chip-based multi-selection fields
- **Date Pickers**: Beautiful date selection components
- **Currency Support**: Built-in currency dropdown with symbols
- **Form Validation**: Comprehensive validation for all field types
- **Responsive Design**: Works across different screen sizes
- **Customizable Styling**: Easy theming and customization

## Getting started

Add this package to your Flutter project:

```yaml
dependencies:
  form_maker: ^0.0.1
```

Then run:
```bash
flutter pub get
```

## Usage

### Basic Form Implementation

```dart
import 'package:flutter/material.dart';
import 'package:form_maker/form_maker_library.dart';

class MyFormPage extends InfoForm {
  MyFormPage({Key? key}) : super(
    key: key,
    formKey: GlobalKey<FormState>(),
    editFunctionality: true,
    saveFunctionality: true,
  );

  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends InfoFormState<MyFormPage> {
  String? name;
  String? email;
  Address address = Address();

  @override
  void initState() {
    super.initState();
    heading = 'User Information';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form Example')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: widget.formKey,
          child: Column(
            children: [
              buildHeading(),
              nameFormEntry(
                onSaved: (value) => name = value,
                defaultValue: name,
              ),
              emailFormEntry(
                onSaved: (value) => email = value,
                defaultValue: email,
              ),
              addressFormEntry(
                defaultValue: address,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Future<void> save() async {
    if (widget.formKey.currentState?.validate() ?? false) {
      widget.formKey.currentState?.save();
      // Handle save logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form saved successfully!')),
      );
    }
  }
}
```

### Available Form Fields

- `nameFormEntry()` - Name input with validation
- `emailFormEntry()` - Email input with validation
- `phoneFormEntry()` - Phone number with country code
- `addressFormEntry()` - Complete address input
- `textFormEntry()` - Generic text input
- `switchFormEntry()` - Toggle switch
- `numberSpinnerFormEntry()` - Numeric spinner
- `datePickerEntry()` - Date selection
- `currencyDropDownEntry()` - Currency selection
- `categoryFormEntry()` - Dropdown selection
- `workingHoursFormEntry()` - Working hours configuration
- `multiSelectChipfieldFormEntry()` - Multi-select chips

### Customization

You can customize the appearance by modifying the constants in your app:

```dart
// Override default colors and styling
const primaryActiveColor = Colors.blue;
const primaryCardColor = Colors.grey[100];
```

## Models

The package includes several useful models:

- `Address` - Complete address information
- `WorkingHour` - Working hours configuration
- `Currencies` - Comprehensive currency enum with symbols
- `UserRoles` - User role definitions

## Additional information

This package is designed to speed up form development in Flutter applications. It provides a consistent, beautiful, and functional form interface that can be easily customized to match your app's design.

### Contributing

Contributions are welcome! Please feel free to submit issues and enhancement requests.

### License

This package is licensed under the MIT License.
