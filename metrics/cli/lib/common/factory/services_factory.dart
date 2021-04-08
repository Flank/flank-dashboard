// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.
import 'package:cli/common/model/services.dart';
import 'package:cli/flutter/adapter/flutter_cli_service_adapter.dart';
import 'package:cli/flutter/cli/flutter_cli.dart';
import 'package:cli/gcloud/adapter/gcloud_cli_service_adapter.dart';
import 'package:cli/gcloud/cli/gcloud_cli.dart';
import 'package:cli/npm/adapter/npm_cli_service_adapter.dart';
import 'package:cli/npm/cli/npm_cli.dart';
import 'package:cli/git/adapter/git_cli_service_adapter.dart';
import 'package:cli/git/cli/git_cli.dart';
import 'package:cli/prompt/prompter.dart';
import 'package:cli/prompt/writer/io_prompt_writer.dart';

/// A class providing method for creating [Services] instance.
class ServicesFactory {
  /// Creates a new instance of the [ServicesFactory].
  const ServicesFactory();

  /// Creates a new instance of the [Services].
  Services create() {
    final promptWriter = IOPromptWriter();
    final prompter = Prompter(promptWriter);

    final flutterCli = FlutterCli();
    final gcloudCli = GCloudCli();
    final gitCli = GitCli();
    final npmCli = NpmCli();

    final flutterService = FlutterCliServiceAdapter(flutterCli);
    final gcloudService = GCloudCliServiceAdapter(gcloudCli, prompter);
    final npmService = NpmCliServiceAdapter(npmCli);
    final gitService = GitCliServiceAdapter(gitCli);

    return Services(
      flutterService: flutterService,
      gcloudService: gcloudService,
      gitService: gitService,
      npmService: npmService,
    );
  }
}
