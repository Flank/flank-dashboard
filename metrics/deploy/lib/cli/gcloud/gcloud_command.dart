import 'dart:math';

import 'package:process_run/process_run.dart' as cmd;
import 'package:process_run/shell.dart';

/// class wrapping up gcloud CLI
class GCloudCommand {
  final _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
  final Random _rnd = Random();
  String projectID = '';

  /// Generates random string for new project name
  String _getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  /// Login to GCloud and Firebase and get firebase CI token
  Future<void> login() async {
    // GCloud login
    print('GCloud Login.');
    await cmd.run('gcloud', ['auth', 'login'], verbose: true);
  }

  /// Add project or use existing project
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

  // Add project app needed to create firestore database.
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

  /// Create firestore database.
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

  /// Cleanup resources.
  Future<void> cleanup(String srcPath) async {
    await cmd.run('rm', ['-rf', srcPath], verbose: true);
  }
}
