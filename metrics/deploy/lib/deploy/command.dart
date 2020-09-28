import 'package:args/command_runner.dart';
import 'package:process_run/process_run.dart';
import 'package:process_run/shell.dart';
import 'dart:io';
import 'package:process_run/process_run.dart' as cmd;
import 'dart:math';

const _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class DeployCommand extends Command {
  final name = "deploy";
  final description =
      "Creates GCloud and Firebase project and deploy metrics app.";
  DeployCommand();

  void run() async {
    // await deploy.start();
    // Login to GCloud and Firebase and get firebase CI token
    final FIREBASE_TOKEN = await login();
// Add project or use existing project
    final PROJECT_ID = await addProject();
//Add Firebase capabilities to project.
    await addFirebase(PROJECT_ID, FIREBASE_TOKEN);
// Select region
    final REGION = await selectRegion();
// Add project app needed to create firestore database.
    await addProjectApp(REGION, PROJECT_ID);
// Create database
    await createDatabase(REGION, PROJECT_ID);
// # Create web app
    final APP_ID = await createWebApp(PROJECT_ID, FIREBASE_TOKEN);
    final REPO_URL = 'git@github.com:platform-platform/monorepo.git';
    final SRC_PATH = 'src';
    final FIREBASE_SRC = SRC_PATH + '/metrics/firebase';
// BUILD AND DEPLOY APP
    await buildAndDeploy(
        APP_ID, PROJECT_ID, FIREBASE_TOKEN, REPO_URL, SRC_PATH);
    // Cleanup
    await cleanup(SRC_PATH);
// Terminate prompt entry.
    await promptTerminate();
  }

  Future<String> login() async {
    // GCloud login
    print('GCloud Login.');
    await cmd.run('gcloud', ['auth', 'login'], verbose: true);
// Firebase login
    print('Firebase login.');
    await cmd.run('firebase', ['login:ci', '--interactive'], verbose: true);
    // Configure firebase project
    return await prompt('Copy Firebase Token from above');
  }

  Future<String> addProject() async {
    var projectID = '';
    if (await promptConfirm('Create new project ?')) {
      print('Creating new project');
      projectID = 'metrics-' + getRandomString(5);
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

  void addFirebase(String PROJECT_ID, String FIREBASE_TOKEN) async {
    if (await promptConfirm('Add firebase capabilities to project ?')) {
      print('Adding Firebase capabilities.');
      await cmd.run('firebase',
          ['projects:addfirebase', PROJECT_ID, '--token', FIREBASE_TOKEN],
          verbose: true);
    } else {
      print('Skipping adding Firebase capabilities.');
    }
  }

  Future<String> selectRegion() async {
    // TODO: Listing regions won't work on new projects as compute API not enabled yet.
    //await run('gcloud',['compute','regions','list'],verbose:true);
    print('Select default region.');
    return await prompt('Region');
  }

  void addProjectApp(String REGION, String PROJECT_ID) async {
    if (await promptConfirm('Add project app ?')) {
      print('Adding project app.');
      await cmd.run('gcloud',
          ['app', 'create', '--region', REGION, '--project', PROJECT_ID],
          verbose: true);
    } else {
      print('Skipping adding project app.');
    }
  }

  void createDatabase(String REGION, String PROJECT_ID) async {
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
            REGION,
            '--project',
            PROJECT_ID,
            '--quiet'
          ],
          verbose: true);
    } else {
      print('Skipping adding project database.');
    }
  }

  Future<String> createWebApp(String PROJECT_ID, String FIREBASE_TOKEN) async {
    //firebase apps:create --project $projectID
    if (await promptConfirm('Add web app?')) {
      print('Adding Firebase web app.');
      await cmd.run(
          'firebase',
          [
            'apps:create',
            '--project',
            PROJECT_ID,
            '--token',
            FIREBASE_TOKEN,
            "WEB",
            PROJECT_ID
          ],
          verbose: true);
    } else {
      print('List existings apps.');
      await cmd.run('firebase',
          ['apps:list', '--project', PROJECT_ID, '--token', FIREBASE_TOKEN],
          verbose: true);
    }
    print('Select APP_ID.');
    return await prompt('APP_ID');
  }

  void downloadSDKConfig(String APP_ID, String CONFIG_PATH, String PROJECT_ID,
      String FIREBASE_TOKEN) async {
    // Get config
    print('Write web app SDK config to firebase-config.js file.');
    await cmd.run(
        'firebase',
        [
          'apps:sdkconfig',
          '-i',
          'WEB',
          APP_ID,
          '--interactive',
          '--out',
          CONFIG_PATH,
          '--project',
          PROJECT_ID,
          '--token',
          FIREBASE_TOKEN
        ],
        verbose: true);
  }

  void buildAndDeploy(
    String APP_ID,
    String PROJECT_ID,
    String FIREBASE_TOKEN,
    String REPO_URL,
    String SRC_PATH,
  ) async {
    final WORKING_DIRECTORY = SRC_PATH + '/metrics/web';
    final CONFIG_PATH = WORKING_DIRECTORY + '/web/firebase-config.js';
    // git clone repo
    await cmd.run('git', ['clone', REPO_URL, SRC_PATH], verbose: true);
// clean previouse config
    await cmd.run('rm', ['-rf', CONFIG_PATH], verbose: true);
    await downloadSDKConfig(APP_ID, CONFIG_PATH, PROJECT_ID, FIREBASE_TOKEN);
// add firebase project
    await cmd.run('firebase', ['use', '--add', PROJECT_ID],
        workingDirectory: WORKING_DIRECTORY, verbose: true);
// flutter build web --dart-define=FLUTTER_WEB_USE_SKIA=true
    await cmd.run('flutter', ['build', 'web'],
        workingDirectory: WORKING_DIRECTORY, verbose: true);
// firebase deploy --only hosting
    await cmd.run('firebase', ['deploy', '--only', 'hosting'],
        workingDirectory: WORKING_DIRECTORY, verbose: true);
  }

  void cleanup(String SRC_PATH) async {
    await cmd.run('rm', ['-rf', SRC_PATH], verbose: true);
  }
}
