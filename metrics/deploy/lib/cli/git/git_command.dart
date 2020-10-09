import 'package:args/command_runner.dart';
import 'package:process_run/process_run.dart' as cmd;
import 'package:process_run/shell.dart';


/// class wrapping up gcloud CLI
class GitCommand {
  
  Future<void> clone(String repoURL, String srcPath) async {
     await cmd.run('git', ['clone', repoURL, srcPath], verbose: true);
  }
}