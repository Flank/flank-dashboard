# Update feature Analysis
> Feature description / User story.

As a user, I want to have the opportunity to update an existing project, so I don't have to create a new one every time.

# Analysis
> Describe the general analysis approach.

During the analysis stage, we are going to investigate the implementation approaches for updating existing projects with the Metrics CLI.

## Feasibility study
> A preliminary study of the feasibility of implementing this feature.

The 3-rd parties CLIs used in the Metrics CLI provide all the necessary methods for the update purposes.

## Requirements
> Define requirements and make sure that they are complete.

The update command implementation approach must satisfy the following requirements:
- Possibility to parse the user update command configuration from the YAML file;
- Possibility to update an existing project using the YAML update command configuration;

## Landscape
> Look for existing solutions in the area.

We should create a new command, which should reuse implemented methods and provide the opportunity to redeploy the Metrics project to an existing GCloud project.
The command should work without user interaction, but using the configuration YAML file, so we can use it in the GitHub actions and so on, lately.

Let's review how to approach it in the next sections.

### Update Command

After analyzing the whole process of the update command, we have highlighted the following methods required to implement the command:
- parse the configuration YAML
- checkout project from the repository
- install npm dependencies
- build flutter web 
- configuring Sentry
- deploy rules and functions
- deploy to the hosting.

All methods above have already been implemented for the Deploy command, except the configuration YAML parsing.
The configuration YAML parsing implementation requires:
- integrate the YAML parser into the Metrics CLI
- create the model of the configuration representation.

Let's take a closer look at the configuration structure further.

#### Configuration structure

Let's determine the data which config should include:
- The firebase auth token required to access the Firebase account while deploying hosting, rules and functions.
- The project id required to associate with the Firebase project while deploying hosting, rules and functions.
- The client id for the Google sign-in required to support the Google authentication.
- The auth token for Sentry used to access the Sentry account while creating Sentry releases.
- The Sentry organization slug, project slug, DSN, and release name required to create Sentry releases.

The code snippet below demonstrates the config template required by the update command.

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

### System modeling
> Create an abstract model of the system/feature.

The following abstract sequence diagrams illustrate how the update command should work in general:

![Update command sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/update_command_analysis/metrics/cli/docs/diagrams/abstract_update_command_sequence_diagram.puml)
  
### Conclusion
Taking into account the results of the analysis, we can implement a command which can redeploy the Metrics WEB project.
