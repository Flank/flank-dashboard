import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';
import 'package:metrics/common/domain/entities/persistent_store_exception.dart';
import 'package:metrics/common/presentation/models/persistent_store_error_message.dart';
import 'package:metrics/common/presentation/models/project_model.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/project_groups/domain/entities/project_group.dart';
import 'package:metrics/project_groups/domain/usecases/add_project_group_usecase.dart';
import 'package:metrics/project_groups/domain/usecases/delete_project_group_usecase.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/add_project_group_param.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/delete_project_group_param.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/update_project_group_param.dart';
import 'package:metrics/project_groups/domain/usecases/receive_project_group_updates.dart';
import 'package:metrics/project_groups/domain/usecases/update_project_group_usecase.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/view_models/project_checkbox_view_model.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_card_view_model.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_dialog_view_model.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("ProjectGroupsNotifier", () {
    const projectGroupId = 'projectGroupId';
    const projectGroupName = 'projectGroupName';

    final projectGroup = ProjectGroup(
      id: projectGroupId,
      name: projectGroupName,
      projectIds: List.from([]),
    );

    const project = ProjectModel(id: 'projectId', name: 'projectName');

    const projects = [
      project,
      ProjectModel(id: '1', name: 'name1'),
      ProjectModel(id: '2', name: 'name2'),
    ];

    final projectGroups = [
      projectGroup,
      ProjectGroup(id: '1', name: 'name1', projectIds: List.from([])),
      ProjectGroup(id: '2', name: 'name2', projectIds: List.from([])),
    ];

    final addProjectGroupUseCase = AddProjectGroupUseCaseMock();
    final updateProjectGroupUseCase = UpdateProjectGroupUseCaseMock();
    final deleteProjectGroupUseCase = DeleteProjectGroupUseCaseMock();
    final receiveProjectGroupUpdates = ReceiveProjectGroupUpdatesMock();

    final projectGroupsNotifier = ProjectGroupsNotifier(
      receiveProjectGroupUpdates,
      addProjectGroupUseCase,
      updateProjectGroupUseCase,
      deleteProjectGroupUseCase,
    );

    setUpAll(() async {
      when(receiveProjectGroupUpdates()).thenAnswer(
        (_) => Stream.value(projectGroups),
      );

      await projectGroupsNotifier.subscribeToProjectGroups();
      projectGroupsNotifier.setProjects(projects);
    });

    setUp(() {
      reset(receiveProjectGroupUpdates);
      reset(addProjectGroupUseCase);
      reset(updateProjectGroupUseCase);
      reset(deleteProjectGroupUseCase);
    });

    tearDownAll(() {
      projectGroupsNotifier.dispose();
    });

    test(
      "throws an AssertionError if the given receive project group updates use case is null",
      () {
        expect(
          () => ProjectGroupsNotifier(
            null,
            addProjectGroupUseCase,
            updateProjectGroupUseCase,
            deleteProjectGroupUseCase,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the given add project group use case is null",
      () {
        expect(
          () => ProjectGroupsNotifier(
            receiveProjectGroupUpdates,
            null,
            updateProjectGroupUseCase,
            deleteProjectGroupUseCase,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the given update project group use case is null",
      () {
        expect(
          () => ProjectGroupsNotifier(
            receiveProjectGroupUpdates,
            addProjectGroupUseCase,
            null,
            deleteProjectGroupUseCase,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the given delete project group use case is null",
      () {
        expect(
          () => ProjectGroupsNotifier(
            receiveProjectGroupUpdates,
            addProjectGroupUseCase,
            updateProjectGroupUseCase,
            null,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      ".filterByProjectName() filters a list of project checkbox view models",
      () {
        const filter = '2';

        final notifier = ProjectGroupsNotifier(
          receiveProjectGroupUpdates,
          addProjectGroupUseCase,
          updateProjectGroupUseCase,
          deleteProjectGroupUseCase,
        );

        notifier.setProjects(projects);

        final expectedModels = notifier.projectCheckboxViewModels
            .where((element) => element.name.contains(filter))
            .toList();

        notifier.filterByProjectName(filter);

        final listener = expectAsyncUntil0(
          () {},
          () => listEquals(notifier.projectCheckboxViewModels, expectedModels),
        );

        notifier.addListener(listener);
        addTearDown(notifier.dispose);
      },
    );

    test(
      ".initDeleteProjectGroupDialogViewModel() sets the delete project group view model with the given project group id",
      () async {
        projectGroupsNotifier.initDeleteProjectGroupDialogViewModel(
          projectGroup.id,
        );

        expect(
          projectGroupsNotifier.deleteProjectGroupDialogViewModel.id,
          equals(projectGroup.id),
        );
      },
    );

    test(
      ".initDeleteProjectGroupDialogViewModel() does not create a view model if the given project group id is null",
      () {
        final initialDeleteDialogViewModel =
            projectGroupsNotifier.deleteProjectGroupDialogViewModel;

        projectGroupsNotifier.initDeleteProjectGroupDialogViewModel(null);

        expect(
          projectGroupsNotifier.deleteProjectGroupDialogViewModel,
          equals(initialDeleteDialogViewModel),
        );
      },
    );

    test(
      ".initDeleteProjectGroupDialogViewModel() does not create a view model if the project groups do not contain a group with the given id",
      () {
        final initialDeleteDialogViewModel =
            projectGroupsNotifier.deleteProjectGroupDialogViewModel;

        projectGroupsNotifier
            .initDeleteProjectGroupDialogViewModel('invalid_id');

        expect(
          projectGroupsNotifier.deleteProjectGroupDialogViewModel,
          equals(initialDeleteDialogViewModel),
        );
      },
    );

    test(
      ".resetDeleteProjectGroupDialogViewModel() sets the delete project group view model to null",
      () {
        projectGroupsNotifier.initDeleteProjectGroupDialogViewModel(
          projectGroup.id,
        );

        expect(
          projectGroupsNotifier.deleteProjectGroupDialogViewModel,
          isNotNull,
        );

        projectGroupsNotifier.resetDeleteProjectGroupDialogViewModel();

        expect(
          projectGroupsNotifier.deleteProjectGroupDialogViewModel,
          isNull,
        );
      },
    );

    test(
      ".initProjectGroupDialogViewModel() sets the projectGroupDialogViewModel using the given project group id",
      () {
        projectGroupsNotifier.initProjectGroupDialogViewModel(projectGroup.id);

        expect(
          projectGroupsNotifier.projectGroupDialogViewModel.id,
          equals(projectGroup.id),
        );
      },
    );

    test(
      ".initProjectGroupDialogViewModel() sets an empty projectGroupDialogViewModel if there is no project group with the given id",
      () {
        const expectedViewModel = ProjectGroupDialogViewModel();

        projectGroupsNotifier.initProjectGroupDialogViewModel(null);

        expect(
          projectGroupsNotifier.projectGroupDialogViewModel,
          equals(expectedViewModel),
        );
      },
    );

    test(
      ".initProjectGroupDialogViewModel() sets an empty projectGroupDialogViewModel if there is no project group with the given id",
      () {
        const expectedViewModel = ProjectGroupDialogViewModel();

        projectGroupsNotifier.initProjectGroupDialogViewModel('invalid_id');

        expect(
          projectGroupsNotifier.projectGroupDialogViewModel,
          equals(expectedViewModel),
        );
      },
    );

    test(
      ".projectGroupDialogViewModel can't contain a project id if there is no project with such id",
      () async {
        const invalidGroupId = '1';
        final invalidProjectGroup = ProjectGroup(
          id: invalidGroupId,
          name: 'name1',
          projectIds: List.from(['id1', 'id2']),
        );

        final projectGroups = [
          invalidProjectGroup,
          ProjectGroup(
            id: '2',
            name: 'name2',
            projectIds: List.from(['id1']),
          ),
        ];

        const projects = [
          ProjectModel(id: 'id1', name: 'name1'),
        ];

        final availableProjectIds = projects.map((project) => project.id);

        when(receiveProjectGroupUpdates())
            .thenAnswer((_) => Stream.value(projectGroups));

        final projectGroupsNotifier = ProjectGroupsNotifier(
          receiveProjectGroupUpdates,
          addProjectGroupUseCase,
          updateProjectGroupUseCase,
          deleteProjectGroupUseCase,
        );

        projectGroupsNotifier.setProjects(projects);
        await projectGroupsNotifier.subscribeToProjectGroups();

        final listener = expectAsyncUntil0(() {
          final projectGroupCardViewModels =
              projectGroupsNotifier.projectGroupCardViewModels;

          if (projectGroupCardViewModels == null ||
              projectGroupCardViewModels.isEmpty) {
            return;
          }

          if (projectGroupsNotifier.projectGroupDialogViewModel == null) {
            projectGroupsNotifier
                .initProjectGroupDialogViewModel(invalidGroupId);
          }
        }, () {
          final projectGroupDialogViewModel =
              projectGroupsNotifier.projectGroupDialogViewModel;

          if (projectGroupDialogViewModel == null) return false;

          return projectGroupDialogViewModel.selectedProjectIds
              .every((id) => availableProjectIds.contains(id));
        });

        projectGroupsNotifier.addListener(listener);
        addTearDown(projectGroupsNotifier.dispose);
      },
    );

    test(
      ".resetProjectGroupDialogViewModel() sets the project group dialog view model to null",
      () {
        projectGroupsNotifier.initProjectGroupDialogViewModel(projectGroup.id);

        expect(
          projectGroupsNotifier.projectGroupDialogViewModel,
          isNotNull,
        );

        projectGroupsNotifier.resetProjectGroupDialogViewModel();

        expect(
          projectGroupsNotifier.projectGroupDialogViewModel,
          isNull,
        );
      },
    );

    test(
      ".toggleProjectCheckedStatus() changes a checked status of the project checkbox view model",
      () {
        projectGroupsNotifier.initProjectGroupDialogViewModel(projectGroup.id);

        projectGroupsNotifier.toggleProjectCheckedStatus(
          project.id,
        );

        final projectCheckboxViewModel = projectGroupsNotifier
            .projectCheckboxViewModels
            .firstWhere((viewModel) => viewModel.id == project.id);

        expect(projectCheckboxViewModel.isChecked, isTrue);
      },
    );

    test(
      ".toggleProjectCheckedStatus() changes the project group dialog view model",
      () {
        projectGroupsNotifier.initProjectGroupDialogViewModel(projectGroup.id);

        final initialViewModel =
            projectGroupsNotifier.projectGroupDialogViewModel;

        projectGroupsNotifier.toggleProjectCheckedStatus(
          project.id,
        );

        expect(
          projectGroupsNotifier.projectGroupDialogViewModel,
          isNot(equals(initialViewModel)),
        );
      },
    );

    test(
      ".toggleProjectCheckedStatus() does not change the project checkbox view models if the given id is null",
      () {
        final expectedProjectCheckboxViewModels =
            projectGroupsNotifier.projectCheckboxViewModels;

        projectGroupsNotifier.toggleProjectCheckedStatus(null);

        final actualProjectCheckboxViewModels =
            projectGroupsNotifier.projectCheckboxViewModels;

        expect(
          actualProjectCheckboxViewModels,
          equals(expectedProjectCheckboxViewModels),
        );
      },
    );

    test(
      ".toggleProjectCheckedStatus() does not change the selected project ids if the given id is null",
      () {
        projectGroupsNotifier.initProjectGroupDialogViewModel(projectGroup.id);

        final expectedSelectedProjects = projectGroupsNotifier
            .projectGroupDialogViewModel.selectedProjectIds;

        projectGroupsNotifier.toggleProjectCheckedStatus(null);

        final actualSelectedProjects = projectGroupsNotifier
            .projectGroupDialogViewModel.selectedProjectIds;

        expect(
          actualSelectedProjects,
          equals(expectedSelectedProjects),
        );
      },
    );

    test(
      ".toggleProjectCheckedStatus() adds the project id to the project group dialog view model if it is not selected",
      () {
        projectGroupsNotifier.initProjectGroupDialogViewModel(projectGroup.id);

        projectGroupsNotifier.toggleProjectCheckedStatus(
          project.id,
        );

        expect(
          projectGroupsNotifier.projectGroupDialogViewModel.selectedProjectIds,
          contains(project.id),
        );
      },
    );

    test(
      ".toggleProjectCheckedStatus() removes the given project id from the project group dialog view model if it is selected",
      () {
        projectGroupsNotifier.initProjectGroupDialogViewModel(projectGroup.id);

        projectGroupsNotifier.toggleProjectCheckedStatus(
          project.id,
        );

        expect(
          projectGroupsNotifier.projectGroupDialogViewModel.selectedProjectIds,
          contains(project.id),
        );

        projectGroupsNotifier.toggleProjectCheckedStatus(
          project.id,
        );

        expect(
          projectGroupsNotifier.projectGroupDialogViewModel.selectedProjectIds,
          isNot(contains(project.id)),
        );
      },
    );

    test(
      ".subscribeToProjectGroups() completes normally if the receive project group updates stream emits null",
      () async {
        when(receiveProjectGroupUpdates()).thenAnswer(
          (_) => Stream.value(null),
        );

        await expectLater(
          projectGroupsNotifier.subscribeToProjectGroups(),
          completes,
        );
      },
    );

    test(
      ".subscribeToProjectGroups() delegates to the receive project group updates use case",
      () {
        when(receiveProjectGroupUpdates.call()).thenAnswer(
          (_) => const Stream.empty(),
        );

        projectGroupsNotifier.subscribeToProjectGroups();

        verify(receiveProjectGroupUpdates()).called(equals(1));
      },
    );

    test(
      ".subscribeToProjectGroups() subscribes to the project groups updates stream",
      () async {
        final projectGroupsController = StreamController<List<ProjectGroup>>();

        when(receiveProjectGroupUpdates.call()).thenAnswer(
          (_) => projectGroupsController.stream,
        );

        await projectGroupsNotifier.subscribeToProjectGroups();

        expect(projectGroupsController.hasListener, isTrue);
      },
    );

    test(
      ".subscribeToProjectGroups() creates a list of project group card view models",
      () async {
        final projectGroupsNotifier = ProjectGroupsNotifier(
          receiveProjectGroupUpdates,
          addProjectGroupUseCase,
          updateProjectGroupUseCase,
          deleteProjectGroupUseCase,
        );

        when(receiveProjectGroupUpdates()).thenAnswer(
          (_) => Stream.value(projectGroups),
        );

        projectGroupsNotifier.setProjects([]);

        final expectedProjectGroupCardViewModels = projectGroups
            .map((projectGroup) => ProjectGroupCardViewModel(
                  name: projectGroup.name,
                  id: projectGroup.id,
                  projectsCount: projectGroup.projectIds.length,
                ))
            .toList();

        final listener = expectAsyncUntil0(
            () {},
            () => listEquals(projectGroupsNotifier.projectGroupCardViewModels,
                expectedProjectGroupCardViewModels));

        projectGroupsNotifier.addListener(listener);
        await projectGroupsNotifier.subscribeToProjectGroups();

        addTearDown(projectGroupsNotifier.dispose);
      },
    );

    test(
      ".unsubscribeFromProjectGroups() unsubscribes from project groups updates",
      () async {
        final projectGroupsController = StreamController<List<ProjectGroup>>();

        when(receiveProjectGroupUpdates()).thenAnswer(
          (_) => projectGroupsController.stream,
        );

        await projectGroupsNotifier.subscribeToProjectGroups();
        expect(projectGroupsController.hasListener, isTrue);

        await projectGroupsNotifier.unsubscribeFromProjectGroups();
        expect(projectGroupsController.hasListener, isFalse);
      },
    );

    test(
      ".projectGroupsErrorMessage provides an error description if a project groups stream emits a persistent store exception",
      () async {
        const errorCode = PersistentStoreErrorCode.unknown;
        final projectGroupsController = StreamController<List<ProjectGroup>>();
        const errorMessage = PersistentStoreErrorMessage(errorCode);

        final projectGroupsNotifier = ProjectGroupsNotifier(
          receiveProjectGroupUpdates,
          addProjectGroupUseCase,
          updateProjectGroupUseCase,
          deleteProjectGroupUseCase,
        );

        when(receiveProjectGroupUpdates()).thenAnswer(
          (_) => projectGroupsController.stream,
        );

        projectGroupsController.addError(const PersistentStoreException(
          code: errorCode,
        ));

        final listener = expectAsyncUntil0(
          () {},
          () =>
              projectGroupsNotifier.projectGroupsErrorMessage ==
              errorMessage.message,
        );

        projectGroupsNotifier.addListener(listener);
        await projectGroupsNotifier.subscribeToProjectGroups();

        addTearDown(projectGroupsNotifier.dispose);
      },
    );

    test(
      ".addProjectGroup() delegates to the add project group use case",
      () {
        projectGroupsNotifier.addProjectGroup(
          projectGroupName,
          [],
        );

        verify(
          addProjectGroupUseCase(AddProjectGroupParam(
            projectGroupName: projectGroupName,
            projectIds: const [],
          )),
        ).called(1);
      },
    );

    test(
      ".addProjectGroup() does not call the use case if the given name is null",
      () async {
        await projectGroupsNotifier.addProjectGroup(null, []);
        verifyNever(addProjectGroupUseCase(any));
      },
    );

    test(
      ".addProjectGroup() does not call the use case if the given project ids list is null",
      () async {
        await projectGroupsNotifier.addProjectGroup(
          projectGroupName,
          null,
        );

        verifyNever(addProjectGroupUseCase(any));
      },
    );

    test(
      ".addProjectGroup() sets the project group error message if the use case throws a persistent store exception",
      () async {
        const errorCode = PersistentStoreErrorCode.unknown;
        const errorMessage = PersistentStoreErrorMessage(errorCode);

        when(addProjectGroupUseCase(any)).thenThrow(
          const PersistentStoreException(code: errorCode),
        );

        await projectGroupsNotifier.addProjectGroup(
          projectGroupName,
          [],
        );

        expect(
          projectGroupsNotifier.projectGroupSavingError,
          errorMessage.message,
        );
      },
    );

    test(
      ".addProjectGroup() resets the project group error message",
      () async {
        const errorCode = PersistentStoreErrorCode.unknown;

        when(addProjectGroupUseCase(any)).thenThrow(
          const PersistentStoreException(code: errorCode),
        );

        await projectGroupsNotifier.addProjectGroup(
          projectGroupName,
          [],
        );

        expect(projectGroupsNotifier.projectGroupSavingError, isNotNull);
        reset(addProjectGroupUseCase);

        await projectGroupsNotifier.addProjectGroup(
          projectGroupName,
          [],
        );

        expect(projectGroupsNotifier.projectGroupSavingError, isNull);
      },
    );

    test(
      ".updateProjectGroup() delegates to the update project group use case",
      () {
        projectGroupsNotifier.updateProjectGroup(
          projectGroupId,
          projectGroupName,
          [],
        );

        verify(
          updateProjectGroupUseCase(
            UpdateProjectGroupParam(projectGroupId, projectGroupName, const []),
          ),
        ).called(1);
      },
    );

    test(
      ".updateProjectGroup() does not call the use case if the given id is null",
      () async {
        await projectGroupsNotifier.updateProjectGroup(
          null,
          projectGroupName,
          [],
        );

        verifyNever(updateProjectGroupUseCase(any));
      },
    );

    test(
      ".updateProjectGroup() does not call the use case if the given name is null",
      () async {
        await projectGroupsNotifier.updateProjectGroup(
          projectGroupId,
          null,
          [],
        );

        verifyNever(updateProjectGroupUseCase(any));
      },
    );

    test(
      ".updateProjectGroup() does not call the use case if the given project ids list is null",
      () async {
        await projectGroupsNotifier.updateProjectGroup(
          projectGroupId,
          projectGroupName,
          null,
        );

        verifyNever(updateProjectGroupUseCase(any));
      },
    );

    test(
      ".updateProjectGroup() sets the project group error message if throws a persistent store exception",
      () async {
        const errorCode = PersistentStoreErrorCode.unknown;
        const errorMessage = PersistentStoreErrorMessage(errorCode);

        when(updateProjectGroupUseCase(any)).thenThrow(
          const PersistentStoreException(code: errorCode),
        );

        await projectGroupsNotifier.updateProjectGroup(
          projectGroupId,
          projectGroupName,
          [],
        );

        expect(
          projectGroupsNotifier.projectGroupSavingError,
          errorMessage.message,
        );
      },
    );

    test(
      ".updateProjectGroup() resets the project group error message",
      () async {
        const errorCode = PersistentStoreErrorCode.unknown;

        when(updateProjectGroupUseCase(any)).thenThrow(
          const PersistentStoreException(code: errorCode),
        );

        await projectGroupsNotifier.updateProjectGroup(
          projectGroupId,
          projectGroupName,
          [],
        );

        expect(
          projectGroupsNotifier.projectGroupSavingError,
          isNotNull,
        );

        reset(updateProjectGroupUseCase);

        await projectGroupsNotifier.updateProjectGroup(
          projectGroupId,
          projectGroupName,
          [],
        );

        expect(
          projectGroupsNotifier.projectGroupSavingError,
          isNull,
        );
      },
    );

    test(
      ".deleteProjectGroup() delegates to the delete project group use case",
      () {
        projectGroupsNotifier.deleteProjectGroup(projectGroupId);

        verify(
          deleteProjectGroupUseCase(
            DeleteProjectGroupParam(projectGroupId: projectGroupId),
          ),
        ).called(1);
      },
    );

    test(
      ".deleteProjectGroup() does not call the use case if the given id is null",
      () async {
        await projectGroupsNotifier.deleteProjectGroup(null);

        verifyNever(deleteProjectGroupUseCase(any));
      },
    );

    test(
      ".deleteProjectGroup() sets the project group error message if the use case throws a persistent store exception",
      () async {
        const errorCode = PersistentStoreErrorCode.unknown;
        const errorMessage = PersistentStoreErrorMessage(errorCode);

        when(deleteProjectGroupUseCase(any)).thenThrow(
          const PersistentStoreException(code: errorCode),
        );

        await projectGroupsNotifier.deleteProjectGroup(projectGroupId);

        expect(
          projectGroupsNotifier.projectGroupSavingError,
          errorMessage.message,
        );
      },
    );

    test(
      ".deleteProjectGroup() resets the project group error message",
      () async {
        const errorCode = PersistentStoreErrorCode.unknown;

        when(deleteProjectGroupUseCase(any)).thenThrow(
          const PersistentStoreException(code: errorCode),
        );

        await projectGroupsNotifier.deleteProjectGroup(projectGroupId);

        expect(
          projectGroupsNotifier.projectGroupSavingError,
          isNotNull,
        );

        reset(deleteProjectGroupUseCase);

        await projectGroupsNotifier.deleteProjectGroup(projectGroupId);

        expect(
          projectGroupsNotifier.projectGroupSavingError,
          isNull,
        );
      },
    );

    test(
      ".setProjects() creates a list of project checkbox view models from the given projects",
      () {
        projectGroupsNotifier.setProjects(projects);

        final expectedProjectCheckboxViewModels = projects.map(
          (e) => ProjectCheckboxViewModel(
            id: e.id,
            name: e.name,
            isChecked: false,
          ),
        );

        expect(
          projectGroupsNotifier.projectCheckboxViewModels,
          expectedProjectCheckboxViewModels,
        );
      },
    );

    test(
      ".setProjects() sets a list of project checkbox view models to null if the given projects are null",
      () {
        projectGroupsNotifier.setProjects(null);

        expect(
          projectGroupsNotifier.projectCheckboxViewModels,
          isNull,
        );
      },
    );

    test(
      ".setProjects() saves the projects error message if it is not null",
      () {
        final expectedMessage = CommonStrings.unknownErrorMessage;

        projectGroupsNotifier.setProjects(projects, expectedMessage);

        expect(
          projectGroupsNotifier.projectsErrorMessage,
          equals(expectedMessage),
        );
      },
    );

    test(
      ".dispose() cancels all created subscriptions",
      () async {
        final projectGroupsNotifier = ProjectGroupsNotifier(
          receiveProjectGroupUpdates,
          addProjectGroupUseCase,
          updateProjectGroupUseCase,
          deleteProjectGroupUseCase,
        );

        final projectGroupsController = StreamController<List<ProjectGroup>>();

        when(receiveProjectGroupUpdates()).thenAnswer(
          (_) => projectGroupsController.stream,
        );

        await projectGroupsNotifier.subscribeToProjectGroups();

        expect(projectGroupsController.hasListener, isTrue);

        projectGroupsNotifier.dispose();

        expect(projectGroupsController.hasListener, isFalse);
      },
    );
  });
}

class AddProjectGroupUseCaseMock extends Mock
    implements AddProjectGroupUseCase {}

class UpdateProjectGroupUseCaseMock extends Mock
    implements UpdateProjectGroupUseCase {}

class DeleteProjectGroupUseCaseMock extends Mock
    implements DeleteProjectGroupUseCase {}

class ReceiveProjectGroupUpdatesMock extends Mock
    implements ReceiveProjectGroupUpdates {}
