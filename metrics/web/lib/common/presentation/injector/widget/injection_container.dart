import 'package:flutter/material.dart';
import 'package:metrics/auth/data/repositories/firebase_user_repository.dart';
import 'package:metrics/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:metrics/auth/domain/usecases/receive_authentication_updates.dart';
import 'package:metrics/auth/domain/usecases/sign_in_usecase.dart';
import 'package:metrics/auth/domain/usecases/sign_out_usecase.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/data/repositories/firestore_project_repository.dart';
import 'package:metrics/common/domain/usecases/receive_project_updates.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/state/projects_notifier.dart';
import 'package:metrics/dashboard/data/repositories/firestore_metrics_repository.dart';
import 'package:metrics/dashboard/domain/usecases/receive_project_metrics_updates.dart';
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
  /// A use case needed to be able to sign in a user.
  SignInUseCase _signInUseCase;

  /// A use case needed to be able to sign in a user with Google.
  GoogleSignInUseCase _googleSignInUseCase;

  /// A use case needed to be able to sign out a user.
  SignOutUseCase _signOutUseCase;

  /// A use case needed to be able to receive the project updates.
  ReceiveProjectUpdates _receiveProjectUpdates;

  /// A use case needed to be able to receive the project metrics updates.
  ReceiveProjectMetricsUpdates _receiveProjectMetricsUpdates;

  /// A use case needed to receive the authentication updates.
  ReceiveAuthenticationUpdates _receiveAuthUpdates;

  /// A use case needed to receive the project group updates.
  ReceiveProjectGroupUpdates _receiveProjectGroupUpdates;

  /// A use case needed to be able to add a new project group.
  AddProjectGroupUseCase _addProjectGroupUseCase;

  /// A use case needed to be able to update the existing project group.
  UpdateProjectGroupUseCase _updateProjectGroupUseCase;

  /// A use case needed to be able to delete a project group.
  DeleteProjectGroupUseCase _deleteProjectGroupUseCase;

  @override
  void initState() {
    super.initState();
    final _metricsRepository = FirestoreMetricsRepository();
    final _userRepository = FirebaseUserRepository();
    final _projectGroupRepository = FirestoreProjectGroupsRepository();
    final _projectRepository = FirestoreProjectRepository();

    _receiveProjectUpdates = ReceiveProjectUpdates(_projectRepository);
    _receiveProjectMetricsUpdates =
        ReceiveProjectMetricsUpdates(_metricsRepository);

    _receiveAuthUpdates = ReceiveAuthenticationUpdates(_userRepository);
    _signInUseCase = SignInUseCase(_userRepository);
    _googleSignInUseCase = GoogleSignInUseCase(_userRepository);
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
            _googleSignInUseCase,
            _signOutUseCase,
          ),
        ),
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(),
        ),
        ChangeNotifierProxyProvider<AuthNotifier, ProjectsNotifier>(
          lazy: false,
          create: (_) => ProjectsNotifier(_receiveProjectUpdates),
          update: (_, authNotifier, projectsNotifier) {
            _updateProjectsSubscription(authNotifier, projectsNotifier);

            return projectsNotifier;
          },
        ),
        ChangeNotifierProxyProvider2<AuthNotifier, ProjectsNotifier,
            ProjectGroupsNotifier>(
          create: (_) => ProjectGroupsNotifier(
            _receiveProjectGroupUpdates,
            _addProjectGroupUseCase,
            _updateProjectGroupUseCase,
            _deleteProjectGroupUseCase,
          ),
          update: (_, authNotifier, projectsNotifier, projectGroupsNotifier) {
            final isLoggedIn = authNotifier.isLoggedIn;

            if (isLoggedIn != null && isLoggedIn) {
              projectGroupsNotifier.subscribeToProjectGroups();
            } else {
              projectGroupsNotifier.unsubscribeFromProjectGroups();
            }

            projectGroupsNotifier.setProjects(
              projectsNotifier.projectModels,
              projectsNotifier.projectsErrorMessage,
            );

            return projectGroupsNotifier;
          },
        ),
        ChangeNotifierProxyProvider2<ProjectsNotifier, ProjectGroupsNotifier,
            ProjectMetricsNotifier>(
          create: (_) => ProjectMetricsNotifier(_receiveProjectMetricsUpdates),
          update: (_, projectsNotifier, projectGroupsNotifier,
              projectMetricsNotifier) {
            projectMetricsNotifier.setProjects(
              projectsNotifier.projectModels,
              projectsNotifier.projectsErrorMessage,
            );

            projectMetricsNotifier.setProjectGroups(
              projectGroupsNotifier.projectGroupModels,
            );

            return projectMetricsNotifier;
          },
        ),
      ],
      child: widget.child,
    );
  }

  /// Updates projects subscription based on user logged in status.
  void _updateProjectsSubscription(
    AuthNotifier authNotifier,
    ProjectsNotifier projectsNotifier,
  ) {
    final isLoggedIn = authNotifier.isLoggedIn;

    if (isLoggedIn == null) return;

    if (isLoggedIn) {
      projectsNotifier.subscribeToProjects();
    } else {
      projectsNotifier.unsubscribeFromProjects();
    }
  }
}
