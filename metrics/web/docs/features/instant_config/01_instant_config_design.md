# Firestore Instant Config design

## TL;DR

Introducing the `Instant Config` feature to the Metrics Web Application allows us to control features behavior for the application remotely without changing a codebase and redeploying. 
We can change configurations remotely direct from the Firestore, and these changes will affect the application without any additional steps. 
This document lists steps and designs the `Instant Config` feature to introduce in the Metrics Web Application.

## Firestore

### Document structure

To introduce this feature, we need to create an `instant_config` collection in the Firestore database. This collection will contain the `instant_config` document with the following structure:

```json
{
    "isLoginFormEnabled": true,
    "isFpsMonitorEnabled": false,
    "isRendererDisplayEnabled": false
}
```

### Firestore security rules

Once we have a new collection, we have to add security rules for this collection. Everyone can read `instant_config` collection content but no one has access to create, update or delete collection documents. Thus, the following rules keep:

- Access-related rules:
    - not authenticated users **can** read and **cannot** create, update, delete this document; 
    - authenticated users **can** read and **cannot** create, update, delete this document.

## Metrics application

The following sub-sections provide an implementation of instant config integration for the Metrics Web Application by layers. Read more about layers and their responsibilities in the [Metrics Web Application architecture document](https://github.com/platform-platform/monorepo/blob/master/metrics/web/docs/01_metrics_web_application_architecture.md).

### Data layer

The data layer provides the `FirestoreInstantConfigRepository` implementation of `InstantConfigRepository` and `InstantConfigData` model that represents a `DataModel` implementation for the `InstantConfig` entity.

The following class diagram states the structure of the data layer:

![Data layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/web/docs/features/instant_config/diagrams/instant_config_data_layer_class_diagram.puml)

### Domain layer

The domain layer should provide an interface for the `FirestoreInstantConfigRepository` we need to interact with the `Firestore database`. Also, the layer provides all the use cases required to interact with the repository, and entities required for the `Instant Config` feature. Thus, the following list of classes should be implemented to fit the feature requirements:

- Implement the `InstantConfigRepository` interface with appropriate methods.
- Add the `InstantConfig` entity with fields that come from a remote API.
- Add the `FetchInstantConfigUseCase` to perform fetching configurations.

The following class diagram demonstrates the domain layer structure:

![Domain layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/web/docs/features/instant_config/diagrams/instant_config_domain_layer_class_diagram.puml)

### Presentation layer

Once we've added both the domain and data layers, it's time to add the feature to the presentation. `InstantConfigNotifier` maintains the state of the instant config and is integrated into the `InjectionContainer` so it is available within the application.

The following class diagram demonstrates the structure of the presentation layer:

![Presentation layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/web/docs/features/instant_config/diagrams/instant_config_presentation_layer_class_diagram.puml)

The following sequence diagram describes how the application applies `Instant Config` values when a user enters the application:

![Sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/web/docs/features/instant_config/diagrams/instant_config_sequence_diagram.puml)

Let's consider the mechanism of applying the `Instant Config` values in the application. When a user enters the application, he or she stays on the `LoadingPage` until the `initializeInstantConfig` method of the `InstantConfigNotifier` finishes. Once the initializing completes, the `isLoading` status of the `InstantConfigNotifier` is set to `false`. The user then can proceed to the application with the configurations applied.
