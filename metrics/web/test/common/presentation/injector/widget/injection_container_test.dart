import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/domain/entities/user.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/injector/widget/injection_container.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../../test_utils/metrics_repository_mock.dart';
import '../../../../test_utils/user_repository_mock.dart';

void main() {
  group("InjectionContainer", () {
    testWidgets(
      "subscribes to project updates on user signed in",
      (tester) async {
        final childKey = GlobalKey();
        final userController = StreamController<User>();
        final metricsRepository = MetricsRepositoryMock();
        final userRepository = UserRepositoryMock();

        when(userRepository.authenticationStream())
            .thenAnswer((_) => userController.stream);
        when(userRepository.signInWithEmailAndPassword(any, any))
            .thenAnswer((_) async => userController.add(User(id: 'id')));
        when(metricsRepository.projectsStream())
            .thenAnswer((_) => Stream.value([]));

        await tester.pumpWidget(InjectionContainer(
          metricsRepository: metricsRepository,
          userRepository: userRepository,
          child: Container(
            key: childKey,
          ),
        ));

        final currentContext = childKey.currentContext;
        final authNotifier = Provider.of<AuthNotifier>(
          currentContext,
          listen: false,
        );

        authNotifier.subscribeToAuthenticationUpdates();
        await authNotifier.signInWithEmailAndPassword('email', 'password');

        final metricsNotifier = Provider.of<ProjectMetricsNotifier>(
          currentContext,
          listen: false,
        );

        metricsNotifier.addListener(expectAsyncUntil0(
            () {}, () => metricsNotifier.projectsMetrics != null));
      },
    );
  });
}
