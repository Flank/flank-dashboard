# Update feature Analysis
> Feature description / User story.

As a user, I want to have the opportunity to update an existing project, so I don't have to create a new one every time.

## Contents

- [**Analysis**](#analysis)
    - [Feasibility study](#feasibility-study)
    - [Requirements](#requirements)
    - [Landscape](#landscape)
    - [Prototyping](#prototyping)
      - [Update Config](#update-config)
      - [Updater](#updater)
    - [System modeling](#system-modeling)

# Analysis
> Describe a general analysis approach.

During the analysis stage, we are going to investigate the implementation approaches for updating existing projects with the Metrics CLI.

### Feasibility study
> A preliminary study of the feasibility of implementing this feature.

For now, the Metrics CLI does not have the command to redeploy the Metrics WEB using the existing GCloud project but only deploys to the new one every time.
There are two problems associated with the above:
- the GCloud has account restrictions on the number of projects, and deleting an existing one takes a long time(30 days);
- the end-user requires to configure the newly created GCloud project every Metrics Web deployment

Therefore, to improve the UX of the Metrics CLI, we should implement a command which provides the ability to redeploy the Metrics WEB using the existing GCloud project.
Since the update command is a modified deploy command, where the YAML config is used instead of the user interaction, it is possible to implement the update feature.

### Requirements
> Define requirements and make sure that they are complete.

The update command implementation approach must satisfy the following requirements:
- Designed YAML configuration structure required for the update command in the Metric CLI
- Possibility to update an existing project using the YAML update command configuration.

### Landscape
> Look for existing solutions in the area.

Deploying the metrics web to the existing GCloud project is a complex process with the custom steps, such as Sentry configuring, deploying the Metrics WEB to the hosting, etc., so the custom solution is used.

Let's review the top-level approach of the desired feature:

After analyzing the whole process of the update command, we have highlighted the following methods required to implement the command:
- parse the configuration YAML
- checkout project from the repository
- install npm dependencies
- build flutter web 
- configuring Sentry
- deploy rules and functions
- deploy to the hosting.

All methods above have already been implemented for the Deploy command, except the configuration YAML parsing.

For work with the YAML config, the following is required:
- create a model of the configuration representation
- integrate the YAML parser into the Metrics CLI.

### Prototyping
#### Update Config
Let's determine the data which config should include:
- The firebase auth token is required to access the Firebase account while deploying hosting, rules, and functions.
- The project id required to associate with the Firebase project while deploying hosting, rules, and functions.
- The client id for the Google sign-in is required to support the Google authentication.
- The auth token for Sentry is used to access the Sentry account while creating Sentry releases.
- The Sentry organization slug, project slug, DSN, and release name required to create Sentry releases.

The code snippet below demonstrates the config template required by the update command:

```yaml
firebase:
  firebase_auth_token: firebase_auth_token
  project_id: project_id
  google_sign_in_client_id: google_sign_in_client_id
sentry:
  auth_token: sentry_auth_token
  organization_slug: organization_slug
  project_slug: project_slug
  project_dsn: project_dsn
  release_name: release_name
```

_**Note**: Sentry is an optional attribute. If the user doesn't specify it, the update command will not create a new Sentry release._

#### Updater
The following code snippet demonstrates the process of the update feature in general:

```dart
  Future<void> update() async {
    final configFile = File(pathToConfig);
    final config = yamlParser.parse(configFile);
    final firebase = config.firebase;
    final sentry = config.sentry;

    await _gitService.checkout(repoURL, rootPath);
    await _installNpmDependencies(firebasePath, firebaseFunctionsPath);
    await _flutterService.build(webAppPath);

    if (sentry != null) {
      await _sentryService.createRelease(
        sentry.sentryRelease,
        List < SourceMap > sourceMaps,
        sentry.authToken,
      );
    }

    final sentryConfig = SentryConfig(
      release: sentry.release.name,
      dsn: sentry.dsn,
      environment: UpdateConstants.sentryEnvironment,
    )
    final metricsConfig = WebMetricsConfig(
      googleSignInClientId: firebase.googleSignInClientId,
      sentryConfig: sentryConfig,
    );
    
    _applyMetricsConfig(metricsConfig, metricsConfigPath);

    await _deployToFirebase(
      firebase.projectId,
      firebasePath,
      webAppPath,
      firebase.authToken,
    );
  }
```

### System modeling
> Create an abstract model of the system/feature.

The following abstract sequence diagrams illustrate how the update command should work in general:

![Update command sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/update_command_analysis/metrics/cli/docs/diagrams/abstract_update_command_sequence_diagram.puml)
