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

  final firebase = FirebaseCommand();
  final gcloud = GCloudCommand();
  final git = GitCommand();

  DeployCommand();

  @override
  Future<void> run() async {
    final firebaseToken = await _login();

    final projectID = await gcloud.addProject();

    await firebase.addFirebase(projectID, firebaseToken);

    final region = await _selectRegion();

    await gcloud.addProjectApp(region, projectID);

    await gcloud.createDatabase(region, projectID);

    final appID = await firebase.createWebApp(projectID, firebaseToken);
    const repoURL = 'git@github.com:platform-platform/monorepo.git';
    const srcPath = 'src';
    //final firebaseSrc = srcPath + '/metrics/firebase';
    await _buildAndDeploy(appID, projectID, firebaseToken, repoURL, srcPath);
    // Cleanup
    await cleanup(srcPath);
    // Terminate prompt entry.
    await promptTerminate();
  }

  /// Login to GCloud and Firebase and get firebase CI token
  Future<String> _login() async {
    await gcloud.login();
    await firebase.login();
    // Configure firebase project
    return prompt('Copy Firebase Token from above');
  }

  ///  Select GCP region
  Future<String> _selectRegion() async {
    // TODO: Listing regions won't work on new projects as compute API not enabled yet.
    //await run('gcloud',['compute','regions','list'],verbose:true);
    print('Select default region.');
    return prompt('region');
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
    await git.clone(repoURL, srcPath);
    // clean previouse config
    await cmd.run('rm', ['-rf', configPath], verbose: true);
    await firebase.downloadSDKConfig(
        appID, configPath, projectID, firebaseToken);
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
