import 'dart:io';
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
      home: TabbedFormPage(),
    );
  }
}

class TabbedFormPage extends StatefulWidget {
  @override
  _TabbedFormPageState createState() => _TabbedFormPageState();
}

class _TabbedFormPageState extends State<TabbedFormPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Maker Example'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.restaurant), text: 'Restaurant'),
            Tab(icon: Icon(Icons.school), text: 'School'),
            Tab(icon: Icon(Icons.person), text: 'User'),
            Tab(icon: Icon(Icons.local_hospital), text: 'Hospital'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RestaurantFormPage(),
          SchoolFormPage(),
          UserFormPage(),
          HospitalFormPage(),
        ],
      ),
    );
  }
}

// Restaurant Form
class RestaurantFormPage extends InfoForm {
  RestaurantFormPage({Key? key})
      : super(
          key: key,
          formKey: GlobalKey<FormState>(),
          editFunctionality: true,
          saveFunctionality: true,
        );

  @override
  _RestaurantFormPageState createState() => _RestaurantFormPageState();
}

class _ExampleFormPageState extends InfoFormState<ExampleFormPage> {
  String? name;
  String? email;
  String? phone;
  Address address = Address();
  String? currency;
  String? restaurantType;
  bool hasDelivery = false;
  bool hasSeating = true;
  List<String> selectedCuisines = [];
  List<String> selectedServices = [];
  Map<String, bool> selectedAmenities = {};
  String? restaurantImageUrl; // For displaying existing image
  List<File> restaurantGallery = []; // For multiple photos

  @override
  void initState() {
    super.initState();
    heading = 'Restaurant Information';

    // Initialize amenities map
    selectedAmenities = {
      'WiFi': false,
      'Parking': false,
      'Wheelchair Accessible': false,
      'Pet Friendly': false,
      'Kids Menu': false,
      'Vegan Options': false,
    };
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

              // Restaurant Photo
              pictureFormEntry(
                title: 'Restaurant Photo',
                subTitle: 'Upload a photo of your restaurant',
                defaultValue: restaurantImageUrl,
              ),

              // Restaurant Gallery - Multi Photo Selection
              multiPhotoFormEntry(
                title: 'Restaurant Gallery',
                subTitle: 'Upload multiple photos of your restaurant (max 5)',
                selectedImages: restaurantGallery,
                onImagesSelected: (images) {
                  setState(() {
                    restaurantGallery = images;
                  });
                },
                maxImages: 5,
              ),

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
                onChanged: (value) => setState(() => currency = value),
                defaultValue: currency,
              ),

              // Restaurant Type - Single Select
              singleSelectFormEntry(
                title: 'Restaurant Type',
                subTitle: 'Select the type of your restaurant',
                options: [
                  'Fast Food',
                  'Casual Dining',
                  'Fine Dining',
                  'Cafe',
                  'Food Truck',
                  'Bakery',
                  'Bar & Grill'
                ],
                hintText: 'Choose restaurant type',
                iconData: Icons.restaurant,
                onChanged: (value) => setState(() => restaurantType = value),
                defaultValue: restaurantType,
                isRequired: true,
              ),

              // Cuisines - Multi Select
              multiSelectFormEntry(
                title: 'Cuisine Types',
                subTitle: 'Select all cuisine types you serve',
                options: [
                  'Italian',
                  'Chinese',
                  'Indian',
                  'Mexican',
                  'Japanese',
                  'Thai',
                  'French',
                  'American',
                  'Mediterranean',
                  'Korean',
                  'Vietnamese',
                  'Greek'
                ],
                onChanged: (values) =>
                    setState(() => selectedCuisines = values),
                defaultValues: selectedCuisines,
                isRequired: true,
              ),

              // Services - Multi Select with custom options
              multiSelectFormEntry(
                title: 'Additional Services',
                subTitle: 'Select additional services you provide',
                options: [
                  'Catering',
                  'Private Events',
                  'Online Ordering',
                  'Loyalty Program',
                  'Happy Hour',
                  'Live Music',
                  'Outdoor Seating'
                ],
                onChanged: (values) =>
                    setState(() => selectedServices = values),
                defaultValues: selectedServices,
                confirmText: 'Add Services',
                cancelText: 'Close',
              ),

              // Food Mode Selection - Keep original for comparison
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

              // Amenities - Checkbox List
              checkboxListFormEntry(
                title: 'Restaurant Amenities',
                subTitle: 'Check all amenities available',
                options: [
                  'WiFi',
                  'Parking',
                  'Wheelchair Accessible',
                  'Pet Friendly',
                  'Kids Menu',
                  'Vegan Options'
                ],
                selectedOptions: selectedAmenities,
                onChanged: (amenity, isSelected) {
                  setState(() {
                    selectedAmenities[amenity] = isSelected;
                  });
                },
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
      print('Restaurant Type: $restaurantType');
      print('Selected Cuisines: $selectedCuisines');
      print('Selected Services: $selectedServices');
      print('Has Delivery: $hasDelivery');
      print('Has Seating: $hasSeating');
      print('Amenities: $selectedAmenities');
      print('Selected Image: ${selectedImage?.path ?? "No image selected"}');
      print('Gallery Images: ${restaurantGallery.length} photos');
      for (int i = 0; i < restaurantGallery.length; i++) {
        print('  Photo ${i + 1}: ${restaurantGallery[i].path}');
      }
    }
  }
}
