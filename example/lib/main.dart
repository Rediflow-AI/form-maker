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

class _RestaurantFormPageState extends InfoFormState<RestaurantFormPage> {
  String selectedRestaurantType = "";
  String selectedCuisineType = "";
  File? selectedPhoto;
  List<File> selectedPhotos = [];
  List<String> selectedServices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Form'),
      ),
      body: Form(
        key: widget.formKey,
        child: Column(
          children: [
            buildHeading(),
            Expanded(child: buildFormContent(context)),
          ],
        ),
      ),
    );
  }

  Widget buildFormContent(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          textFormEntry(
            title: "Restaurant Name",
            subTitle: "Enter the name of your restaurant",
            validator: (value) => value?.isEmpty == true ? "Please enter restaurant name" : null,
          ),
          SizedBox(height: 16.0),
          textFormEntry(
            title: "Description",
            subTitle: "Brief description of your restaurant",
            hint: "Tell us about your restaurant...",
          ),
          SizedBox(height: 16.0),
          singleSelectFormEntry(
            title: "Cuisine Type",
            subTitle: "Select the type of cuisine you serve",
            options: [
              'Italian',
              'Chinese',
              'Mexican',
              'Indian',
              'Japanese',
              'American',
              'French',
              'Thai',
              'Mediterranean',
              'Other'
            ],
            onChanged: (value) {
              setState(() {
                selectedCuisineType = value ?? "";
              });
            },
            validator: (value) => value?.isEmpty == true ? "Please select cuisine type" : null,
            defaultValue: selectedCuisineType,
          ),
          SizedBox(height: 16.0),
          singleSelectFormEntry(
            title: "Restaurant Type",
            subTitle: "Select the type of your restaurant",
            options: [
              'Fast Food',
              'Casual Dining',
              'Fine Dining',
              'Cafe',
              'Food Truck',
              'Buffet',
              'Other'
            ],
            onChanged: (value) {
              setState(() {
                selectedRestaurantType = value ?? "";
              });
            },
            validator: (value) => value?.isEmpty == true ? "Please select restaurant type" : null,
            defaultValue: selectedRestaurantType,
          ),
          SizedBox(height: 16.0),
          textFormEntry(
            title: "Phone Number",
            subTitle: "Contact phone number",
            validator: (value) => value?.isEmpty == true ? "Please enter phone number" : null,
          ),
          SizedBox(height: 16.0),
          addressFormEntry(
            title: "Restaurant Address",
            subTitle: "Complete address of your restaurant",
          ),
          SizedBox(height: 16.0),
          pictureFormEntry(
            title: "Restaurant Photo",
            subTitle: "Upload a photo of your restaurant",
          ),
          SizedBox(height: 16.0),
          multiPhotoFormEntry(
            title: "Menu Photos",
            subTitle: "Upload photos of your menu items",
            selectedImages: selectedPhotos,
            onImagesSelected: (photos) {
              setState(() {
                selectedPhotos = photos;
              });
            },
            maxImages: 5,
          ),
          SizedBox(height: 16.0),
          numberSpinnerFormEntry(
            title: "Average Price per Person",
            subTitle: "Average price in local currency",
            min: 1,
            max: 1000,
            defaultValue: 20,
          ),
          SizedBox(height: 16.0),
          switchFormEntry(
            title: "Currently Open",
            subTitle: "Is your restaurant currently open?",
            onToggle: (value) {},
            defaultValue: false,
          ),
          SizedBox(height: 16.0),
          multiSelectFormEntry(
            title: "Services",
            subTitle: "Select all services you provide",
            options: [
              'Delivery',
              'Takeout',
              'Dine-in',
              'Catering',
              'Online Ordering',
              'Reservations',
              'WiFi',
              'Parking'
            ],
            onChanged: (selectedValues) {
              setState(() {
                selectedServices = selectedValues;
              });
            },
            validator: (value) => value?.isEmpty == true ? "Please select at least one service" : null,
            defaultValues: selectedServices,
          ),
          SizedBox(height: 24.0),
        ],
      ),
    );
  }

  void onSave() {
    if (widget.formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Restaurant information saved successfully!')),
      );
    }
  }

  void onEdit() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit mode enabled')),
    );
  }
}

// School Form
class SchoolFormPage extends InfoForm {
  SchoolFormPage({Key? key})
      : super(
          key: key,
          formKey: GlobalKey<FormState>(),
          editFunctionality: true,
          saveFunctionality: true,
        );

  @override
  _SchoolFormPageState createState() => _SchoolFormPageState();
}

class _SchoolFormPageState extends InfoFormState<SchoolFormPage> {
  String selectedSchoolType = "";
  List<String> selectedFacilities = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('School Form'),
      ),
      body: Form(
        key: widget.formKey,
        child: Column(
          children: [
            buildHeading(),
            Expanded(child: buildFormContent(context)),
          ],
        ),
      ),
    );
  }

  Widget buildFormContent(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          textFormEntry(
            title: "School Name",
            subTitle: "Enter the name of your school",
            validator: (value) => value?.isEmpty == true ? "Please enter school name" : null,
          ),
          SizedBox(height: 16.0),
          singleSelectFormEntry(
            title: "School Type",
            subTitle: "Select the type of educational institution",
            options: [
              'Elementary School',
              'Middle School',
              'High School',
              'University',
              'College',
              'Private School',
              'Public School',
              'Charter School'
            ],
            onChanged: (value) {
              setState(() {
                selectedSchoolType = value ?? "";
              });
            },
            validator: (value) => value?.isEmpty == true ? "Please select school type" : null,
            defaultValue: selectedSchoolType,
          ),
          SizedBox(height: 16.0),
          textFormEntry(
            title: "Principal Name",
            subTitle: "Name of the principal or head of school",
            validator: (value) => value?.isEmpty == true ? "Please enter principal name" : null,
          ),
          SizedBox(height: 16.0),
          textFormEntry(
            title: "Phone Number",
            subTitle: "Contact phone number",
            validator: (value) => value?.isEmpty == true ? "Please enter phone number" : null,
          ),
          SizedBox(height: 16.0),
          textFormEntry(
            title: "Email",
            subTitle: "Official email address",
            validator: (value) {
              if (value?.isEmpty == true) return "Please enter email";
              if (value?.contains('@') != true) return "Please enter valid email";
              return null;
            },
          ),
          SizedBox(height: 16.0),
          addressFormEntry(
            title: "School Address",
            subTitle: "Complete address of the school",
          ),
          SizedBox(height: 16.0),
          pictureFormEntry(
            title: "School Photo",
            subTitle: "Upload a photo of your school",
          ),
          SizedBox(height: 16.0),
          numberSpinnerFormEntry(
            title: "Number of Students",
            subTitle: "Total number of students enrolled",
            min: 1,
            max: 10000,
            defaultValue: 100,
          ),
          SizedBox(height: 16.0),
          multiSelectFormEntry(
            title: "Facilities",
            subTitle: "Select all facilities available at your school",
            options: [
              'Library',
              'Gymnasium',
              'Computer Lab',
              'Science Lab',
              'Cafeteria',
              'Playground',
              'Swimming Pool',
              'Auditorium',
              'Art Room',
              'Music Room'
            ],
            onChanged: (selectedValues) {
              setState(() {
                selectedFacilities = selectedValues;
              });
            },
            defaultValues: selectedFacilities,
          ),
          SizedBox(height: 24.0),
        ],
      ),
    );
  }

  void onSave() {
    if (widget.formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('School information saved successfully!')),
      );
    }
  }

  void onEdit() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit mode enabled')),
    );
  }
}

// User Form
class UserFormPage extends InfoForm {
  UserFormPage({Key? key})
      : super(
          key: key,
          formKey: GlobalKey<FormState>(),
          editFunctionality: true,
          saveFunctionality: true,
        );

  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends InfoFormState<UserFormPage> {
  String selectedGender = "";
  List<String> selectedInterests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Form'),
      ),
      body: Form(
        key: widget.formKey,
        child: Column(
          children: [
            buildHeading(),
            Expanded(child: buildFormContent(context)),
          ],
        ),
      ),
    );
  }

  Widget buildFormContent(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          textFormEntry(
            title: "First Name",
            subTitle: "Enter your first name",
            validator: (value) => value?.isEmpty == true ? "Please enter first name" : null,
          ),
          SizedBox(height: 16.0),
          textFormEntry(
            title: "Last Name",
            subTitle: "Enter your last name",
            validator: (value) => value?.isEmpty == true ? "Please enter last name" : null,
          ),
          SizedBox(height: 16.0),
          textFormEntry(
            title: "Email",
            subTitle: "Enter your email address",
            validator: (value) {
              if (value?.isEmpty == true) return "Please enter email";
              if (value?.contains('@') != true) return "Please enter valid email";
              return null;
            },
          ),
          SizedBox(height: 16.0),
          textFormEntry(
            title: "Phone Number",
            subTitle: "Enter your phone number",
            validator: (value) => value?.isEmpty == true ? "Please enter phone number" : null,
          ),
          SizedBox(height: 16.0),
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
            validator: (value) => value?.isEmpty == true ? "Please select gender" : null,
            defaultValue: selectedGender.isEmpty ? null : selectedGender,
          ),
          SizedBox(height: 16.0),
          textFormEntry(
            title: "Date of Birth",
            subTitle: "Enter your date of birth (DD/MM/YYYY)",
            hint: "DD/MM/YYYY",
          ),
          SizedBox(height: 16.0),
          addressFormEntry(
            title: "Home Address",
            subTitle: "Enter your home address",
          ),
          SizedBox(height: 16.0),
          pictureFormEntry(
            title: "Profile Photo",
            subTitle: "Upload your profile photo",
          ),
          SizedBox(height: 16.0),
          multiSelectFormEntry(
            title: "Interests",
            subTitle: "Select your interests and hobbies",
            options: [
              'Sports',
              'Music',
              'Art',
              'Technology',
              'Reading',
              'Travel',
              'Cooking',
              'Photography',
              'Gaming',
              'Movies'
            ],
            onChanged: (selectedValues) {
              setState(() {
                selectedInterests = selectedValues;
              });
            },
            defaultValues: selectedInterests,
          ),
          SizedBox(height: 24.0),
        ],
      ),
    );
  }

  void onSave() {
    if (widget.formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User information saved successfully!')),
      );
    }
  }

  void onEdit() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit mode enabled')),
    );
  }
}

// Hospital Form
class HospitalFormPage extends InfoForm {
  HospitalFormPage({Key? key})
      : super(
          key: key,
          formKey: GlobalKey<FormState>(),
          editFunctionality: true,
          saveFunctionality: true,
        );

  @override
  _HospitalFormPageState createState() => _HospitalFormPageState();
}

class _HospitalFormPageState extends InfoFormState<HospitalFormPage> {
  String selectedHospitalType = "";
  List<String> selectedDepartments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospital Form'),
      ),
      body: Form(
        key: widget.formKey,
        child: Column(
          children: [
            buildHeading(),
            Expanded(child: buildFormContent(context)),
          ],
        ),
      ),
    );
  }

  Widget buildFormContent(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          textFormEntry(
            title: "Hospital Name",
            subTitle: "Enter the name of your hospital",
            validator: (value) => value?.isEmpty == true ? "Please enter hospital name" : null,
          ),
          SizedBox(height: 16.0),
          singleSelectFormEntry(
            title: "Hospital Type",
            subTitle: "Select the type of hospital",
            options: [
              'General Hospital',
              'Specialty Hospital',
              'Teaching Hospital',
              'Private Hospital',
              'Public Hospital',
              'Emergency Hospital',
              'Psychiatric Hospital',
              'Rehabilitation Hospital'
            ],
            onChanged: (value) {
              setState(() {
                selectedHospitalType = value ?? "";
              });
            },
            validator: (value) => value?.isEmpty == true ? "Please select hospital type" : null,
            defaultValue: selectedHospitalType,
          ),
          SizedBox(height: 16.0),
          textFormEntry(
            title: "Chief Medical Officer",
            subTitle: "Name of the Chief Medical Officer",
            validator: (value) => value?.isEmpty == true ? "Please enter CMO name" : null,
          ),
          SizedBox(height: 16.0),
          textFormEntry(
            title: "Phone Number",
            subTitle: "Main hospital phone number",
            validator: (value) => value?.isEmpty == true ? "Please enter phone number" : null,
          ),
          SizedBox(height: 16.0),
          textFormEntry(
            title: "Emergency Number",
            subTitle: "Emergency contact number",
            validator: (value) => value?.isEmpty == true ? "Please enter emergency number" : null,
          ),
          SizedBox(height: 16.0),
          addressFormEntry(
            title: "Hospital Address",
            subTitle: "Complete address of the hospital",
          ),
          SizedBox(height: 16.0),
          pictureFormEntry(
            title: "Hospital Photo",
            subTitle: "Upload a photo of your hospital",
          ),
          SizedBox(height: 16.0),
          numberSpinnerFormEntry(
            title: "Number of Beds",
            subTitle: "Total number of beds available",
            min: 1,
            max: 5000,
            defaultValue: 100,
          ),
          SizedBox(height: 16.0),
          switchFormEntry(
            title: "24/7 Emergency Service",
            subTitle: "Does your hospital offer 24/7 emergency services?",
            onToggle: (value) {},
            defaultValue: false,
          ),
          SizedBox(height: 16.0),
          multiSelectFormEntry(
            title: "Departments",
            subTitle: "Select all departments available in your hospital",
            options: [
              'Emergency',
              'Cardiology',
              'Neurology',
              'Orthopedics',
              'Pediatrics',
              'Oncology',
              'Radiology',
              'Surgery',
              'ICU',
              'Maternity'
            ],
            onChanged: (selectedValues) {
              setState(() {
                selectedDepartments = selectedValues;
              });
            },
            validator: (value) => value?.isEmpty == true ? "Please select at least one department" : null,
            defaultValues: selectedDepartments,
          ),
          SizedBox(height: 24.0),
        ],
      ),
    );
  }

  void onSave() {
    if (widget.formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hospital information saved successfully!')),
      );
    }
  }

  void onEdit() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit mode enabled')),
    );
  }
}
