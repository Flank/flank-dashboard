import 'package:flutter/material.dart';
import 'package:metrics/auth/data/repositories/firebase_user_repository.dart';
import 'package:metrics/auth/domain/usecases/receive_authentication_updates.dart';
import 'package:metrics/auth/domain/usecases/sign_in_usecase.dart';
import 'package:metrics/auth/domain/usecases/sign_out_usecase.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/state/projects_notifier.dart';
import 'package:metrics/dashboard/data/repositories/firestore_metrics_repository.dart';
import 'package:metrics/dashboard/domain/usecases/receive_project_metrics_updates.dart';
import 'package:metrics/dashboard/domain/usecases/receive_project_updates.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/project_groups/data/repositories/firestore_project_group_repository.dart';
import 'package:metrics/project_groups/domain/usecases/add_project_group_usecase.dart';
import 'package:metrics/project_groups/domain/usecases/delete_project_group_usecase.dart';
import 'package:metrics/project_groups/domain/usecases/receive_project_group_updates.dart';
import 'package:metrics/project_groups/domain/usecases/update_project_group_usecase.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:provider/provider.dart';

/// Creates the [ChangeNotifier]s and injects them, using the [MultiProvider] widget.
class InjectionContainer extends StatefulWidget {
  /// A child widget to display.
  final Widget child;

  /// Creates the [InjectionContainer].
  ///
  /// The [child] must not be null.
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
  ReceiveProjectGroupUpdates _receiveProjectGroupUpdates;
  AddProjectGroupUseCase _addProjectGroupUseCase;
  UpdateProjectGroupUseCase _updateProjectGroupUseCase;
  DeleteProjectGroupUseCase _deleteProjectGroupUseCase;
  SignInUseCase _signInUseCase;
  SignOutUseCase _signOutUseCase;

  @override
  void initState() {
    super.initState();
    final _metricsRepository = FirestoreMetricsRepository();
    final _userRepository = FirebaseUserRepository();
    final _projectGroupRepository = FirestoreProjectGroupsRepository();

    _receiveProjectUpdates = ReceiveProjectUpdates(_metricsRepository);
    _receiveProjectMetricsUpdates =
        ReceiveProjectMetricsUpdates(_metricsRepository);

    _receiveAuthUpdates = ReceiveAuthenticationUpdates(_userRepository);
    _signInUseCase = SignInUseCase(_userRepository);
    _signOutUseCase = SignOutUseCase(_userRepository);

    _receiveProjectGroupUpdates = ReceiveProjectGroupUpdates(
      _projectGroupRepository,
    );
    _addProjectGroupUseCase = AddProjectGroupUseCase(_projectGroupRepository);
    _updateProjectGroupUseCase = UpdateProjectGroupUseCase(
      _projectGroupRepository,
    );
    _deleteProjectGroupUseCase = DeleteProjectGroupUseCase(
      _projectGroupRepository,
    );
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
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(),
        ),
        ChangeNotifierProxyProvider<AuthNotifier, ProjectsNotifier>(
          create: (_) => ProjectsNotifier(_receiveProjectUpdates),
          update: (_, authNotifier, projectsNotifier) {
            return projectsNotifier
              ..updateProjectsSubscription(
                isLoggedIn: authNotifier.isLoggedIn,
              );
          },
        ),
        ChangeNotifierProxyProvider<ProjectsNotifier, ProjectMetricsNotifier>(
          create: (_) => ProjectMetricsNotifier(_receiveProjectMetricsUpdates),
          update: (_, projectsNotifier, projectMetricsNotifier) {
            return projectMetricsNotifier
              ..updateProjects(
                projectsNotifier.projects,
                projectsNotifier.errorMessage,
              );
          },
        ),
        ChangeNotifierProxyProvider<ProjectsNotifier, ProjectGroupsNotifier>(
          create: (_) => ProjectGroupsNotifier(
            _receiveProjectGroupUpdates,
            _addProjectGroupUseCase,
            _updateProjectGroupUseCase,
            _deleteProjectGroupUseCase,
          ),
          update: (_, projectsNotifier, projectGroupsNotifier) {
            return projectGroupsNotifier
              ..updateProjects(
                projectsNotifier.projects,
                projectsNotifier.errorMessage,
              );
          },
        ),
      ],
      child: widget.child,
    );
  }
}
