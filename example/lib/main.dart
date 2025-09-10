import 'package:flutter/material.dart';
import 'package:form_maker/form_maker_library.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Maker Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExampleFormPage(),
    );
  }
}

class ExampleFormPage extends InfoForm {
  ExampleFormPage({Key? key})
      : super(
          key: key,
          formKey: GlobalKey<FormState>(),
          editFunctionality: true,
          saveFunctionality: true,
        );

  @override
  _ExampleFormPageState createState() => _ExampleFormPageState();
}

class _ExampleFormPageState extends InfoFormState<ExampleFormPage> {
  String? name;
  String? email;
  String? phone;
  Address address = Address();
  String? currency;
  bool hasDelivery = false;
  bool hasSeating = true;

  @override
  void initState() {
    super.initState();
    heading = 'Restaurant Information';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Maker Example'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeading(),
              SizedBox(height: 20),

              // Basic Information
              nameFormEntry(
                title: 'Restaurant Name',
                subTitle: 'Enter the name of your restaurant',
                onSaved: (value) => name = value,
                defaultValue: name,
              ),

              emailFormEntry(
                title: 'Contact Email',
                subTitle: 'Primary email for contact',
                onSaved: (value) => email = value,
                defaultValue: email,
              ),

              phoneFormEntry(
                title: 'Phone Number',
                subTitle: 'Contact phone number',
                onSaved: (value) => phone = value,
                defaultValue: phone,
              ),

              // Address Information
              addressFormEntry(
                title: 'Restaurant Address',
                subTitle: 'Complete address of your restaurant',
                defaultValue: address,
              ),

              // Currency Selection
              currencyDropDownEntry(
                title: 'Primary Currency',
                subTitle: 'Select your menu currency',
                onChanged: (value) => currency = value,
                defaultValue: currency,
              ),

              // Food Mode Selection
              foodModeFormEntry(
                title: 'Service Options',
                subTitle: 'Select available service modes',
                hasDelivery: hasDelivery,
                hasSeating: hasSeating,
                onDeliveryChanged: (value) =>
                    setState(() => hasDelivery = value ?? false),
                onSeatingChanged: (value) =>
                    setState(() => hasSeating = value ?? true),
              ),

              SizedBox(height: 30),
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

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Restaurant information saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Print saved data for demo
      print('Saved Data:');
      print('Name: $name');
      print('Email: $email');
      print('Phone: $phone');
      print('Address: ${address.toString()}');
      print('Currency: $currency');
      print('Has Delivery: $hasDelivery');
      print('Has Seating: $hasSeating');
    }
  }
}
