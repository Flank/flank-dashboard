// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/services.dart';
import 'package:cli/prompter/prompter.dart';
import 'package:cli/prompter/writer/io_prompt_writer.dart';
import 'package:cli/services/firebase/adapter/firebase_cli_service_adapter.dart';
import 'package:cli/services/firebase/cli/firebase_cli.dart';
import 'package:cli/services/flutter/adapter/flutter_cli_service_adapter.dart';
import 'package:cli/services/flutter/cli/flutter_cli.dart';
import 'package:cli/services/gcloud/adapter/gcloud_cli_service_adapter.dart';
import 'package:cli/services/gcloud/cli/gcloud_cli.dart';
import 'package:cli/services/git/adapter/git_cli_service_adapter.dart';
import 'package:cli/services/git/cli/git_cli.dart';
import 'package:cli/services/npm/adapter/npm_cli_service_adapter.dart';
import 'package:cli/services/npm/cli/npm_cli.dart';
import 'package:cli/services/sentry/adapter/sentry_cli_service_adapter.dart';
import 'package:cli/services/sentry/cli/sentry_cli.dart';

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
    final npmCli = NpmCli();
    final gitCli = GitCli();
    final firebaseCli = FirebaseCli();
    final sentryCli = SentryCli();

    final flutterService = FlutterCliServiceAdapter(flutterCli);
    final gcloudService = GCloudCliServiceAdapter(gcloudCli, prompter);
    final npmService = NpmCliServiceAdapter(npmCli);
    final gitService = GitCliServiceAdapter(gitCli);
    final firebaseService = FirebaseCliServiceAdapter(firebaseCli, prompter);
    final sentryService = SentryCliServiceAdapter(sentryCli, prompter);

    return Services(
      flutterService: flutterService,
      gcloudService: gcloudService,
      npmService: npmService,
      gitService: gitService,
      firebaseService: firebaseService,
      sentryService: sentryService,
    );
  }
}
