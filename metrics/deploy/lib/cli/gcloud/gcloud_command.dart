import 'dart:io';
import 'dart:math';

import 'package:process_run/process_run.dart' as cmd;
import 'package:process_run/shell.dart';

/// A wrapper class for the GCloud CLI.
class GCloudCommand {
  /// Logins to GCloud and Firebase and gets the Firebase CI token.
  Future<void> login() async {
    // Logins to GCloud.
    print('GCloud Login.');
    await cmd.run('gcloud', ['auth', 'login'], verbose: true);
  }

  /// Adds project or uses an existing one.
  Future<String> addProject() async {
    String projectId = '';

    if (await promptConfirm('Create new project ?')) {
      final random = Random();
      final codeUnits = List.generate(5, (index) => random.nextInt(26) + 97);
      final randomString = String.fromCharCodes(codeUnits);
      projectId = 'metrics-$randomString';

      print('Creating new project');
      await cmd.run(
        'gcloud',
        ['projects', 'create', projectId],
        verbose: true,
      );
    } else {
      print('List existing projects');
      await cmd.run(
        'gcloud',
        ['projects', 'list'],
        verbose: true,
      );
      projectId = await prompt('Project ID');
    }

    print('Setting project ID');
    await cmd.run(
      'gcloud',
      ['config', 'set', 'project', projectId],
      verbose: true,
    );

    return projectId;
  }

  /// Adds project app needed to create a Firestore database.
  Future<void> addProjectApp(String region, String projectId) async {
    if (await promptConfirm('Add project app ?')) {
      print('Adding project app.');
      await cmd.run(
        'gcloud',
        ['app', 'create', '--region', region, '--project', projectId],
        verbose: true,
      );
    } else {
      print('Skipping adding project app.');
    }
  }

  /// Creates a Firestore database with the given [region] and [projectId].
  Future<void> createDatabase(String region, String projectId) async {
    if (await promptConfirm('Add project database ?')) {
      print('Adding project database.');
      await cmd.run(
        'gcloud',
        ['services', 'enable', 'firestore.googleapis.com'],
        verbose: true,
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
          '--quiet',
        ],
        verbose: true,
        stdin: stdin,
      );
    } else {
      print('Skipping adding project database.');
    }
  }

  /// Prints CLI version.
  Future<void> version() async {
    await cmd.run('gcloud', ['--version'], stdin: stdin, verbose: true);
  }
}
