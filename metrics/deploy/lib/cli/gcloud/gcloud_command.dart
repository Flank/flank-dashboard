// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:math';

import 'package:process_run/process_run.dart' as cmd;
import 'package:process_run/shell.dart';

/// A wrapper class for the GCloud CLI.
class GCloudCommand {
  /// Literal and numerical symbols.
  final String _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';

  /// A generator of random value.
  final Random _rnd = Random();

  /// The unique identifier of the project.
  String projectID = '';

  /// Generates a random string for the new project name.
  String _getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  /// Logins to GCloud and Firebase and gets the Firebase CI token.
  Future<void> login() async {
    // Logins to GCloud.
    print('GCloud Login.');
    await cmd.run('gcloud', ['auth', 'login'], verbose: true);
  }

  /// Adds project or uses an existing one.
  Future<String> addProject() async {
    if (await promptConfirm('Create new project ?')) {
      print('Creating new project');
      projectID = 'metrics-${_getRandomString(5)}';
      await cmd.run('gcloud', ['projects', 'create', projectID], verbose: true);
    } else {
      print('List existing projects');
      await cmd.run('gcloud', ['projects', 'list'], verbose: true);
      projectID = await prompt('Project ID');
    }
    print('Setting project ID');
    await cmd.run('gcloud', ['config', 'set', 'project', projectID],
        verbose: true);
    return projectID;
  }

  /// Adds project app needed to create a Firestore database.
  Future<void> addProjectApp(String region, String projectID) async {
    if (await promptConfirm('Add project app ?')) {
      print('Adding project app.');
      await cmd.run('gcloud',
          ['app', 'create', '--region', region, '--project', projectID],
          verbose: true);
    } else {
      print('Skipping adding project app.');
    }
  }

  /// Creates a Firestore database with the given [region] and [projectID].
  Future<void> createDatabase(String region, String projectID) async {
    // gcloud alpha firestore databases create --region=europe-west --project $projectID --quiet
    if (await promptConfirm('Add project database ?')) {
      print('Adding project database.');
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
            projectID,
            '--quiet'
          ],
          verbose: true);
    } else {
      print('Skipping adding project database.');
    }
  }

  /// Cleans up resources.
  Future<void> cleanup(String srcPath) async {
    await cmd.run('rm', ['-rf', srcPath], verbose: true);
  }

  /// Prints CLI version.
  Future<void> version() async {
    await cmd.run('gcloud', ['--version'], verbose: true);
  }
}
