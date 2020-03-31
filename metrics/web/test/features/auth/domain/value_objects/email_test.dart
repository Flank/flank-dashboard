import 'package:metrics/features/auth/domain/exceptions/validation_exception.dart';
import 'package:metrics/features/auth/domain/value_objects/email.dart';
import 'package:test/test.dart';

void main() {
  group('Validate email', () {
    test('Throw validation error if empty value was provided', () {
      expect(() => Email(''), throwsA(isA<ValidationException>()));
    });

    test(
        'Throw validation error with correcting message if empty value was provided',
        () {
      const exceptionMessage = 'Email address is required';
      final Matcher matcher = throwsA((e) => e.message == exceptionMessage);

      expect(() => Email(''), matcher);
    });

    test(
        'Throw validation error if a value, provided for an email is not in the right format',
        () {
      final List<String> emails = getEmailsInInvalidFormat();

      for (final String email in emails) {
        expect(() => Email(email), throwsA(isA<ValidationException>()));
      }
    });
  });
}

List<String> getEmailsInInvalidFormat() {
  return [
    'plainaddress',
    '#@%^%#\$@#\$@#.com',
    '@example.com',
    'Joe Smith <email@example.com>',
    'email.example.com',
    'email@example@example.com',
    '.email@example.com',
    'email.@example.com',
    'email..email@example.com',
    'email@example.com (Joe Smith)',
    'email@example',
    'email@-example.com',
    'email@111.222.333.44444',
    'email@example..com',
    'Abc..123@example.com',
    '”(),:;<>[\\\]@example.com',
    'this\\ is"really"not\\allowed@example.com',

//    'just”not”right@example.com',
//    'email@example.web',
//  あいうえお@example.com
  ];
}
