# Firebase Remote config design

## TL;DR

Introducing the `Remote Config` feature to the Metrics Web Application allows us to control features behavior for the application remotely without changing a codebase and redeploying. We can change configurations remotely direct from the Firebase Console and these changes will affect the application without any additional steps. This document lists steps and designs the `Remote Config` feature to introduce in the Metrics Web Application.

## Firebase API Key restrictions

At the first stage, you should enable the `Remote Config API`. Consider the following steps:

1. Open the [Google Cloud Platform](https://console.cloud.google.com/home/dashboard) and select the required project in the top left corner.
2. Open the side navigation menu and go to the `APIs & Services` page.
3. On the `APIs & Services` page open the `Credentials` section and click on the `Browser Key` under the `API Keys` sub-section.
4. Under the `API Restrictions` section on the page with the key configurations, select the `Restrict Key` option.
5. Open the appeared dropdown and enable the following APIs: `Firebase Installations API` and `Firebase Remote Config API`.

Once the above steps are completed, the `Remote Config API` is enabled for your web project. Please note that it may take some time for settings to take effect.

## Firebase Configuration

The `Remote Config` contains key-value pairs where a single key stands for a feature name it controls and a value indicates whether this feature is enabled or not. You can create and manage the `Remote Config` parameters in the Firebase Console. Consider the following steps to open the required page:

1. Open the [Firebase console](https://console.firebase.google.com/) and select your project.
2. On the left panel, scroll down to the `Grow` section.
3. Click the `Remote Config` to browse to the configurations.

In order to add new values, fill both the `Parameter key` and `Default value` for the configuration you want to add and press the `Add parameter` button. Newly added key-value pairs aren't available until published. To publish draft changes press the `Publish changes` button at the top of the page that is highlighted with orange. 

For the Metrics Web Application purposes, we should specify parameters for the `FPS Monitor`, `Login Form`, and `Renderer Display` features. Thus, the configurations may look like the following:

```json
isLoginFormEnabled: true
isFpsMonitorEnabled: false
isRendererDisplayEnabled: false
```

Once the configurations are ready, we should prepare the Metrics Web application to use them.

## Metrics application

The following paragraph provides an implementation of remote config integration for the Metrics Web Application by layers. Read more about layers and their responsibilities in the [Metrics Web Application architecture document](https://github.com/platform-platform/monorepo/blob/master/metrics/web/docs/01_metrics_web_application_architecture.md).

### Data layer

The data layer provides the `FirebaseRemoteConfigurationRepository` implementation that uses the [Firebase package](https://pub.dev/packages/firebase) available for Flutter for Web and the `RemoteConfigurationData` that represents the `RemoteConfiguration` entity.

The following class diagram states the structure of the data layer:

![Data layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/web/docs/features/remote_config/diagrams/remote_config_data_layer_class_diagram.puml)

### Domain layer

The domain layer should provide an interface for the `FirebaseRemoteConfigurationRepository` we need to interact with the `Remote Config API`. Also, the layer provides all the use cases required to interact with the repository, and entities required for the `Remote Config` feature. Thus, the following list of classes should be implemented to fit the feature requirements:

- Implement the `RemoteConfigurationRepository` interface with appropriate methods.
- Add the `RemoteConfiguration` entity with fields that come from a remote API.
- Add the `SetDefaultRemoteConfigurationUseCase` to set the default configurations.
- Add the `FetchRemoteConfigurationUseCase` to perform fetching configurations.

The following class diagram demonstrates the domain layer structure:

![Domain layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/web/docs/features/remote_config/diagrams/remote_config_domain_layer_class_diagram.puml)

### Presentation layer

Once we've added both the domain and data layers, it's time to add the feature to the presentation. The state of the remote config is maintained by the `RemoteConfigurationNotifier` integrated to the `InjectionContainer` so it is available within the application.

The following class diagram demonstrates the structure of the presentation layer:

![Presentation layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/web/docs/features/remote_config/diagrams/remote_config_presentation_layer_class_diagram.puml)

The following sequence diagram describes how the application applies `Remote Config` values when a user enters the application:

![Sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/web/docs/features/remote_config/diagrams/remote_config_sequence_diagram.puml)

Let's consider the mechanism of applying the `Remote Config` values in the application. When a user enters the application, he or she stays on the `LoadingPage` until the `initializeRemoteConfiguration` method of the `RemoteConfigurationNotifier` finishes. Once the initializing completes, the `isLoading` status of the `RemoteConfigNotifier` is set to `false`. The user then can proceed to the application with the configurations applied.
