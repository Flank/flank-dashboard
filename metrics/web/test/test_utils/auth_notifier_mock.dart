import 'package:flutter/cupertino.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:mockito/mockito.dart';

/// Mock implementation of the [AuthNotifier].
class AuthNotifierMock extends Mock
    with ChangeNotifier
    implements AuthNotifier {}
