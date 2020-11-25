# Firebase Remote config design

We want to add the `Remote Config` feature to the Metrics application.
The `Remote Config` lets us disable or enable app features remotely from the Firebase Console.
The following steps are required to introduce the `Remote Config` in the application.

## Firebase API Key restrictions

We need to enable the `Remote Config` API:

1. Open the [Google Cloud Platform](https://console.cloud.google.com/home/dashboard) and select your project in the top left corner.
2. Open the side menu and go to the `APIs & Services` section.
3. Go to the `Credentials` section, find the `Browser Key` in the `API Keys` section, and open it.
4. Scroll down to the `API Restrictions` section, and click the `Restrict Key` button.
5. In the opened dropdown, enable the following APIs: `Firebase Installations API` and `Firebase Remote Config API`.

## Firebase Configuration

The `Remote Config` will contain key-value pairs where the key stands for the feature name and the value indicates whether this feature is enabled or not.

So, we need to specify these parameters in the Firebase console.

For our purposes, we need to specify parameters for the `FPS Monitor`, `Login Form`, and `Renderer Display` features.

Example of possible key-values are:

```json
isLoginFormEnabled: true
isFpsMonitorEnabled: false
isRendererDisplayEnabled: false
```

## Metrics application

### Domain layer

In the application domain layer, we should add an ability to read values from the `Remote Config`. For this purpose, we should:

1. Create the `RemoteConfig` entity.
2. Add the `getConfig` method to the `RemoteConfigRepository`.
3. Implement the `GetRemoteConfigUseCase` class.

So, the domain layer should look like this:

![Domain layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/remote_config_design/metrics/web/docs/features/remote_config/diagrams/remote_config_domain_class.puml)

### Data layer

The `FirebaseRemoteConfigRepository` of the data layer should implement the methods from the `RemoteConfigRepository` interface. To do that, we should create a `FirebaseRemoteConfigAdapter` class.

The following class diagram represents the classes of the data layer required for this feature:

![Data layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/remote_config_design/metrics/web/docs/features/remote_config/diagrams/remote_config_data_class.puml)

### Presentation layer

Once we've created a domain and data layers, it's time to create a presentation layer. This layer contains the `RemoteConfigNotifier` - the class that manages `Remote Config` values.

1. Create a `RemoteConfigNotifier` class.
2. Implement the fields that stand for `Remote Config` values.
3. Inject the notifier into the `InjectionContainer`.

The following class diagram represents the classes of the presentation layer required for this feature:

![Presentation layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/remote_config_design/metrics/web/docs/features/remote_config/diagrams/remote_config_presentation_class.puml)

So, when the user enters the application, the following sequence diagram describes how the application applies `Remote Config` values:

![Sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/remote_config_design/metrics/web/docs/features/remote_config/diagrams/remote_config_sequence.puml)

Let's consider the mechanism of applying the `Remote Config` values in the application.

When the user enters the application, he sees the `LoadingPage` while waiting until the `_initializeRemoteConfig` method of the `RemoteConfigNotifier` finishes. After that, the `isLoading` status of the `RemoteConfigNotifier` sets to `false`, and the user can see the UI with `Remote Config` values applied.
