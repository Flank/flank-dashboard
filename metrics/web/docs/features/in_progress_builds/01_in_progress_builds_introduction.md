# In-Progress Builds Introduction

## Introduction

The Metrics Web Application displays different project metrics using builds of this project. To make metrics more reliable, the application should support in-progress builds. This document describes the design of introduction in-progress builds into the Metrics Web Application.

## References
> Link to supporting documentation, GitHub tickets, etc.

- [Metrics Web Application Architecture](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/01_metrics_web_application_architecture.md)
- [Project Metrics Definitions](https://github.com/Flank/flank-dashboard/blob/master/docs/05_project_metrics.md)

## Design
> Explain and diagram the technical design.

The In-Progress builds introduction requires changes to both `core` and `web` components. The following subsections discover these changes. First, let's take a look at what the `in-progress build` means in terms of the application. As this definition affects both Metrics Web Application and CI Integration tool, it is presented within the `core` component.

### Core

The `core` component of the Metrics project contains the `BuildStatus` enum that represents possible statuses of the `Build`. The `in-progress build` means that the `Build` entity has the specific `status` field value that identifies this build as in-progress. This definition requires adding a new `inProgress` value to the `BuildStatus` enum. Thus, the `in-progress build` means that the build has `BuildStatus.inProgress` status.

The following class diagram demonstrates the `core` structure of classes related to builds. Note that the class structure doesn't change but the `BuildStatus` enum contains a new value.

![Build Core Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/in_progress_builds/diagrams/build_core_class_diagram.puml)

### Metrics Web Application

The following subsections cover the in-progress builds introduction into Metrics Web Application by layers. To know more about the application's architecture, consider the [Metrics Web Application Architecture](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/01_metrics_web_application_architecture.md) document. Working with builds is concentrated within the `dashboard` package so the following sections' statements are mainly related to the `dashboard` module.

#### Domain Layer

The domain layer of the `dashboard` module provides the `MetricsRepository` interface, use cases to interact with the repository, and entities with metrics data to display on the dashboard page. The `ReceiveProjectMetricsUpdates` use case is responsible for subscribing to project builds and calculating metrics using these builds. 

The following table describes changes in metrics calculation according to the in-progress builds integration:

|Metric|Required Changes|
|---|---|
|Project Status|No changes required.|
|Builds' Results|No changes required.|
|Performance|Count only finished builds as in-progress builds have no fixed duration and should be filtered out.|
|Number of Builds|No changes required.|
|Stability|Divide the number of successful builds by the number of finished builds. This means that in-progress builds should not participate in the calculation of the stability metric and should be filtered out.|
|Coverage|No changes required.|

The above changes are related to the `ReceiveProjectMetricsUpdates` use case. The following diagram demonstrates the structure of the domain layer for the `dashboard` module:

![Domain Layer Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/in_progress_builds/diagrams/domain_layer_class_diagram.puml)

#### Data Layer

The data layer of the `dashboard` module contains two important classes:
- `FirestoreMetricsRepository` implementation of the `MetricsRepository` interface - loads builds to display on the dashboard;
- `BuildDataDeserializer` - deserializes a build using its JSON map. 

Both of these classes use `BuildStatus` in their implementations. However, adding a new value to the `BuildStatus` enum doesn't affect them and therefore doesn't change the data layer implementation. Generally speaking, in-progress builds don't require additional logic to be introduced to the data layer.

To clarify that build's status parsing during the deserialization doesn't requires changes, let's take a look at how this status is parsed: 
```dart
    final buildResultValue = json['buildStatus'] as String;
    final buildStatus = BuildStatus.values.firstWhere(
      (element) => '$element' == buildResultValue,
      orElse: () => BuildStatus.unknown,
    );
```

The following class diagram demonstrates the structure of the data layer for the `dashboard` module:

![Data Layer Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/in_progress_builds/diagrams/data_layer_class_diagram.puml)

#### Presentation Layer

The presentation layer contains the UI-related implementations such as state, pages, widgets, and view models. The in-progress builds introduction requires UI changes to display them. These changes don't affect the dashboard page as the page widget just places UI elements, however some of these UI elements - more precisely, dashboard-specific widgets - displays or closely related to displaying builds and their results. Furthermore, the `state` class that provides view models with data to display also needs changes to the processing entities.

##### State & View Models

The state management of the `dashboard` module is represented by the `ProjectMetricsNotifier`. This class doesn't directly use the `BuildStatus`, however, as the `ProjectMetricsNotifier` processes entities into view models, it requires changes. More precisely, these changes are related to the view models which stand for the project metrics.

The main idea is to divide the build result view model into two specific `FinishedBuildResultViewModel` and `InProgressBuildResultViewModel` for finished and in-progress builds respectively. This idea is based on the fact that the UI elements responsible for displaying these types significantly differ (consider the [Widgets](#widgets) section to discover the UI elements). This separation is also required according to the fact that in-progress builds have no stable `duration` meaning that it grows until the build is finished.

Furthermore, as the in-progress builds have no stable `duration`, the state and view models should be updated to provide the maximum possible duration for the list of builds in `BuildResultMetricViewModel`. This prevents the graph with build results from displaying bars for in-progress builds significantly larger than bars for finished builds (which have fixed duration). This means that the state should process the list of builds to define the maximum possible duration and provide it with the `BuildResultMetricViewModel` instance in the `maxBuildDuration` field.

Also, the `BuildResultPopupViewModel` shouldn't require the given duration to be non-null anymore. This is strongly related to the UI design changes and the fact that the popup doesn't display duration for in-progress builds.

##### Timer State

The [Widgets](#widgets) section below describes the changes related to widgets implementation. One of these widgets is the `BuildResultBarGraph` that is to animate a list of bars if this list contains in-progress build(s). To imitate the building process, the graph rebuilds bars every second changing their height that stands for durations of builds. But placing the logic with triggering rebuild every second inside the widget makes this widget too complex and hard to test. Moreover, this solution breaks the requirements of the application's architecture - UI elements should contain as little logic as possible. The `TimerNotifier` is to handle the problem.

The `TimerNotifier` provides a convenient way to work with the `Timer` and subscribe to the timer ticks. Using the `ChangeNotifierProxyProvider` the `ProjectMetricsNotifier` starts timer calling the `TimerNotifier.start(Duration period)` once builds are loaded. The `period` is the duration to pass as a time between ticks of the timer (consider the [Timer.periodic](https://api.dart.dev/stable/2.12.1/dart-async/Timer/Timer.periodic.html) documentation to know more details). The widgets then subscribe to the `TimerNotifier` changes and react on ticks.

To sum up, implementing the `TimerNotifier` simplifies testing bar graphs for builds results, reduces logic within widgets implementation, and optimizes the application.

The following class diagram demonstrates the updated structure of states and view models related to project metrics and builds:

![Presentation Layer Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/in_progress_builds/diagrams/presentation_layer_class_diagram.puml)

##### Widgets

The introduction of in-progress builds requires changing the UI elements so they can display such builds. All the UI elements of Metrics Web Application are represented by widgets or their combinations. Widgets that are responsible for displaying build results are placed within the `dashboard` module.

The following table lists the UI elements that require changes (or should be created) with a short description.

|UI Element|Widget|Classification|Changes description|
|---|---|---|---|
|Build result popup|`BuildResultPopupCard`|metrics widget|Hide the subtitle with duration if the given duration is `null`.|
|Build result bar component|`BuildResultBarComponent`|metrics widget|Create a new widget that displays the bar itself and applies a popup with graph indicator to this bar. This allows moving popup displaying logic to the top and separating it from the bar.|
|Build result bar|`BuildResultBar`|metrics widget|Select a widget to display depending on the build result view model type (either `FinishedBuildResultViewModel` or `InProgressBuildResultViewModel`). Displays either `MetricsColoredBar` or `MetricsAnimatedBar`.|
|Build result metric graph|`BuildResultsMetricGraph`|metrics widget|Create a new widget that displays the date range of builds, missing bars, and `BuildResultBarGraph`.|
|Build result bar graph|`BuildResultBarGraph`|metrics widget|Change bars displaying to handle in-progress builds with unstable duration. Animate bars if the list of results contains in-progress builds.|
|Animated bar|`MetricsAnimatedBar`|common metrics widget|Create a new widget that displays the given Lottie animation clipping it to the given height.|

The most important fact is that the in-progress build should be displayed as an animated bar. This results in changes with creating an additional widget that would apply the build result popup with appropriate graph indicator and padding to the bar itself. This additional widget is `BuildResultBarComponent` meaning that this is not the bar itself - it's a component that displays the bar. The bar, in its turn, requires changes to select which of low-level bar implementations to show: `MetricsColoredBar` for finished builds or `MetricsAnimatedBar` for in-progress builds.

The build result bar graph also requires changes with moving part of its logic to the top widget. This simplifies the widget structure and improves testing as the bar graph itself becomes more complex. Thus, the displaying logic with missing bars and builds date range should be a part of `BuildResultsMetricGraph`. And the `BuildResultBarGraph` should be responsible for displaying a graph itself without missing bars. The bar graph also should be changed to support rebuilding bars if the list of build results contains in-progress builds. For this purpose, we should create a `BuildResultDurationStrategy` that would detect the build result type and return the build's duration. Using this strategy, the `BuildResultBarGraph` can provide data to display to the low-level `BarGraph`. Also, when detecting in-progress builds, the `BuildResultBarGraph` should subscribe to the `TimerNotifier` updates and rebuild the graph. This provides a smooth animation for in-progress builds.

About other style changes consider the [Appearance Changes Notes](#appearance-changes-notes) section.

The following class diagram demonstrates the structure of widgets:

![Presentation Layer Widgets Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/in_progress_builds/diagrams/presentation_layer_widgets_class_diagram.puml)

##### Strategies

Some of the strategies that use the `BuildStatus` also require changes according to the new `BuildStatus.inProgress` value. Most of these changes are related to selecting an image asset to display. But some of them select the proper style from the theme to use for a widget appearance.

Image strategies (which selects an image asset to display) require adding new assets specific to the in-progress builds. These assets are to be exported from Figma and then used within `BuildResultPopupImageStrategy` and `ProjectBuildStatusImageStrategy`. For example, in `BuildResultPopupImageStrategy`:
```dart
  @override
  String getImageAsset(BuildStatus value) {
    switch (value) {
      case BuildStatus.successful:
        return "icons/successful.svg";
      case BuildStatus.failed:
        return "icons/failed.svg";
      case BuildStatus.unknown:
        return "icons/unknown.svg";
      case BuildStatus.inProgress:
        return "icons/in_progress.svg";
    }

    return null;
  }
```

The `BuildResultBarAppearanceStrategy` selects the proper `MetricsColoredBarStyle` from the `MetricsColoredBarAttentionLevel` depending on the `BuildStatus` value. This strategy is passed to the `MetricsColoredBar` widget where is used to provide appearance configurations (i.e. style). As the `MetricsColoredBar` isn't used to display in-progress builds, the `BuildResultBarAppearanceStrategy` shouldn't support in-progress status and thus we keep it unchanged.

Also, we should introduce a new `BuildResultDurationStrategy` that returns a build's duration depending on the view model type representing this build. More precisely, if the view model is `FinishedBuildResultViewModel` the strategy returns `FinishedBuildResultViewModel.duration` value as finished builds have fixed duration. For the `InProgressBuildResultViewModel`, the strategy returns the minimum between the given max build duration(to prevent displaying bars for in-progress builds significantly larger than bars for finished builds) and the difference of current timestamp and the build start timestamp: 
```dart
  final dateTimeNow = DateTime.now();
  final buildDuration = dateTimeNow.difference(viewModel.startedAt);

  return min(buildDuration, maxBuildDuration);
```

About other style changes consider the [Appearance Changes Notes](#appearance-changes-notes) section.

The following class diagram represents the structure of strategies classes:

![Presentation Layer Widgets Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/in_progress_builds/diagrams/presentation_layer_strategies_class_diagram.puml)

##### Appearance Changes Notes

The in-progress builds introduction affects a lot of `dashboard` module components. However, some of them don't require changes even if such elements evidently should be changed. The reason is that in some cases the `in-progress` status of the build is interpreted in the same way as the `unknown` status. This makes sense as the `in-progress` status is temporary and is to be changed when a build is finished.

According to the above, some widgets should have the same appearance as for `unknown` status when working with in-progress builds. And some strategies should act the same as with `unknown` status.

Consider the class diagram from the [Widgets](#widgets) section. You may notice that the `GraphIndicator` has three implementers for each of three possible attention levels: positive, negative, and neutral. The neutral level represents the graph indicator for bars with neutral visual feedback - just as the `unknown` build results. The same appearance has the graph indicator for in-progress builds. Therefore, no new graph indicator appearance should be implemented.

You can notice the same behavior in the `ProjectBuildStatusStyle` strategy. The style of the project build status metric is the same for both `unknown` and `in-progress` builds, though the displayed image changes.

## Results
> What was the outcome of the project?

The design of the in-progress builds introduction into the Metrics Web Application.
