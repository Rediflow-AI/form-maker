class Address {
  String street;
  String city;
  String state;
  String postalCode;
  String country;

  Address({
    this.street = '',
    this.city = '',
    this.state = '',
    this.postalCode = '',
    this.country = '',
  });

  @override
  String toString() {
    return '$street, $city, $state $postalCode, $country';
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? '',
    );
  }
}
