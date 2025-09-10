class WorkingHour {
  String day;
  String openTime;
  String closeTime;
  bool isOpen;

  WorkingHour({
    required this.day,
    this.openTime = '09:00',
    this.closeTime = '17:00',
    this.isOpen = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'openTime': openTime,
      'closeTime': closeTime,
      'isOpen': isOpen,
    };
  }

  factory WorkingHour.fromJson(Map<String, dynamic> json) {
    return WorkingHour(
      day: json['day'],
      openTime: json['openTime'] ?? '09:00',
      closeTime: json['closeTime'] ?? '17:00',
      isOpen: json['isOpen'] ?? true,
    );
  }

  @override
  String toString() {
    if (!isOpen) return '$day: Closed';
    return '$day: $openTime - $closeTime';
  }
}

enum UserRoles {
  Admin,
  Owner,
  Manager,
  Staff,
  Employee,
  Customer,
  Guest,
}
