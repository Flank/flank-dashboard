# Debug menu design

## TL;DR

Introducing the `Debug Menu` feature to the Metrics Web Application allows us to access the debug features of the application, such as the `FPS Monitor`. The `Debug Menu` stores configurations locally and uses them to enable or disable some features.

## Hive

One of the main ideas of the `Debug Menu` feature is to store the configurations locally. That means that we are to use local persistent storage that would provide the application with the current debug configurations if they are enabled and keep these configurations for different sessions.

For the current implementation, we suggest using the [`Hive` package](https://pub.dev/packages/hive) that uses the [`IndexedDB`](https://developers.google.com/web/ilt/pwa/working-with-indexeddb) to store key-value pairs in [boxes](https://docs.hivedb.dev/#/basics/boxes). Read more about Hive in their [documentation](https://docs.hivedb.dev/#/).

The local configurations are to be stored using the following document structure that matches one for the [`Firestore Feature Config`](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/features/feature_config/01_feature_config_design.md) feature:
```json
{
  "local_config" : {
    "isFpsMonitorEnabled" : false
  }
}
```

## Metrics Web Application

The following sub-sections provide an implementation of `Debug Menu` feature for the Metrics Web Application by layers. Read more about layers and their responsibilities in the [Metrics Web Application architecture document](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/01_metrics_web_application_architecture.md).

### Data layer

The data layer provides the `HiveLocalConfigRepository` implementation of `LocalConfigRepository` and `LocalConfigData` model that represents a `DataModel` implementation for the `LocalConfig` entity.

The following class diagram states the structure of the data layer:

![Data layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/debug_menu/diagrams/debug_menu_data_layer_class_diagram.puml)

### Domain layer

The domain layer should provide an interface for the `HiveLocalConfigRepository` we need to interact with. Also, the layer provides all the use cases required to interact with the repository, and entities required for the `Debug Menu` feature. Thus, the following list of classes should be implemented to fit the feature requirements:

- Implement the `LocalConfigRepository` interface with appropriate methods.
- Add the `LocalConfig` entity with fields that come from the `IndexedDB`.
- Add the `OpenLocalConfigStorageUseCase`, `ReadLocalConfigUseCase`, `UpdateLocalConfigUseCase`, `CloseLocalConfigStorageUseCase` to interact with the repository.

The following class diagram demonstrates the domain layer structure:

![Domain layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/debug_menu/diagrams/debug_menu_domain_layer_class_diagram.puml)

### Presentation layer

Once we've added both the domain and data layers, it's time to add the feature to the presentation. `DebugMenuNotifier` maintains the state of the local config and is integrated into the `InjectionContainer` so it is available within the application.

The following class diagram demonstrates the structure of the presentation layer:

![Presentation layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/debug_menu/diagrams/debug_menu_presentation_layer_class_diagram.puml)

The following sequence diagram describes how the application applies `Local Config` values when a user enters the application:

![Read config sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/debug_menu/diagrams/debug_menu_read_config_sequence_diagram.puml)

Let's consider the mechanism of applying the `Local Config` values. When a user enters the application, he or she stays on the `LoadingPage` until the `Local Config` is initialized.

First, the application fetches the `Feature Config` that includes the `isDebugMenuEnabled` configuration value. If the `Debug Menu` feature is disabled from the remote, all debug features are disabled by default, and no interaction with local persistent storage happens. It is important to remember that disabling `Debug Menu` disables **all debug configurations for all users starting new sessions but not for currently running sessions**.

After the application fetches the `Feature Config` values and ensures the `Debug Menu` feature **is enabled**, the application calls the `initializeLocalConfig` method of the `DebugMenuNotifier`. Then the notifier follows the below steps:
1. Opens the `local_config` storage box.
2. Sets the `isLoading` status to `true` indicating that the config is loading.
3. Fetches the key-value configuration pairs for debug features within the application.
4. Sets the `isInitialized` status to `true` indicating that configurations are ready to use.
5. Sets the `isLoading` status to `false` indicating that the config is loaded.
6. Notifies the UI about configurations initialized.

The application then dismisses the loading page so the user can proceed.

The only difference for the disabled `Debug Menu` feature is that the application calls the `initializeDefaults` method of the `DebugMenuNotifier`. Notifier then uses default values for the debug configurations and doesn't perform any calls to the local storage.

The following sequence diagram describes how the application updates the `Local Config` values:

![Update config sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/debug_menu/diagrams/debug_menu_update_config_sequence_diagram.puml)

Let's consider the mechanism of updating the `Local Config` values in the application. Assume that the `local_config` box has been opened already using the `OpenLocalConfigStorageUseCase` within the initialize method. The following steps describe how the application acts when the user updates the `Local Config`, e.g. by toggling the FPS Monitor:
1. The UI calls the `toggleFpsMonitor` method of the `DebugMenuNotifier`.
2. The `DebugMenuNotifier` updates the `Local Config` in the `IndexedDB`.
3. The `DebugMenuNotifier` updates the `LocalConfigFpsMonitorViewModel` and notifies the application.

Now, the user sees the updated UI with the toggled FPS monitor. The application does not change the UI until the `local_config` box update succeeds.

The `DebugMenuNotifier` is implemented to close all the opened boxes when the notifier is disposed (not in the widget tree). Currently, the notifier calls the `CloseLocalConfigStorageUseCase` usecase when the user exits the application.
