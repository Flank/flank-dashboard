import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:mockito/mockito.dart';

class AuthNotifierMock extends Mock
    with ChangeNotifier
    implements AuthNotifier {}
