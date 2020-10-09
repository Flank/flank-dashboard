import 'dart:math';

import 'package:args/command_runner.dart';
import 'package:process_run/process_run.dart' as cmd;
import 'package:process_run/shell.dart';
import 'package:deploy/cli/firebase/firebase_command.dart';
import 'package:deploy/cli/gcloud/gcloud_command.dart';
import 'package:deploy/cli/git/git_command.dart';

/// class extending [Command] to facilitate  building GCloud project,build and deploy metrics app.
class DeployCommand extends Command {
  @override
  final name = "deploy";
  @override
  final description =
      "Creates GCloud and Firebase project and deploy metrics app.";

  final _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
  final Random _rnd = Random();
  final firebase = FirebaseCommand();
  final gcloud = GCloudCommand();
  final git = GitCommand();

  DeployCommand();

  @override
  Future<void> run() async {
    final firebaseToken = await _login();

    final projectID = await _addProject();

    await _addFirebase(projectID, firebaseToken);

    final region = await _selectRegion();

    await _addProjectApp(region, projectID);

    await _createDatabase(region, projectID);

    final appID = await _createWebApp(projectID, firebaseToken);
    const repoURL = 'git@github.com:platform-platform/monorepo.git';
    const srcPath = 'src';
    //final firebaseSrc = srcPath + '/metrics/firebase';
    await _buildAndDeploy(appID, projectID, firebaseToken, repoURL, srcPath);
    // Cleanup
    await cleanup(srcPath);
    // Terminate prompt entry.
    await promptTerminate();
  }

  /// Generates random string for new project name
  String _getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  /// Login to GCloud and Firebase and get firebase CI token
  Future<String> _login() async {
    // GCloud login
    print('GCloud Login.');
    await cmd.run('gcloud', ['auth', 'login'], verbose: true);
    // Firebase login
    print('Firebase login.');
    await cmd.run('firebase', ['login:ci', '--interactive'], verbose: true);
    // Configure firebase project
    return prompt('Copy Firebase Token from above');
  }

  /// Add project or use existing project
  Future<String> _addProject() async {
    var projectID = '';
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

  /// Add Firebase capabilities to project.
  Future<void> _addFirebase(String projectID, String firebaseToken) async {
    if (await promptConfirm('Add firebase capabilities to project ?')) {
      print('Adding Firebase capabilities.');
      await cmd.run('firebase',
          ['projects:addfirebase', projectID, '--token', firebaseToken],
          verbose: true);
    } else {
      print('Skipping adding Firebase capabilities.');
    }
  }

  ///  Select GCP region
  Future<String> _selectRegion() async {
    // TODO: Listing regions won't work on new projects as compute API not enabled yet.
    //await run('gcloud',['compute','regions','list'],verbose:true);
    print('Select default region.');
    return prompt('region');
  }

  // Add project app needed to create firestore database.
  Future<void> _addProjectApp(String region, String projectID) async {
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
  Future<void> _createDatabase(String region, String projectID) async {
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

  /// Create Firebase web app.
  Future<String> _createWebApp(String projectID, String firebaseToken) async {
    //firebase apps:create --project $projectID
    if (await promptConfirm('Add web app?')) {
      print('Adding Firebase web app.');
      await cmd.run(
          'firebase',
          [
            'apps:create',
            '--project',
            projectID,
            '--token',
            firebaseToken,
            "WEB",
            projectID
          ],
          verbose: true);
    } else {
      print('List existings apps.');
      await cmd.run('firebase',
          ['apps:list', '--project', projectID, '--token', firebaseToken],
          verbose: true);
    }
    print('Select appID.');
    return prompt('appID');
  }

  /// Downloads and writes web app SDK config to firebase-config.js file.
  Future<void> _downloadSDKConfig(String appID, String configPath,
      String projectID, String firebaseToken) async {
    // Get config
    print('Write web app SDK config to firebase-config.js file.');
    await cmd.run(
        'firebase',
        [
          'apps:sdkconfig',
          '-i',
          'WEB',
          appID,
          '--interactive',
          '--out',
          configPath,
          '--project',
          projectID,
          '--token',
          firebaseToken
        ],
        verbose: true);
  }

  /// Git clone latest metrics code, build and deploy.
  Future<void> _buildAndDeploy(
    String appID,
    String projectID,
    String firebaseToken,
    String repoURL,
    String srcPath,
  ) async {
    final workingDir = '$srcPath/metrics/web';
    final configPath = '$workingDir/web/firebase-config.js';
    // git clone repo
    await cmd.run('git', ['clone', repoURL, srcPath], verbose: true);
    // clean previouse config
    await cmd.run('rm', ['-rf', configPath], verbose: true);
    await _downloadSDKConfig(appID, configPath, projectID, firebaseToken);
    // add firebase project
    await cmd.run('firebase', ['use', '--add', projectID],
        workingDirectory: workingDir, verbose: true);
    // flutter build web --dart-define=FLUTTER_WEB_USE_SKIA=true
    await cmd.run('flutter', ['build', 'web'],
        workingDirectory: workingDir, verbose: true);
    // firebase deploy --only hosting
    await cmd.run('firebase', ['deploy', '--only', 'hosting'],
        workingDirectory: workingDir, verbose: true);
  }

  /// Cleanup resources.
  Future<void> cleanup(String srcPath) async {
    await cmd.run('rm', ['-rf', srcPath], verbose: true);
  }
}
