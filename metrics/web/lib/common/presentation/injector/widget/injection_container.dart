import 'package:flutter/material.dart';
import 'package:metrics/auth/data/repositories/firebase_user_repository.dart';
import 'package:metrics/auth/domain/repositories/user_repository.dart';
import 'package:metrics/auth/domain/usecases/receive_authentication_updates.dart';
import 'package:metrics/auth/domain/usecases/sign_in_usecase.dart';
import 'package:metrics/auth/domain/usecases/sign_out_usecase.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/dashboard/data/repositories/firestore_metrics_repository.dart';
import 'package:metrics/dashboard/domain/repositories/metrics_repository.dart';
import 'package:metrics/dashboard/domain/usecases/receive_project_metrics_updates.dart';
import 'package:metrics/dashboard/domain/usecases/receive_project_updates.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:provider/provider.dart';

/// Creates the [ChangeNotifier]s and injects them, using the [MultiProvider] widget.
class InjectionContainer extends StatefulWidget {
  /// A child widget to display.
  final Widget child;

  /// A [MetricsRepository] used in created usecases.
  final MetricsRepository metricsRepository;

  /// A [UserRepository] used in created usecases.
  final UserRepository userRepository;

  /// Creates the [InjectionContainer].
  ///
  /// The [child] must not be null.
  ///
  /// [metricsRepository] is the [MetricsRepository] used in created usecases.
  /// If nothing or null passed, the [FirestoreMetricsRepository] used.
  /// [userRepository] is the [UserRepository] used in created usecases.
  /// If nothing or null passed, the [FirebaseUserRepository] used.
  const InjectionContainer({
    Key key,
    @required this.child,
    this.metricsRepository,
    this.userRepository,
  }) : super(key: key);

  @override
  _InjectionContainerState createState() => _InjectionContainerState();
}

class _InjectionContainerState extends State<InjectionContainer> {
  ReceiveProjectUpdates _receiveProjectUpdates;
  ReceiveProjectMetricsUpdates _receiveProjectMetricsUpdates;
  ReceiveAuthenticationUpdates _receiveAuthUpdates;
  SignInUseCase _signInUseCase;
  SignOutUseCase _signOutUseCase;

  @override
  void initState() {
    final _metricsRepository =
        widget.metricsRepository ?? FirestoreMetricsRepository();
    final _userRepository = widget.userRepository ?? FirebaseUserRepository();

    _receiveProjectUpdates = ReceiveProjectUpdates(_metricsRepository);
    _receiveProjectMetricsUpdates =
        ReceiveProjectMetricsUpdates(_metricsRepository);
    _receiveAuthUpdates = ReceiveAuthenticationUpdates(_userRepository);
    _signInUseCase = SignInUseCase(_userRepository);
    _signOutUseCase = SignOutUseCase(_userRepository);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthNotifier>(
          create: (_) => AuthNotifier(
            _receiveAuthUpdates,
            _signInUseCase,
            _signOutUseCase,
          ),
        ),
        ChangeNotifierProxyProvider<AuthNotifier, ProjectMetricsNotifier>(
          create: (_) => ProjectMetricsNotifier(
            _receiveProjectUpdates,
            _receiveProjectMetricsUpdates,
          ),
          update: _subscribeToProjectUpdates,
        ),
        ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier())
      ],
      child: widget.child,
    );
  }

  /// Subscribes to project updates if user is logged in.
  ProjectMetricsNotifier _subscribeToProjectUpdates(
    BuildContext context,
    AuthNotifier authNotifier,
    ProjectMetricsNotifier projectMetricsNotifier,
  ) {
    final isLoggedIn = authNotifier.isLoggedIn;
    if (isLoggedIn != null && isLoggedIn) {
      return projectMetricsNotifier..subscribeToProjects();
    }

    return projectMetricsNotifier;
  }
}
