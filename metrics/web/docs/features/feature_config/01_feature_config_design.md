# Firestore Feature Config design

## TL;DR

Introducing the `Feature Config` feature to the Metrics Web Application allows us to control features behavior for the application remotely without changing a codebase and redeploying. 
We can change configurations remotely direct from the Firestore, and these changes will affect the application without any additional steps. 
This document lists steps and designs the `Feature Config` feature to introduce in the Metrics Web Application.

## Firestore

### Document structure

To introduce this feature, we need to create an `feature_config` collection in the Firestore database. This collection will contain the `feature_config` document with the following structure:

```json
{
    "isPasswordSignInOptionEnabled": true,
    "isDebugMenuEnabled": true
}
```

### Firestore security rules

Once we have a new collection, we have to add security rules for this collection. Everyone can read `feature_config` collection content but no one has access to create, update or delete collection documents. Thus, the following rules keep:

- Access-related rules:
    - not authenticated users **can** read and **cannot** create, update, delete this document; 
    - authenticated users **can** read and **cannot** create, update, delete this document.

## Metrics application

The following sub-sections provide an implementation of Feature config integration for the Metrics Web Application by layers. Read more about layers and their responsibilities in the [Metrics Web Application architecture document](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/01_metrics_web_application_architecture.md).

### Data layer

The data layer provides the `FirestoreFeatureConfigRepository` implementation of `FeatureConfigRepository` and `FeatureConfigData` model that represents a `DataModel` implementation for the `FeatureConfig` entity.

The following class diagram states the structure of the data layer:

![Data layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/feature_config/diagrams/feature_config_data_layer_class_diagram.puml)

### Domain layer

The domain layer should provide an interface for the `FirestoreFeatureConfigRepository` we need to interact with the `Firestore database`. Also, the layer provides all the use cases required to interact with the repository, and entities required for the `Feature Config` feature. Thus, the following list of classes should be implemented to fit the feature requirements:

- Implement the `FeatureConfigRepository` interface with appropriate methods.
- Add the `FeatureConfig` entity with fields that come from a remote API.
- Add the `FetchFeatureConfigUseCase` to perform fetching configurations.

The following class diagram demonstrates the domain layer structure:

![Domain layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/feature_config/diagrams/feature_config_domain_layer_class_diagram.puml)

### Presentation layer

Once we've added both the domain and data layers, it's time to add the feature to the presentation. `FeatureConfigNotifier` maintains the state of the Feature config and is integrated into the `InjectionContainer` so it is available within the application.

The following class diagram demonstrates the structure of the presentation layer:

![Presentation layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/feature_config/diagrams/feature_config_presentation_layer_class_diagram.puml)

The following sequence diagram describes how the application applies `Feature Config` values when a user enters the application:

![Sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/feature_config/diagrams/feature_config_sequence_diagram.puml)

Let's consider the mechanism of applying the `Feature Config` values in the application. When a user enters the application, he or she stays on the `LoadingPage` until the `initializeConfig` method of the `FeatureConfigNotifier` finishes. Once the initializing completes, the `isLoading` status of the `FeatureConfigNotifier` is set to `false`. The user then can proceed to the application with the configurations applied.
