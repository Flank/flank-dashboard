import 'dart:async';

import 'package:metrics/project_groups/domain/entities/project_group.dart';
import 'package:metrics/project_groups/domain/usecases/add_project_group_usecase.dart';
import 'package:metrics/project_groups/domain/usecases/delete_project_group_usecase.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/add_project_group_param.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/delete_project_group_param.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/update_project_group_param.dart';
import 'package:metrics/project_groups/domain/usecases/receive_project_group_updates.dart';
import 'package:metrics/project_groups/domain/usecases/update_project_group_usecase.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("ProjectGroupsNotifier", () {
    const projectGroupId = 'testId';
    const projectGroupName = 'testName';
    const projectIds = ['testProjectId'];

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

    tearDown(() {
      reset(addProjectGroupUseCase);
      reset(updateProjectGroupUseCase);
      reset(deleteProjectGroupUseCase);
      reset(receiveProjectGroupUpdates);
    });

    tearDownAll((){
      projectGroupsNotifier.dispose();
    });

    test(
      "throws an AssertionError if the receive project group updates use case is null",
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
      "throws an AssertionError if the add project group use case is null",
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
      "throws an AssertionError if the update project group use case is null",
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
      "throws an AssertionError if the delete project group use case is null",
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
      ".subscribeToProjectGroups() completes normally if a receiveProjectGroupUpdates is null",
      () async {
        when(receiveProjectGroupUpdates()).thenAnswer(
          (_) => Stream.value(null),
        );

        await expectLater(
          projectGroupsNotifier.subscribeToProjectGroups(),
          completes,
        );

        final projectGroupViewModels =
            projectGroupsNotifier.projectGroupViewModels;

        expect(projectGroupViewModels, isNull);
      },
    );

    test(
      ".subscribeToProjectGroups() delegates to the receiveProjectGroupUpdates usecase",
      () {
        when(receiveProjectGroupUpdates.call())
            .thenAnswer((realInvocation) => const Stream.empty());

        projectGroupsNotifier.subscribeToProjectGroups();

        verify(receiveProjectGroupUpdates.call()).called(equals(1));
      },
    );

    test(
      ".subscribeToProjectGroups() subscribes to project groups updates",
      () async {
        final projectGroupsController = StreamController<List<ProjectGroup>>();

        when(receiveProjectGroupUpdates.call()).thenAnswer(
          (_) => projectGroupsController.stream,
        );

        await projectGroupsNotifier.subscribeToProjectGroups();

        expect(projectGroupsController.hasListener, isTrue);
      },
    );

    test(".deleteProjectGroup() delegates to the DeleteProjectGroupUseCase",
        () {
      projectGroupsNotifier.deleteProjectGroup(projectGroupId);

      verify(
        deleteProjectGroupUseCase(
            const DeleteProjectGroupParam(projectGroupId)),
      ).called(1);
    });

    test(
        ".saveProjectGroups() delegates to the UpdateProjectGroupUseCase if the projectGroupId is not null",
        () {
      projectGroupsNotifier.saveProjectGroups(
        projectGroupId,
        projectGroupName,
        projectIds,
      );

      verify(
        updateProjectGroupUseCase(
          const UpdateProjectGroupParam(
            projectGroupId,
            projectGroupName,
            projectIds,
          ),
        ),
      ).called(1);
    });

    test(
      ".saveProjectGroups() delegates to the AddProjectGroupUseCase if the projectGroupId is null",
      () {
        projectGroupsNotifier.saveProjectGroups(
          null,
          projectGroupName,
          projectIds,
        );

        verify(
          addProjectGroupUseCase(
            const AddProjectGroupParam(
              projectGroupName,
              projectIds,
            ),
          ),
        ).called(1);
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
