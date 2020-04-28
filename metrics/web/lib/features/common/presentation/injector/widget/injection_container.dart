import 'package:flutter/material.dart';
import 'package:metrics/features/auth/data/repositories/firebase_user_repository.dart';
import 'package:metrics/features/auth/domain/usecases/receive_authentication_updates.dart';
import 'package:metrics/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:metrics/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:metrics/features/auth/presentation/state/auth_store.dart';
import 'package:metrics/features/common/presentation/metrics_theme/store/theme_store.dart';
import 'package:metrics/features/dashboard/data/repositories/firestore_metrics_repository.dart';
import 'package:metrics/features/dashboard/domain/usecases/receive_project_metrics_updates.dart';
import 'package:metrics/features/dashboard/domain/usecases/receive_project_updates.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

/// Creates project stores and injects it using the [Injector] widget.
class InjectionContainer extends StatefulWidget {
  final Widget child;

  const InjectionContainer({
    Key key,
    @required this.child,
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
    final _metricsRepository = FirestoreMetricsRepository();
    final _userRepository = FirebaseUserRepository();

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
    return Injector(
      inject: [
        Inject<ProjectMetricsStore>(() => ProjectMetricsStore(
              _receiveProjectUpdates,
              _receiveProjectMetricsUpdates,
            )),
        Inject<AuthStore>(() => AuthStore(
              _receiveAuthUpdates,
              _signInUseCase,
              _signOutUseCase,
            )),
        Inject<ThemeStore>(() => ThemeStore()),
      ],
      dispose: _dispose,
      initState: _initInjectorState,
      builder: (BuildContext context) => widget.child,
    );
  }

  /// Initiates the injector state.
  void _initInjectorState() {
    Injector.getAsReactive<ThemeStore>().setState(
      (store) => store.isDark = true,
      catchError: true,
    );
    Injector.getAsReactive<AuthStore>()
        .setState((store) => store.subscribeToAuthenticationUpdates());
  }

  /// Disposes the injected models.
  void _dispose() {
    Injector.get<ProjectMetricsStore>().dispose();
    Injector.get<AuthStore>().dispose();
  }
}
