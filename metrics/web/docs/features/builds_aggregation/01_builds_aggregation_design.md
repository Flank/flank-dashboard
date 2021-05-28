# Builds Aggregation design

## Introduction

At this time, for the `builds per week`/`performance` metrics, we download all the builds of the project for the last 7 days using Firebase advanced query, process calculations, and display the information on the `Metrics` dashboard. But we might have cases when there are more than 1000 builds per week. This increases the number of reads from the database and leads to heavy load/price implications.

There are Firestore collection and Cloud Functions, which [provides builds aggregations](https://github.com/Flank/flank-dashboard/blob/master/metrics/firebase/docs/features/builds_aggregation/01_firestore_builds_aggregation_design.md), so we need to use these calculations inside the Metrics Web Application. With that we do not need to calculate the metrics every time we load the dashboard, instead, we can take that information from the Firestore.

## References

> Link to supporting documentation, GitHub tickets, etc.

- [Project Metrics Definitions](https://github.com/Flank/flank-dashboard/blob/master/docs/05_project_metrics.md)
- [Github epic: Reduce Firebase usage / document reads](https://github.com/Flank/flank-dashboard/issues/1042)
- [Firebase builds aggregation](https://github.com/Flank/flank-dashboard/blob/master/metrics/firebase/docs/features/builds_aggregation/01_firestore_builds_aggregation_design.md)

## Metrics application

The following sub-sections provide an implementation of Build aggregation integration for the Metrics Web Application by layers. Read more about layers and their responsibilities in the [Metrics Web Application architecture document](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/01_metrics_web_application_architecture.md).

### Domain layer

The domain layer should provide an interface for data fetching. Also, the layer provides a usecase required to interact with the repository, and entity for the `Builds Aggregation` feature. Thus, the following list of classes should be implemented to fit the feature requirements:

- Implement the `BuildDayRepository` interface with appropriate methods.
- Add the `BuildDay` entity with fields that come from a remote API.
- Add the `ReceiveBuildDayProjectMetricsUpdates` usecase.

The following class diagram demonstrates the domain layer structure:

![Domain layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/builds_aggregation/diagrams/build_days_domain_layer_class_diagram.puml)

### Data layer

The data layer provides the `FirestoreBuildDayRepository` implementation of the `BuildDayRepository`. Also, it provides a `BuildDayData` class that represents a `DataModel` implementation for the `BuildDay` entity.

![Data layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/builds_aggregation/diagrams/build_days_data_layer_class_diagram.puml)

### Presentation layer

Once we've added both the domain and data layers, it's time to add the feature to the presentation.

The `ProjectMetricsNotifier` should have one more argument - `ReceiveBuildDayProjectMetricsUpdates` usecase. It provides a `BuildDayProjectMetrics` to display on the dashboard. When a new list of projects is fetched, we should subscribe to a `BuildDayProjectMetrics` for each project in the list, using the created usecase. Once we've got the metrics, we can use them to provide `BuildNumberScorecardViewModel` and `PerformanceSparklineViewModel` that is actually used on the dashboard. 

The following class diagram demonstrates the presentation layer structure:

![Presentation layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/builds_aggregation/diagrams/build_days_presentation_layer_class_diagram.puml)

So, as we have the `PerformanceMetric` and `BuildNumberMetric` in the `BuildDayProjectMetrics`, we don't need them inside the existing `DashboardProjectMetrics`.

The following sequence diagram describes how the application loads and shows aggregation metrics:

![Sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/builds_aggregation/diagrams/build_days_sequence_diagram.puml)
