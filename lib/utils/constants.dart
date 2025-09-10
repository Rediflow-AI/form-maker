import 'package:flutter/material.dart';
import '../models/user.dart';

// Colors
const Color primaryActiveColor = Color(0xFF2196F3);
const Color primaryCardColor = Color(0xFFF5F5F5);
const Color primaryGray = Color(0xFF9E9E9E);

// Padding and Spacing
const double tinyPadding = 4.0;
const double smallPadding = 8.0;
const double normalPadding = 16.0;
const double largePadding = 24.0;
const double xLargePadding = 32.0;

// Border Radius
final BorderRadius primaryBorderRadius = BorderRadius.circular(8.0);

// Image Radius
const double xlargeImageRadius = 50.0;

// Scaling Factor (for responsive design)
const double scalingFactor = 1.0;

// Text Styles
const TextStyle subHeadingDark = TextStyle(
  color: Colors.black87,
  fontSize: 14,
  fontWeight: FontWeight.w500,
);

const TextStyle subHeadingWhite = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.w500,
);

// Button Styles
final ButtonStyle primaryButton = ElevatedButton.styleFrom(
  backgroundColor: primaryActiveColor,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: primaryBorderRadius),
);

// Sample data for dropdowns
const List<String> CUISINE_TYPES = [
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
  'Greek',
  'Spanish',
  'Middle Eastern',
  'Other',
];

const List<UserRoles> ROLES = [
  UserRoles.Admin,
  UserRoles.Owner,
  UserRoles.Manager,
  UserRoles.Staff,
  UserRoles.Employee,
  UserRoles.Customer,
  UserRoles.Guest,
];
