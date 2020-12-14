# Debug menu design

## TL;DR

Introducing the `Debug Menu` feature to the Metrics Web Application allows us to access the debug features of the application, such as the `FPS Monitor` and the `Renderer Display`.
The `Debug Menu` feature also allows us to store the local configuration needed to enable or disable some features locally and to load them on the application's start.

## Hive

To introduce this feature, we need to store the local configuration values using the `Hive` package that uses the `IndexedDB`.
We need to store the configuration values as following:  

```json
{
  "local_config" : {
    "isFpsMonitorEnabled" : false
  }
}
```

Read more about the `Hive` package using the following [link](https://pub.dev/packages/hive).

## Metrics application

The following sub-sections provide an implementation of `Debug Menu` integration for the Metrics Web Application by layers. Read more about layers and their responsibilities in the [Metrics Web Application architecture document](https://github.com/platform-platform/monorepo/blob/master/metrics/web/docs/01_metrics_web_application_architecture.md).

### Data layer

The data layer provides the `HiveLocalConfigRepository` implementation of `LocalConfigRepository` and `LocalConfigData` model that represents a `DataModel` implementation for the `LocalConfig` entity.

The following class diagram states the structure of the data layer:

![Data layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/debug_menu_document/metrics/web/docs/features/debug_menu/diagrams/debug_menu_data_layer_class_diagram.puml)

### Domain layer

The domain layer should provide an interface for the `HiveLocalConfigRepository` we need to interact with. Also, the layer provides all the use cases required to interact with the repository, and entities required for the `Debug Menu` feature. Thus, the following list of classes should be implemented to fit the feature requirements:

- Implement the `LocalConfigRepository` interface with appropriate methods.
- Add the `LocalConfig` entity with fields that come from the `IndexedDB`.
- Add the `OpenLocalConfigStorageUseCase`, `ReadLocalConfigUseCase`, `UpdateLocalConfigUseCase`, `CloseLocalConfigStorageUseCase` to interact with the repository.

The following class diagram demonstrates the domain layer structure:

![Domain layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/debug_menu_document/metrics/web/docs/features/debug_menu/diagrams/debug_menu_domain_layer_class_diagram.puml)

### Presentation layer

Once we've added both the domain and data layers, it's time to add the feature to the presentation. `DebugMenuNotifier` maintains the state of the local config and is integrated into the `InjectionContainer` so it is available within the application.

The following class diagram demonstrates the structure of the presentation layer:

![Presentation layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/debug_menu_document/metrics/web/docs/features/debug_menu/diagrams/debug_menu_presentation_layer_class_diagram.puml)

The following sequence diagram describes how the application applies `Local Config` values when a user enters the application:

![Read config sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/debug_menu_document/metrics/web/docs/features/debug_menu/diagrams/debug_menu_read_config_sequence_diagram.puml)

Let's consider the mechanism of applying the `Local Config` values in the application (considering that the `Hive`'s `local_config` box is already open using the `OpenLocalConfigStorageUseCase`). 
When a user enters the application, he or she stays on the `LoadingPage` until the `Local Config` is initialized.

Firstly, the application fetches the `Feature Config` that includes the `isDebugMenuEnabled` configuration value. 
Please consider the following steps performed by the application depending on the `isDebugMenuEnabled` configuration value:

If the `Debug Menu` feature **is enabled**:

    1. The application calls the `initializeLocalConfig` method of the `DebugMenuNotifier`.
    2. The `DebugMenuNotifier` waits until the initialization completes.
    3. The `DebugMenuNotifier` sets the `isLoading` status to `false`.
    4. The application reacts on the `DebugMenuNotifier.isLoading` changes and dismisses the `LoadingPage`. 
    5. The user proceeds to the application.

If the `Debug Menu` feature **is not enabled**:

    1. The application calls the `initializeLocalConfigWithDefaults` method of the `DebugMenuNotifier`. 
    2. The `DebugMenuNotifier` applies the default configuration values set in the constructor.
    3. The `DebugMenuNotifier` sets the `isLoading` status to `false`. 
    4. The application reacts on the `DebugMenuNotifier.isLoading` changes and dismisses the `LoadingPage`.
    5. The user proceeds to the application. 
    
The following sequence diagram describes how the application updates the `Local Config` values:

![Update config sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/debug_menu_document/metrics/web/docs/features/debug_menu/diagrams/debug_menu_update_config_sequence_diagram.puml)

Let's consider the mechanism of updating the `Local Config` values in the application (considering that the `Hive`'s `local_config` box is already open using the `OpenLocalConfigStorageUseCase`).
Please consider the following steps performed by the application when the user updates the `Local Config`, e.g. by toggling the FPS Monitor:

    1. The UI calls the `toggleFpsMonitor` method of the `DebugMenuNotifier`.
    2. The `DebugMenuNotifier` updates the `Local Config` in the `IndexedDB`.
    3. The `DebugMenuNotifier` updates the `FpsMonitorLocalConfigViewModel` and notifies the application.
    4. The user sees the updated UI with the toggled FPS monitor.

The application does not change the UI until the `local_config` box update succeeds.

When the user exits the application, the application calls the `dispose` method of the `DebugMenuNotifier`. The `dispose` method, in its turn, calls the `CloseLocalConfigStorage` usecase, that closes the `local_config` box.
