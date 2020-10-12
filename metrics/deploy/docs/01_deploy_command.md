# Metrics deploy CLI

 Metrics CLI to automate deployment of the metrics app.

# References

https://github.com/platform-platform/monorepo/issues/608

# Motivation

Automation of manual steps to deploy metrics app.

# Goals

As a user, I want to automatically deploy metrics so I can use the app.
As a user, I want to know that my environment has the necessary commands so I can run deploy metrics.
As a user, I want to automatically upgrade metrics so I can use the latest version of the app.
As a user, I want to define configuration in a version controlled YAML file so I can deploy without answering interactive prompts.
Use our https://github.com/platform-platform/monorepo/tree/master/yaml_map package.

# Non-Goals

Deployment to other cloud providers then Google Cloud.

# Design

> Explain and diagram the technical design

Metrics CLI is wrapper around gcloud and firebase CLI written in Dart.

> Identify risks and edge cases.

Testing building infrastructure with gcloud and firebase CLI can only be done manually.


# API

Check the environment for all required dependencies (git CLI, npm, etc.) and print information to the user. See flutter doctor for inspiration.

```
metrics doctor
```

Deploy.

```
metrics deploy
```

Automatically update to the latest master version of the metrics app and deploy to Firebase.

```
metrics upgrade
```

Use a yaml file to configure the deployments.

```
metrics:
  region: us-east
```



# Dependencies

> What is the project blocked on?

> What will be impacted by the project?



# Testing

> How will the project be tested?

# Alternatives Considered

> Summarize alternative designs (pros & cons)

We looked to use Terraform to automate creation of GCloud infrastructure but its more suited to managing ingfrastructure not deploying application.

# Timeline

> Document milestones and deadlines.

DONE:

  - metrics deploy 
  - metrics doctor

NEXT:

  - yaml config
  
# Results

> What was the outcome of the project?
