import 'dart:io';
import 'package:flutter/material.dart';
import 'package:form_maker/form_maker_library.dart';
import 'package:image_picker/image_picker.dart';

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

class _TabbedFormPageState extends State<TabbedFormPage>
    with SingleTickerProviderStateMixin {
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
  List<XFile> selectedXFilePhotos = []; // For web compatibility
  List<String> selectedServices = [];

  // Text controllers to capture form data
  final TextEditingController nameController = TextEditingController();
  final TextEditingController taglineController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

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
          // Profile picture at the top
          pictureFormEntry(
            title: "Restaurant Logo",
            subTitle: "Upload your restaurant's logo or main photo",
          ),
          SizedBox(height: 24.0),

          textFormEntry(
            title: "Restaurant Name",
            subTitle: "Enter the name of your restaurant",
            validator: (value) =>
                value?.isEmpty == true ? "Please enter restaurant name" : null,
            iconData: Icons.restaurant,
            controller: nameController,
          ),
          SizedBox(height: 16.0),

          textFormEntry(
            title: "Tagline",
            subTitle: "Your restaurant's catchy tagline or slogan",
            hint: "e.g., 'Authentic flavors from Italy'",
            iconData: Icons.format_quote,
            controller: taglineController,
          ),
          SizedBox(height: 16.0),

          singleSelectFormEntry(
            title: "Cuisine Type",
            subTitle: "Primary cuisine you specialize in",
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
              'Fusion',
              'Steakhouse',
              'Seafood',
              'Vegetarian/Vegan',
              'Other'
            ],
            onChanged: (value) {
              setState(() {
                selectedCuisineType = value ?? "";
              });
            },
            validator: (value) =>
                value?.isEmpty == true ? "Please select cuisine type" : null,
            defaultValue: selectedCuisineType,
          ),
          SizedBox(height: 16.0),

          singleSelectFormEntry(
            title: "Dining Style",
            subTitle: "What type of dining experience do you offer?",
            options: [
              'Fine Dining',
              'Casual Dining',
              'Fast Casual',
              'Quick Service',
              'Food Truck',
              'Buffet',
              'Cafe/Bistro',
              'Sports Bar',
              'Family Restaurant',
              'Pop-up Restaurant'
            ],
            onChanged: (value) {
              setState(() {
                selectedRestaurantType = value ?? "";
              });
            },
            validator: (value) =>
                value?.isEmpty == true ? "Please select dining style" : null,
            defaultValue: selectedRestaurantType,
          ),
          SizedBox(height: 16.0),

          textFormEntry(
            title: "Chef/Owner Name",
            subTitle: "Name of the head chef or restaurant owner",
            iconData: Icons.person_outline,
          ),
          SizedBox(height: 16.0),

          Row(
            children: [
              Expanded(
                child: textFormEntry(
                  title: "Phone Number",
                  subTitle: "Main contact number",
                  iconData: Icons.phone,
                  validator: (value) => value?.isEmpty == true
                      ? "Please enter phone number"
                      : null,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: textFormEntry(
                  title: "Reservation Phone",
                  subTitle: "For reservations (if different)",
                  iconData: Icons.event_seat,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          textFormEntry(
            title: "Website URL",
            subTitle: "Your restaurant's website",
            hint: "https://www.yourrestaurant.com",
            iconData: Icons.web,
            controller: websiteController,
          ),
          SizedBox(height: 16.0),

          addressFormEntry(
            title: "Restaurant Location",
            subTitle: "Complete address where customers can find you",
          ),
          SizedBox(height: 16.0),

          phoneFormEntry(
            title: "Restaurant Phone",
            subTitle: "Contact number for reservations and inquiries",
            showVerifyButton: false,
            onSaved: (value) => phoneController.text = value ?? "",
          ),
          SizedBox(height: 16.0),

          postalCodeFormEntry(
            title: "Postal Code",
            subTitle: "ZIP code for your restaurant location",
            onSaved: (value) => postalCodeController.text = value ?? "",
          ),
          SizedBox(height: 16.0),

          multiPhotoFormEntry(
            title: "Restaurant Gallery",
            subTitle: "Upload photos of your restaurant, dishes, and ambiance",
            selectedImages: selectedPhotos,
            onImagesSelected: (photos) {
              setState(() {
                selectedPhotos = photos;
              });
            },
            onXFilesSelected: (xFiles) {
              setState(() {
                selectedXFilePhotos = xFiles;
              });
            },
            maxImages: 8,
          ),
          SizedBox(height: 16.0),

          Row(
            children: [
              Expanded(
                child: numberSpinnerFormEntry(
                  title: "Seating Capacity",
                  subTitle: "Maximum number of guests",
                  min: 1,
                  max: 500,
                  defaultValue: 50,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: numberSpinnerFormEntry(
                  title: "Average Price",
                  subTitle: "Price per person (USD)",
                  min: 5,
                  max: 200,
                  defaultValue: 25,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          switchFormEntry(
            title: "Currently Open",
            subTitle: "Are you currently serving customers?",
            onToggle: (value) {},
            defaultValue: true,
          ),
          SizedBox(height: 16.0),

          switchFormEntry(
            title: "Accept Reservations",
            subTitle: "Do you take table reservations?",
            onToggle: (value) {},
            defaultValue: true,
          ),
          SizedBox(height: 16.0),

          multiSelectFormEntry(
            title: "Service Options",
            subTitle: "What services do you offer?",
            options: [
              'Dine-in',
              'Takeout',
              'Delivery',
              'Curbside Pickup',
              'Catering',
              'Private Events',
              'Online Ordering',
              'Table Reservations',
              'Happy Hour',
              'Live Music',
              'Outdoor Seating',
              'Pet Friendly'
            ],
            onChanged: (selectedValues) {
              setState(() {
                selectedServices = selectedValues;
              });
            },
            validator: (value) => value?.isEmpty == true
                ? "Please select at least one service"
                : null,
            defaultValues: selectedServices,
          ),
          SizedBox(height: 24.0),

          // Show Form Data Button
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => save(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Show Form Data',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(height: 24.0),
        ],
      ),
    );
  }

  @override
  Future<void> save() async {
    if (widget.formKey.currentState!.validate()) {
      widget.formKey.currentState!.save();

      // Collect form data
      Map<String, dynamic> formData = {
        'Restaurant Name': nameController.text,
        'Tagline': taglineController.text,
        'Website URL': websiteController.text,
        'Cuisine Type':
            selectedCuisineType.isEmpty ? 'Not selected' : selectedCuisineType,
        'Selected Services': selectedServices.isEmpty
            ? 'None selected'
            : selectedServices.join(', '),
        'Photo Count':
            '${selectedPhotos.length + selectedXFilePhotos.length} photos uploaded',
        'Has Address': 'Address field completed',
        'Has Phone': 'Phone number field present',
        'Has Postal Code': 'Postal code field present',
      };

      // Show popup with form data
      _showFormDataPopup(context, 'Restaurant Form Data', formData);
    }
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

  void _showFormDataPopup(
      BuildContext context, String title, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: data.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                      children: [
                        TextSpan(
                          text: '${entry.key}: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: entry.value.toString(),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
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

  // Text controllers to capture form data
  final TextEditingController institutionNameController =
      TextEditingController();
  final TextEditingController establishedYearController =
      TextEditingController();

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
          // Profile picture at the top
          pictureFormEntry(
            title: "School Logo",
            subTitle:
                "Upload your school's official logo or main building photo",
          ),
          SizedBox(height: 24.0),

          textFormEntry(
            title: "Institution Name",
            subTitle: "Official name of your educational institution",
            validator: (value) =>
                value?.isEmpty == true ? "Please enter institution name" : null,
            iconData: Icons.school,
            controller: institutionNameController,
          ),
          SizedBox(height: 16.0),

          textFormEntry(
            title: "School Motto",
            subTitle: "Your institution's motto or mission statement",
            hint: "e.g., 'Excellence in Education'",
            iconData: Icons.star_outline,
            controller: establishedYearController,
          ),
          SizedBox(height: 16.0),

          singleSelectFormEntry(
            title: "Institution Type",
            subTitle: "What type of educational institution is this?",
            options: [
              'Public Elementary School',
              'Private Elementary School',
              'Public Middle School',
              'Private Middle School',
              'Public High School',
              'Private High School',
              'Charter School',
              'Montessori School',
              'International School',
              'Technical College',
              'Community College',
              'University',
              'Online Academy'
            ],
            onChanged: (value) {
              setState(() {
                selectedSchoolType = value ?? "";
              });
            },
            validator: (value) => value?.isEmpty == true
                ? "Please select institution type"
                : null,
            defaultValue: selectedSchoolType,
          ),
          SizedBox(height: 16.0),

          Row(
            children: [
              Expanded(
                child: textFormEntry(
                  title: "Principal/Dean",
                  subTitle: "Head of institution",
                  validator: (value) => value?.isEmpty == true
                      ? "Please enter principal/dean name"
                      : null,
                  iconData: Icons.person_outline,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: textFormEntry(
                  title: "Founded Year",
                  subTitle: "Year established",
                  hint: "e.g., 1985",
                  iconData: Icons.history,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          Row(
            children: [
              Expanded(
                child: textFormEntry(
                  title: "Main Phone",
                  subTitle: "Primary contact number",
                  validator: (value) => value?.isEmpty == true
                      ? "Please enter phone number"
                      : null,
                  iconData: Icons.phone,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: textFormEntry(
                  title: "Admissions Phone",
                  subTitle: "For new enrollments",
                  iconData: Icons.how_to_reg,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          textFormEntry(
            title: "Official Email",
            subTitle: "Main institutional email address",
            validator: (value) {
              if (value?.isEmpty == true) return "Please enter email";
              if (value?.contains('@') != true)
                return "Please enter valid email";
              return null;
            },
            iconData: Icons.email,
          ),
          SizedBox(height: 16.0),

          textFormEntry(
            title: "Website",
            subTitle: "School's official website",
            hint: "https://www.yourschool.edu",
            iconData: Icons.web,
          ),
          SizedBox(height: 16.0),

          addressFormEntry(
            title: "Campus Address",
            subTitle: "Main campus location and postal address",
          ),
          SizedBox(height: 16.0),

          Row(
            children: [
              Expanded(
                child: numberSpinnerFormEntry(
                  title: "Student Enrollment",
                  subTitle: "Total current students",
                  min: 10,
                  max: 50000,
                  defaultValue: 500,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: numberSpinnerFormEntry(
                  title: "Faculty Count",
                  subTitle: "Number of teachers/staff",
                  min: 5,
                  max: 2000,
                  defaultValue: 50,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          Row(
            children: [
              Expanded(
                child: numberSpinnerFormEntry(
                  title: "Graduation Rate",
                  subTitle: "Percentage (%)",
                  min: 50,
                  max: 100,
                  defaultValue: 92,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: numberSpinnerFormEntry(
                  title: "Student-Teacher Ratio",
                  subTitle: "Students per teacher",
                  min: 5,
                  max: 30,
                  defaultValue: 15,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          switchFormEntry(
            title: "Currently Enrolling",
            subTitle: "Are you accepting new student applications?",
            onToggle: (value) {},
            defaultValue: true,
          ),
          SizedBox(height: 16.0),

          switchFormEntry(
            title: "Accredited Institution",
            subTitle: "Is your institution officially accredited?",
            onToggle: (value) {},
            defaultValue: true,
          ),
          SizedBox(height: 16.0),

          multiSelectFormEntry(
            title: "Campus Facilities",
            subTitle: "What facilities are available on your campus?",
            options: [
              'Main Library',
              'Computer Labs',
              'Science Laboratories',
              'Athletic Facilities',
              'Gymnasium',
              'Swimming Pool',
              'Auditorium/Theater',
              'Art Studios',
              'Music Rooms',
              'Cafeteria',
              'Student Housing',
              'Parking',
              'Medical Clinic',
              'Counseling Center',
              'Career Services',
              'Research Centers'
            ],
            onChanged: (selectedValues) {
              setState(() {
                selectedFacilities = selectedValues;
              });
            },
            defaultValues: selectedFacilities,
          ),
          SizedBox(height: 24.0),

          // Show Form Data Button
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => save(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Show Form Data',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(height: 24.0),
        ],
      ),
    );
  }

  @override
  Future<void> save() async {
    if (widget.formKey.currentState!.validate()) {
      widget.formKey.currentState!.save();

      // Collect form data
      Map<String, dynamic> formData = {
        'Institution Name': institutionNameController.text,
        'School Motto': establishedYearController.text,
        'School Type':
            selectedSchoolType.isEmpty ? 'Not selected' : selectedSchoolType,
        'Campus Facilities': selectedFacilities.isEmpty
            ? 'None selected'
            : selectedFacilities.join(', '),
        'Accredited': 'Accreditation status available',
        'Has School Logo': 'Logo upload available',
        'Has Address': 'Address field completed',
      };

      // Show popup with form data
      _showFormDataPopup(context, 'School Form Data', formData);
    }
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

  void _showFormDataPopup(
      BuildContext context, String title, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: data.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                      children: [
                        TextSpan(
                          text: '${entry.key}: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: entry.value.toString(),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
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

  // Text controllers to capture form data
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneUserController = TextEditingController();

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
          // Profile picture at the top
          pictureFormEntry(
            title: "Profile Photo",
            subTitle: "Upload a professional or personal photo",
          ),
          SizedBox(height: 24.0),

          Row(
            children: [
              Expanded(
                child: textFormEntry(
                  title: "First Name",
                  subTitle: "Your given name",
                  validator: (value) =>
                      value?.isEmpty == true ? "Please enter first name" : null,
                  iconData: Icons.person,
                  controller: firstNameController,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: textFormEntry(
                  title: "Last Name",
                  subTitle: "Your family name",
                  validator: (value) =>
                      value?.isEmpty == true ? "Please enter last name" : null,
                  iconData: Icons.person_outline,
                  controller: lastNameController,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          textFormEntry(
            title: "Display Name/Username",
            subTitle: "How would you like others to see you?",
            hint: "e.g., john_doe, JohnD, etc.",
            iconData: Icons.alternate_email,
            controller: displayNameController,
          ),
          SizedBox(height: 16.0),

          textFormEntry(
            title: "Email Address",
            subTitle: "Your primary email for communication",
            validator: (value) {
              if (value?.isEmpty == true) return "Please enter email";
              if (value?.contains('@') != true)
                return "Please enter valid email";
              return null;
            },
            iconData: Icons.email,
            controller: emailController,
          ),
          SizedBox(height: 16.0),

          phoneFormEntry(
            title: "Phone Number",
            subTitle: "Your contact phone number",
            showVerifyButton: false,
            onSaved: (value) => phoneUserController.text = value ?? "",
          ),
          SizedBox(height: 16.0),

          Row(
            children: [
              Expanded(
                child: textFormEntry(
                  title: "Primary Phone",
                  subTitle: "Main contact number",
                  validator: (value) => value?.isEmpty == true
                      ? "Please enter phone number"
                      : null,
                  iconData: Icons.phone,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: textFormEntry(
                  title: "Emergency Contact",
                  subTitle: "Backup contact number",
                  iconData: Icons.contact_phone,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          textFormEntry(
            title: "Date of Birth",
            subTitle: "When were you born? (MM/DD/YYYY)",
            hint: "MM/DD/YYYY",
            iconData: Icons.cake,
          ),
          SizedBox(height: 16.0),

          radioButtonFormEntry<String>(
            title: "Gender Identity",
            subTitle: "How do you identify?",
            options: ['Male', 'Female', 'Non-binary', 'Prefer not to say'],
            getDisplayText: (value) => value,
            onChanged: (value) {
              setState(() {
                selectedGender = value ?? "";
              });
            },
            defaultValue: selectedGender.isEmpty ? null : selectedGender,
          ),
          SizedBox(height: 16.0),

          textFormEntry(
            title: "Occupation",
            subTitle: "What do you do for work?",
            hint: "e.g., Software Engineer, Teacher, Student",
            iconData: Icons.work,
          ),
          SizedBox(height: 16.0),

          textFormEntry(
            title: "LinkedIn Profile",
            subTitle: "Your professional LinkedIn URL (optional)",
            hint: "https://linkedin.com/in/yourname",
            iconData: Icons.business_center,
          ),
          SizedBox(height: 16.0),

          addressFormEntry(
            title: "Home Address",
            subTitle: "Your current residential address",
          ),
          SizedBox(height: 16.0),

          textFormEntry(
            title: "Bio/About Me",
            subTitle: "Tell us a bit about yourself",
            hint:
                "A short description about your background, interests, or goals...",
            iconData: Icons.info_outline,
          ),
          SizedBox(height: 16.0),

          switchFormEntry(
            title: "Public Profile",
            subTitle: "Make your profile visible to others?",
            onToggle: (value) {},
            defaultValue: false,
          ),
          SizedBox(height: 16.0),

          switchFormEntry(
            title: "Email Notifications",
            subTitle: "Receive updates and newsletters?",
            onToggle: (value) {},
            defaultValue: true,
          ),
          SizedBox(height: 16.0),

          multiSelectFormEntry(
            title: "Skills & Interests",
            subTitle: "What are you passionate about or skilled in?",
            options: [
              'Programming/Coding',
              'Digital Marketing',
              'Graphic Design',
              'Photography',
              'Writing/Blogging',
              'Music Production',
              'Video Editing',
              'Public Speaking',
              'Project Management',
              'Data Analysis',
              'Sports & Fitness',
              'Travel & Adventure',
              'Cooking & Baking',
              'Reading & Literature',
              'Gaming',
              'Art & Crafts',
              'Volunteering',
              'Entrepreneurship'
            ],
            onChanged: (selectedValues) {
              setState(() {
                selectedInterests = selectedValues;
              });
            },
            defaultValues: selectedInterests,
          ),
          SizedBox(height: 24.0),

          // Show Form Data Button
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => save(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Show Form Data',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(height: 24.0),
        ],
      ),
    );
  }

  @override
  Future<void> save() async {
    if (widget.formKey.currentState!.validate()) {
      widget.formKey.currentState!.save();

      // Collect form data
      Map<String, dynamic> formData = {
        'First Name': firstNameController.text,
        'Last Name': lastNameController.text,
        'Display Name': displayNameController.text,
        'Email Address': emailController.text,
        'Gender': selectedGender.isEmpty ? 'Not selected' : selectedGender,
        'Interests': selectedInterests.isEmpty
            ? 'None selected'
            : selectedInterests.join(', '),
        'Date of Birth': 'Date picker available',
        'Bio/About': 'Bio text area available',
        'Has Profile Photo': 'Profile photo upload available',
        'Has Phone Number': 'Phone number field present',
        'Has Address': 'Address field completed',
      };

      // Show popup with form data
      _showFormDataPopup(context, 'User Form Data', formData);
    }
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

  void _showFormDataPopup(
      BuildContext context, String title, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: data.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                      children: [
                        TextSpan(
                          text: '${entry.key}: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: entry.value.toString(),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
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
  List<WorkingHour> operatingHours = [];

  // Text controllers to capture form data
  final TextEditingController hospitalNameController = TextEditingController();
  final TextEditingController establishedController = TextEditingController();

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
          // Profile picture at the top
          pictureFormEntry(
            title: "Hospital Main Building",
            subTitle:
                "Upload a photo of your hospital's main entrance or building",
          ),
          SizedBox(height: 24.0),

          textFormEntry(
            title: "Medical Center Name",
            subTitle: "Official name of your healthcare facility",
            validator: (value) => value?.isEmpty == true
                ? "Please enter medical center name"
                : null,
            iconData: Icons.local_hospital,
            controller: hospitalNameController,
          ),
          SizedBox(height: 16.0),

          textFormEntry(
            title: "Hospital ID/License",
            subTitle: "Official registration or license number",
            hint: "e.g., MC-2024-001",
            iconData: Icons.badge,
            controller: establishedController,
          ),
          SizedBox(height: 16.0),

          singleSelectFormEntry(
            title: "Healthcare Facility Type",
            subTitle: "What type of medical facility is this?",
            options: [
              'General Hospital',
              'Children\'s Hospital',
              'Specialty Hospital',
              'Teaching Hospital',
              'Trauma Center',
              'Rehabilitation Center',
              'Psychiatric Hospital',
              'Cancer Treatment Center',
              'Cardiac Care Center',
              'Outpatient Clinic',
              'Urgent Care Center',
              'Veterans Hospital',
              'Private Medical Center'
            ],
            onChanged: (value) {
              setState(() {
                selectedHospitalType = value ?? "";
              });
            },
            validator: (value) =>
                value?.isEmpty == true ? "Please select facility type" : null,
            defaultValue: selectedHospitalType,
          ),
          SizedBox(height: 16.0),

          Row(
            children: [
              Expanded(
                child: textFormEntry(
                  title: "Chief Medical Officer",
                  subTitle: "CMO or Medical Director",
                  validator: (value) =>
                      value?.isEmpty == true ? "Please enter CMO name" : null,
                  iconData: Icons.person,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: textFormEntry(
                  title: "Administrator",
                  subTitle: "Hospital Administrator/CEO",
                  iconData: Icons.business_center,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          Row(
            children: [
              Expanded(
                child: textFormEntry(
                  title: "Main Phone",
                  subTitle: "General hospital number",
                  validator: (value) => value?.isEmpty == true
                      ? "Please enter phone number"
                      : null,
                  iconData: Icons.phone,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: textFormEntry(
                  title: "Emergency Hotline",
                  subTitle: "24/7 emergency contact",
                  validator: (value) => value?.isEmpty == true
                      ? "Please enter emergency number"
                      : null,
                  iconData: Icons.emergency,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          textFormEntry(
            title: "Patient Services Line",
            subTitle: "For appointments and patient inquiries",
            iconData: Icons.support_agent,
          ),
          SizedBox(height: 16.0),

          textFormEntry(
            title: "Hospital Website",
            subTitle: "Official medical center website",
            hint: "https://www.yourhospital.com",
            iconData: Icons.web,
          ),
          SizedBox(height: 16.0),

          addressFormEntry(
            title: "Medical Center Address",
            subTitle: "Complete address for patient visits and emergencies",
          ),
          SizedBox(height: 16.0),

          // Operating Hours Section
          Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.blue),
                      SizedBox(width: 8.0),
                      Text(
                        "Operating Hours",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "Set the hospital's visiting hours and operating schedule",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  SizedBox(height: 16.0),
                  WorkingHoursWidget(
                    isEnabled: true, // Always enabled for editing
                    onChanged: (hours) {
                      setState(() {
                        operatingHours = hours;
                      });
                    },
                    workingHours: operatingHours,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.0),

          Row(
            children: [
              Expanded(
                child: numberSpinnerFormEntry(
                  title: "Total Bed Capacity",
                  subTitle: "All available beds",
                  min: 10,
                  max: 2000,
                  defaultValue: 200,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: numberSpinnerFormEntry(
                  title: "ICU Beds",
                  subTitle: "Intensive care units",
                  min: 1,
                  max: 200,
                  defaultValue: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          Row(
            children: [
              Expanded(
                child: numberSpinnerFormEntry(
                  title: "Operating Rooms",
                  subTitle: "Number of OR suites",
                  min: 1,
                  max: 50,
                  defaultValue: 8,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: numberSpinnerFormEntry(
                  title: "Medical Staff",
                  subTitle: "Doctors and nurses",
                  min: 10,
                  max: 5000,
                  defaultValue: 150,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          switchFormEntry(
            title: "24/7 Emergency Services",
            subTitle: "Round-the-clock emergency department?",
            onToggle: (value) {},
            defaultValue: true,
          ),
          SizedBox(height: 16.0),

          switchFormEntry(
            title: "Trauma Center",
            subTitle: "Designated trauma treatment facility?",
            onToggle: (value) {},
            defaultValue: false,
          ),
          SizedBox(height: 16.0),

          switchFormEntry(
            title: "Teaching Hospital",
            subTitle: "Medical education and residency programs?",
            onToggle: (value) {},
            defaultValue: false,
          ),
          SizedBox(height: 16.0),

          multiSelectFormEntry(
            title: "Medical Departments",
            subTitle: "What specialized departments do you have?",
            options: [
              'Emergency Medicine',
              'Internal Medicine',
              'Surgery',
              'Cardiology',
              'Neurology',
              'Orthopedics',
              'Pediatrics',
              'Obstetrics & Gynecology',
              'Oncology',
              'Radiology',
              'Anesthesiology',
              'Pathology',
              'Psychiatry',
              'Dermatology',
              'Ophthalmology',
              'ENT (Otolaryngology)',
              'Urology',
              'Nephrology',
              'Endocrinology',
              'Rehabilitation Medicine',
              'Intensive Care Unit',
              'Neonatal ICU',
              'Burn Unit',
              'Transplant Center'
            ],
            onChanged: (selectedValues) {
              setState(() {
                selectedDepartments = selectedValues;
              });
            },
            validator: (value) => value?.isEmpty == true
                ? "Please select at least one department"
                : null,
            defaultValues: selectedDepartments,
          ),
          SizedBox(height: 24.0),

          // Show Form Data Button
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => save(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Show Form Data',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(height: 24.0),
        ],
      ),
    );
  }

  @override
  Future<void> save() async {
    if (widget.formKey.currentState!.validate()) {
      widget.formKey.currentState!.save();

      // Collect form data
      Map<String, dynamic> formData = {
        'Medical Center Name': hospitalNameController.text,
        'Hospital ID/License': establishedController.text,
        'Hospital Type': selectedHospitalType.isEmpty
            ? 'Not selected'
            : selectedHospitalType,
        'Departments': selectedDepartments.isEmpty
            ? 'None selected'
            : selectedDepartments.join(', '),
        'Bed Capacity': 'Capacity information available',
        'Emergency Services': '24/7 emergency services',
        'Has Hospital Photo': 'Building photo upload available',
        'Has Address': 'Address field completed',
        'Accreditation': 'Hospital accreditation status',
        'Operating Hours': operatingHours.isEmpty
            ? 'No hours set'
            : operatingHours
                .map((hour) =>
                    '${hour.day}: ${hour.isOpen ? "${hour.openTime} - ${hour.closeTime}" : "Closed"}')
                .join('\n'),
      };

      // Show popup with form data
      _showFormDataPopup(context, 'Hospital Form Data', formData);
    }
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

  void _showFormDataPopup(
      BuildContext context, String title, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: data.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                      children: [
                        TextSpan(
                          text: '${entry.key}: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: entry.value.toString(),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
