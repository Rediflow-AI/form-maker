extension StringExtensions on String {
  bool isValidEmail() {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  bool isValidName() {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(this) && length >= 2;
  }

  bool isValidUrl() {
    return RegExp(r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$').hasMatch(this);
  }

  bool isValidSSNNumber() {
    return RegExp(r'^\d{3}-\d{2}-\d{4}$').hasMatch(this);
  }

  bool isValidNumber() {
    return RegExp(r'^\d+$').hasMatch(this);
  }

  bool isValidPostalCode() {
    // Simple postal code validation - can be enhanced based on country
    return RegExp(r'^[0-9A-Za-z\s\-]{3,10}$').hasMatch(this);
  }
}
