# Rediflow Form Maker

[![pub package](https://img.shields.io/pub/v/rediflow_form_maker.svg)](https://pub.dev/packages/rediflow_form_maker)
[![pub points](https://img.shields.io/pub/points/rediflow_form_maker)](https://pub.dev/packages/rediflow_form_maker/score)
[![popularity](https://img.shields.io/pub/popularity/rediflow_form_maker)](https://pub.dev/packages/rediflow_form_maker/score)
[![likes](https://img.shields.io/pub/likes/rediflow_form_maker)](https://pub.dev/packages/rediflow_form_maker/score)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/Rediflow-AI/form-maker/blob/main/LICENSE)

A comprehensive Flutter package for creating beautiful and functional forms with pre-built components like text fields, dropdowns, image pickers, and more.

## Features

- **Pre-built Form Components**: Text fields, dropdowns, switches, spinners, and more
- **Image Picker Integration**: Easy profile picture and image selection with support for multiple images
- **Address Fields**: Complete address input with validation
- **Phone Number Fields**: International phone number support with country codes
- **Working Hours Selector**: Interactive grid-based working hours configuration with dual layout support (days-as-rows or hours-as-rows)
- **Multi-Select Options**: Chip-based and list-based multi-selection fields
- **Radio Button Groups**: Easy radio button form entries with custom types
- **Single Select Dropdowns**: Customizable dropdown selection fields
- **Date Pickers**: Beautiful date selection components
- **Currency Support**: Built-in currency dropdown with symbols
- **Form Validation**: Comprehensive validation for all field types
- **Responsive Design**: Works across different screen sizes
- **Customizable Styling**: Easy theming and customization

## Getting started

Add this package to your Flutter project:

```yaml
dependencies:
  rediflow_form_maker: ^0.0.1
```

Then run:
```bash
flutter pub get
```

## Usage

### Basic Form Implementation

```dart
import 'package:flutter/material.dart';
import 'package:rediflow_form_maker/form_maker_library.dart';

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
  String selectedGender = "";
  List<String> selectedSkills = [];
  List<WorkingHour> workingHours = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form Example')),
      body: Form(
        key: widget.formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              buildHeading(),
              
              // Profile picture
              pictureFormEntry(
                title: "Profile Photo",
                subTitle: "Upload your profile picture",
              ),
              
              // Text inputs
              nameFormEntry(
                onSaved: (value) {},
                validator: (value) => value?.isEmpty == true ? "Name required" : null,
              ),
              
              emailFormEntry(
                onSaved: (value) {},
                validator: (value) {
                  if (value?.isEmpty == true) return "Email required";
                  if (value?.contains('@') != true) return "Invalid email";
                  return null;
                },
              ),
              
              // Phone with country code
              phoneFormEntry(
                title: "Phone Number",
                subTitle: "Your contact number",
                onSaved: (value) {},
              ),
              
              // Address input
              addressFormEntry(
                title: "Home Address",
                subTitle: "Your residential address",
              ),
              
              // Radio buttons
              radioButtonFormEntry<String>(
                title: "Gender",
                subTitle: "Select your gender",
                options: ['Male', 'Female', 'Other'],
                getDisplayText: (value) => value,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value ?? "";
                  });
                },
                defaultValue: selectedGender.isEmpty ? null : selectedGender,
              ),
              
              // Multi-select chips
              multiSelectFormEntry(
                title: "Skills",
                subTitle: "Select your skills",
                options: ['Flutter', 'Dart', 'iOS', 'Android', 'Web'],
                onChanged: (values) {
                  setState(() {
                    selectedSkills = values;
                  });
                },
                defaultValues: selectedSkills,
              ),
              
              // Working hours with interactive grid
              WorkingHoursWidget(
                isEnabled: true,
                onChanged: (hours) {
                  setState(() {
                    workingHours = hours;
                  });
                },
                workingHours: workingHours,
              ),
              
              // Switch toggle
              switchFormEntry(
                title: "Notifications",
                subTitle: "Receive email notifications",
                onToggle: (value) {},
                defaultValue: true,
              ),
              
              // Number spinner
              numberSpinnerFormEntry(
                title: "Age",
                subTitle: "Your age",
                min: 18,
                max: 100,
                defaultValue: 25,
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

#### Text Input Fields
- `textFormEntry()` - Generic text input with customization
- `nameFormEntry()` - Name input with validation
- `emailFormEntry()` - Email input with validation
- `phoneFormEntry()` - Phone number with country code selector
- `addressFormEntry()` - Complete address input
- `postalCodeFormEntry()` - Postal/ZIP code input (numbers only)
- `websiteUrlFormEntry()` - Website URL input
- `descriptionFormEntry()` - Multi-line text area

#### Selection Fields
- `singleSelectFormEntry()` - Dropdown selection
- `multiSelectFormEntry()` - Multiple selection with checkboxes
- `radioButtonFormEntry<T>()` - Radio button groups with custom types
- `multiSelectChipfieldFormEntry()` - Chip-based multi-selection
- `categoryFormEntry()` - Category dropdown

#### Interactive Fields
- `switchFormEntry()` - Toggle switch
- `checkBoxFormEntry()` - Single checkbox
- `numberSpinnerFormEntry()` - Numeric spinner with min/max
- `WorkingHoursWidget()` - Interactive grid-based working hours

#### Media Fields
- `pictureFormEntry()` - Single image picker
- `multiPhotoFormEntry()` - Multiple image picker

#### Specialized Fields
- `cuisineTypeFormEntry()` - Restaurant cuisine selection
- `roleFormEntry()` - User role selection
- `branchCodeFormEntry()` - Branch/location code input

### Working Hours Widget

The `WorkingHoursWidget` provides an interactive grid interface for selecting working hours:

```dart
WorkingHoursWidget(
  isEnabled: true,
  onChanged: (hours) {
    // Handle working hours changes
    setState(() {
      workingHours = hours;
    });
  },
  workingHours: workingHours,
  layout: WorkingHoursLayout.daysAsRows, // Optional: choose layout orientation
)
```

#### Layout Options

You can choose between two layout orientations:

```dart
// Default: Days as rows, hours as columns (traditional calendar view)
WorkingHoursWidget(
  layout: WorkingHoursLayout.daysAsRows,
  // ... other properties
)

// Alternative: Hours as rows, days as columns (timeline view)
WorkingHoursWidget(
  layout: WorkingHoursLayout.hoursAsRows,
  // ... other properties
)
```

Features:
- **Dual Layout Support**: Choose between days-as-rows or hours-as-rows orientation
- Interactive time grid with 24-hour slots
- Click to select/deselect time slots
- Handles discontinuous hours (e.g., "9-12, 14-17")
- Shows total hours per week
- **Sticky Headers**: Day/hour labels remain visible while scrolling
- Mobile-friendly responsive interface with adaptive cell sizing

### Customization

You can customize the appearance by modifying the styling:

```dart
// Override default colors and styling in your theme
ThemeData(
  primarySwatch: Colors.blue,
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
)
```

## Models

The package includes several useful models:

- `Address` - Complete address information with street, city, state, country, postal code
- `WorkingHour` - Working hours configuration with day, open/close times, and status
- `Currencies` - Comprehensive currency enum with symbols and names
- `UserRoles` - User role definitions for role-based forms

### Address Model
```dart
Address address = Address(
  streetAddress: "123 Main St",
  city: "New York",
  state: "NY",
  country: "USA",
  postalCode: "10001",
);
```

### WorkingHour Model
```dart
WorkingHour hour = WorkingHour(
  day: "Monday",
  openTime: "09:00",
  closeTime: "17:00",
  isOpen: true,
);
```

## Examples

Check out the `/example` folder for comprehensive examples including:
- Restaurant registration form
- School information form  
- User profile form
- Hospital/medical facility form

Each example demonstrates different form fields and validation patterns.

## TODO / Future Enhancements

We're continuously working to improve Form Maker. Here are some planned features and enhancements:

### 🔄 **In Progress**
- **Responsive Working Hours Grid**: Better mobile and tablet responsiveness for the working hours selector
- **Enhanced Validation System**: More comprehensive validation rules and custom validation builders
- **Theme Customization**: Advanced theming system for easier customization of colors, fonts, and spacing

### 📋 **Planned Features**
- **Date Range Picker**: Select date ranges with a beautiful calendar interface
- **Time Picker Integration**: Standalone time picker components
- **File Upload Widget**: Support for document and file uploads beyond images
- **Signature Pad**: Digital signature capture widget
- **Rating/Star Widget**: Star rating and review components
- **Color Picker**: Color selection widget for design-related forms
- **Rich Text Editor**: WYSIWYG text editor for description fields
- **Geolocation Picker**: Map-based location selection widget
- **Barcode/QR Scanner**: Integration for scanning barcodes and QR codes

### 🎨 **UI/UX Improvements**
- **Animation System**: Smooth animations for form interactions and validation feedback
- **Dark Mode Support**: Built-in dark theme compatibility
- **Accessibility Enhancements**: Better screen reader support and keyboard navigation
- **Custom Input Decorations**: More styling options for form fields
- **Progress Indicators**: Multi-step form progress tracking
- **Floating Labels**: Modern floating label animations

### 🔧 **Technical Enhancements**
- **Form State Management**: Integration with popular state management solutions (Provider, Riverpod, Bloc)
- **Internationalization**: Built-in i18n support for multiple languages
- **Performance Optimization**: Lazy loading and improved rendering for large forms
- **Web Compatibility**: Enhanced web support and responsive design
- **Testing Utilities**: Testing helpers and mock widgets for easier unit testing
- **Documentation**: Interactive documentation website with live examples

### 🛠 **Developer Experience**
- **Form Builder**: Visual form builder tool for rapid prototyping
- **Code Generation**: Generate form code from JSON schemas
- **VS Code Extension**: Snippets and autocomplete for faster development
- **Validation Schema**: JSON-based validation rule definitions
- **Form Analytics**: Usage analytics and performance monitoring tools

### 📱 **Platform-Specific Features**
- **iOS Cupertino Styling**: Native iOS-styled form components
- **Material 3 Design**: Full Material You design system integration
- **Desktop Optimization**: Enhanced desktop experience with keyboard shortcuts
- **Accessibility Standards**: WCAG 2.1 AA compliance

## Contributing to TODO Items

We welcome contributions for any of these planned features! If you're interested in working on any TODO item:

1. Check the [GitHub Issues](https://github.com/Rediflow-AI/form-maker/issues) for existing discussions
2. Create a new issue to discuss your approach
3. Fork the repository and create a feature branch
4. Submit a pull request with your implementation

Priority will be given to features that enhance accessibility, performance, and developer experience.

## Additional information

This package is designed to speed up form development in Flutter applications. It provides a consistent, beautiful, and functional form interface that can be easily customized to match your app's design.

### Requirements
- Flutter SDK: >=3.0.0
- Dart SDK: ^3.8.1

### Dependencies
- `cached_network_image`: For image caching
- `flutter_spinbox`: For numeric spinners
- `flutter_switch`: For toggle switches
- `image_picker`: For image selection
- `multi_select_flutter`: For multi-selection fields

### Contributing

Contributions are welcome! Please feel free to submit issues and enhancement requests on [GitHub](https://github.com/Rediflow-AI/form-maker).

### License

This package is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
