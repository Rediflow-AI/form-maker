import 'package:flutter_test/flutter_test.dart';
import 'package:form_maker/form_maker_library.dart';

void main() {
  test('Address model test', () {
    final address = Address(
      street: '123 Main St',
      city: 'New York',
      state: 'NY',
      postalCode: '10001',
      country: 'USA',
    );
    
    expect(address.street, '123 Main St');
    expect(address.city, 'New York');
    expect(address.toString(), '123 Main St, New York, NY 10001, USA');
  });

  test('Currency enum test', () {
    expect(Currencies.usd.displayName, 'US Dollar');
    expect(Currencies.usd.symbol, '\$');
    expect(Currencies.eur.displayName, 'Euro');
    expect(Currencies.eur.symbol, '€');
  });

  test('WorkingHour model test', () {
    final workingHour = WorkingHour(
      day: 'Monday',
      openTime: '09:00',
      closeTime: '17:00',
      isOpen: true,
    );
    
    expect(workingHour.day, 'Monday');
    expect(workingHour.isOpen, true);
    expect(workingHour.toString(), 'Monday: 09:00 - 17:00');
    
    final closedDay = WorkingHour(day: 'Sunday', isOpen: false);
    expect(closedDay.toString(), 'Sunday: Closed');
  });
}
