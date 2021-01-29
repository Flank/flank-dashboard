import 'dart:math';

import 'package:cli/strings/prompt_strings.dart';
import 'package:cli/util/prompt_util.dart';
import 'package:process_run/process_run.dart' as cmd;
import 'package:process_run/shell_run.dart';

/// A wrapper class for the GCloud CLI.
class GCloudCommand {
  /// Creates a new instance of the [GCloudCommand].
  const GCloudCommand();

  /// Logins to GCloud and Firebase and gets the Firebase CI token.
  Future<void> login() async {
    // Logins to GCloud.
    print('GCloud Login.');
    await cmd.run(
      'gcloud',
      ['auth', 'login'],
      verbose: true,
      stdin: sharedStdIn,
    );
  }

  /// Adds project or uses an existing one.
  Future<String> addProject() async {
    String projectId = '';
    final createNewProject =
        await PromptUtil.promptConfirm(PromptStrings.createNewProject);

    if (createNewProject) {
      final random = Random();
      final codeUnits = List.generate(5, (index) => random.nextInt(26) + 97);
      final randomString = String.fromCharCodes(codeUnits);
      projectId = 'metrics-$randomString';

      print('Creating new project');
      await cmd.run(
        'gcloud',
        ['projects', 'create', projectId],
        verbose: true,
        stdin: sharedStdIn,
      );
    } else {
      print('List existing projects');
      await cmd.run(
        'gcloud',
        ['projects', 'list'],
        verbose: true,
        stdin: sharedStdIn,
      );
      projectId = await PromptUtil.prompt(PromptStrings.selectProjectId);
    }

    print('Setting project ID');
    await cmd.run(
      'gcloud',
      ['config', 'set', 'project', projectId],
      verbose: true,
      stdin: sharedStdIn,
    );

    return projectId;
  }

  /// Adds project app needed to create a Firestore database.
  Future<void> addProjectApp(String region, String projectId) async {
    final addProjectApp =
        await PromptUtil.promptConfirm(PromptStrings.addProjectApp);

    if (addProjectApp) {
      print('Adding project app.');
      await cmd.run(
        'gcloud',
        ['app', 'create', '--region', region, '--project', projectId],
        verbose: true,
        stdin: sharedStdIn,
      );
    } else {
      print('Skipping adding project app.');
    }
  }

  /// Creates a Firestore database with the given [region] and [projectId].
  Future<void> createDatabase(String region, String projectId) async {
    final addDatabase =
        await PromptUtil.promptConfirm(PromptStrings.createProjectDatabase);

    if (addDatabase) {
      print('Adding project database.');
      await cmd.run(
        'gcloud',
        ['services', 'enable', 'firestore.googleapis.com'],
        verbose: true,
        stdin: sharedStdIn,
      );
      await cmd.run(
        'gcloud',
        [
          'alpha',
          'firestore',
          'databases',
          'create',
          '--region',
          region,
          '--project',
          projectId,
        ],
        verbose: true,
        stdin: sharedStdIn,
      );
    } else {
      print('Skipping adding project database.');
    }
  }

  /// Prints CLI version.
  Future<void> version() async {
    await cmd.run(
      'gcloud',
      ['--version'],
      verbose: true,
      stdin: sharedStdIn,
    );
  }
}
