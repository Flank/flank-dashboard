// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/auth/domain/entities/authentication_exception.dart';
import 'package:test/test.dart';

/// A matcher that can be used to detect that test case throws
/// an [AssertionError].
final Matcher throwsAssertionError = throwsA(isA<AssertionError>());

/// A matcher that can be used to detect that test case throws
/// an [AuthenticationException].
final Matcher throwsAuthenticationException =
    throwsA(isA<AuthenticationException>());

/// A matcher that can be used to verify that the value is equal to `1`.
final Matcher once = equals(1);
