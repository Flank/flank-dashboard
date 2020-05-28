# Widget structure organization
> Summary of the proposed change.

Description of widget structure and organization in the Metrics Web Application.

# References
> Link to supporting documentation, GitHub tickets, etc.

- [Clean Architecture: A Craftsman's Guide to Software Structure and Design](https://www.amazon.com/Clean-Architecture-Craftsmans-Software-Structure/dp/0134494164)

# Motivation
> What problem is this project solving?

To make the Metrics Web Application clear, understandable, and to lower the entry threshold, we need to create a document that will describe the main principles of creating widgets and the dependencies between them.

# Goals
> Identify success metrics and measurable goals.

- Describe the pros and cons of the view model.
- Chose an approach of using the view model.
- Describe the algorithm of adding/modifying widgets.
- Describe the structure and ways to use the metrics theme.

# Non-Goals
> Identify what's not in scope.

- The description of the approaches in testing widgets is out of scope.

# Design
> Explain and diagram the technical design.

## View models for UI components: pros & cons.
> Give the main pros & cons of using the `view model`.

The `view model` is the simple object implementing the humble object pattern and used to provide data from the presenter (ChangeNotifier) to the view (Widgets).

All the `view model` classes should be placed under the `module_name/presentation/view_model` folder. There should not be any common `view model`s since they should be module-specific.

Pros: 
- It helps to divide the UI from the business logic.
- Improves testability and reduces the number of complex widget tests.
- Reduces entities using in the presentation layer and thus reduces the connectedness between presentation and domain layers.

Cons: 
- Increases the amount of boilerplate code and code duplication in some cases.

> Explain and compare two main approaches in using the `view model`.

There are two main approaches in using the view model:

### Plain view model
The main idea of using plain view models is to have a single view model consisting of simple data to be displayed. For example, we have a screen with project tiles that contain the project's metrics, its name, and the last build status each. Using this approach, we should create a view model class that will contain simple data (strings, lists, etc.) for displaying the whole project tile. For instance:

```dart
enum BuildStatus { success, failure }

class ProjectTileViewModel {
  final String projectName;
  final BuildStatus lastBuildStatus;
  final List<Point> performanceMetric;
  final int buildNumberMetric;
  final double coverage;
  final double stability;

  ProjectTileViewModel({
    this.projectName,
    this.lastBuildStatus,
    this.performanceMetric,
    this.buildNumberMetric,
    this.coverage,
    this.stability,
  });
}
```

### Composite view model
This approach means creating almost the same view models as in the previous approach, but in this case, it will consist of low-level view models for each part of the UI. For example, the project tile view model will contain the coverage view model, stability view model, and so on...

```dart
enum BuildStatus { success, failure }

class ProjectTileViewModel {
  final String projectName;
  final BuildStatus lastBuildStatus;
  final PerformanceViewModel performance;
  final BuildNumberViewModel buildNumber;
  final CoverageViewModel coverage;
  final StabilityViewModel stability;

  ProjectTileViewModel({
    this.projectName,
    this.lastBuildStatus,
    this.performance,
    this.buildNumber,
    this.coverage,
    this.stability,
  });
}

class PerformanceViewModel {
  final List<Point> points;

  PerformanceViewModel(this.points);
}

class BuildNumberViewModel {
  final int numberOfBuilds;

  BuildNumberViewModel(this.numberOfBuilds);
}

class PercentMetricViewModel {
  final double value;

  PercentMetricViewModel(this.value);
}

class CoverageViewModel extends PercentMetricViewModel {
  CoverageViewModel(double value) : super(value);
}

class StabilityViewModel extends PercentMetricViewModel {
  StabilityViewModel(double value) : super(value);
}
```

So, to make the `view model`s in the Metrics Web Application well-structured and more scalable, we decided to use the combined approach. A Combined approach means that the main idea of using the `view model` is to create a [plain view model](#Plain-view-model) for high-level widgets that consists of low-level widgets or `Flutter` provided widgets and use the [Composite view model](#Composite-view-model) for widgets that consist of other high-level widgets.

<details>
  <summary>Pros & cons of described approaches</summary>
  
  ### Pros & const of the plain view model

  Pros: 
  - We have a single object that represents some logical part of the UI and could be easily found in the code.
  - We do not have complex data structures for view models.

  Cons: 
  - The view model using this approach could become messy and hard-readable.
  - Using this approach reduces the scalability and maintainability because to make the widget present some new information we should do a lot of steps like:
      - Add a new data field into a view model.
      - Make the widget accept the new data.
      - Pass the new data to the widget from outside.
      - Change the widget to display new data.

  ### Pros & const of the composite view model

  Pros:
  - Well-structured view model.
  - This approach is highly-scalable because there are just a couple of actions you should perform to add some new information to display: 
      - Add a new data field into the widget view model.
      - Change the widget to display new data.

  Cons:
  - It provides a pretty complex data structure that could be a bit harder to understand. 

</details>


Let's consider the concrete example of using the `plain view model` and the `composite view model`: 

Assume we have a `ProjectTileViewModel` from the [previous section](#Composite-view-model) and we have a `ProjectTile` widget that consists of the `PerformanceGraph`, `BuildNumberMetric`, `Coverage`, and `Stability` widgets that are `high-level` widgets: 

```dart
class ProjectTile extends StatelessWidget {
  final ProjectTileViewModel projectTileModel;

  const ProjectTile({Key key, this.projectTileModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Coverage(
          coverage: projectTileModel.coverage,
        ),
        Stability(
          stability: projectTileModel.stability,
        ),
        PerformanceGraph(
          performance: projectTileModel.performance,
        ),
        BuildNumberMetric(
          buildNumber: projectTileModel.buildNumber,
        ),
      ],
    );
  }
}
```

So, the `ProjectTileViewModel` is a composite view model that contains other view models for `high-level` widgets (see code sample in the [composite view model](#Composite-view-model) section). 

Let us take a more detailed look on one of `high-level` widgets, used in `ProjectTile`. For example, `Coverage` widget: 

```dart
class Coverage extends StatelessWidget {
  final CoverageViewModel coverage;

  const Coverage({Key key, this.coverage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CirclePercentage(
      percent: coverage.value,
      ...
    );
  }
}
```

The `Coverage` is a `high-level` widget, as a `ProjectTile`, but it consists of the `low-level` widget `CirclePercentage` that accepts only `double` percent value and some other params like colors, styles, etc. So, the `view model` for this widget will be `plain`, because there is no need to use any other `view model`s in it (see [Composite view model](#Composite-view-model) section for concrete examples).

Let us consider the class diagram that will explain relationships between `widget`s and `view model`s on `ProjectTile` widget example:

![View model usage class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/software-platform/monorepo/widget_stucture_organization_document/metrics/web/docs/diagrams/view_model_usage_class_diagram.puml)

On this diagram we can see that all widgets that uses the other `high-level` widgets (widgets from `dashboard/presentation/widgets` package) uses the composite view model. Other widgets uses the plain view model.

## Widget creation guidelines
> Explain and diagram an algorithm for creating a new `widget`.

As mentioned in the [Presentation Layer Architecture document](02_presentation_layer_architecture), all widgets can be one of two following types:

1. `Low-level widget` is the widgets that is responsible for only displaying the given data. This widgets should be highly-configurable and out of the Metrics Web Application context. It means that the `low-level` widgets should not apply any themes or use any `view model`s. The low-level widgets should be placed under the `common/presentation` folder. If there are more than one similar widgets then it is better to create a separate folder for them (like already existing `metrics_theme` folder), otherwise we can place a new low-level widget to the `widgets` folder. 
 
2. `High-level widget` is the widget that actually used in the Metrics Web Application context. It accepts the `view model` instance with data to display and displays the given data using `low-level widgets` and other `high-level widgets`. Also, the high-level widgets should apply the themes to used low-level widgets.

To make widget creation process clear we should describe it in details for all the widget types.

### Low-level widget creation

To create a new low-level widget we should follow the next steps:

1. Implement the low-level widget considering that this widget must satisfy the following criteria:  
    - It should be highly configurable meaning that all the colors and styles can be configured from outside of this widget regardless of the default parameters used.
    - It should accept only Dart native data types like `string`s, `int`s, `bool`s, `Point`s, etc.
    - It should not apply any theme provided with the Metrics Web Application context.
2. Place the new widget in the `common/presentation/widgets/` folder, so it can be used by any module of the Metrics Web Application.

Generally speaking, the low-level widget should be implemented in the way it can be used outside of the Metrics Web Application. This allows creating high-reusable widgets not only within the Metrics Web Application scope but anywhere.

![Create Low-Level Widget Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/software-platform/monorepo/widget_stucture_organization_document/metrics/web/docs/diagrams/create_low_level_widget_activity_diagram.puml)

### High-level widget creation

To create a new high-level widget, we should follow the next steps: 

1. Create a view model for a new widget. If the widget uses other high-level widgets, we should create a [Composite view model](#Composite-view-model), otherwise, we should create a [Plain view model](#Plain-view-model).

2. If we have to use any low-level widgets, we should check if there any already existing low-level widgets that could be used, otherwise we need to try to separate the common (low-level) part of this widget and create it, using the instructions in [Low-level widget creation](#Low-level-widget-creation) section.

3. Implement your widget using the view model from the previous step and low-level widgets from the first step, if any.

4. Once you've created a widget itself, its time to add some paints. To be able to change the application colors from one place, we've created the metrics theme - the single place you can configure the colors and appearance of the application. So, you should decide if there any need to create a new theme data or the `MetricWidgetThemeData` could be used. Then you should add a theme data to the `MetricsThemeData` to be able to access this theme in your widgets later, using the `MetricsTheme.of(context)` method.

5. If widget contains any constant strings like titles, descriptions, error messages, and so on, consider extracting them to a separate class in the `strings` folder.

The following diagram describes the process of creation of the high-level widget:

![Create High-Level Widget Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/software-platform/monorepo/widget_stucture_organization_document/metrics/web/docs/diagrams/create_high_level_widget_activity_diagram.puml)

The next question we should answer is: "Should we create a separate widget for each UI component?".
For example, we have one low-level widget that displays the circular percentage chart, and we have two metrics that should be displayed with this chart. The question is - should we create a separate widget for each of these metrics.

Let's consider the pros & cons of creating a separate widget for each metric: 

Pros: 
- SRP: one widget for one view.
- It makes the namings a bit more intuitive.
- Reduces the number of changes to make one widget looks different.

Cons: 
- Increases code duplication in implementation and tests.
- Increases the amount of code.

Another way is to create a single configurable high-level widget for displaying these metrics. Let's consider the pros & cons of this approach:

Pros: 
- Keeps your code DRY.
- It does not violate the single responsibility principle.
- Reduces the amount of code and thus reduces the number of possible bugs, errors, etc.

Cons: 
- Makes your code less maintainable.
- Increases amount of changes to make one widget looks different.

So, it seems to be better to create a separate widget for each view even if these widgets look identical currently. It will allow us to simply change one of them later and increase maintainability.

## Metrics Theme guidelines

### Metrics Theme structure [Pending Approval]
> Explain and diagram the metrics theme structure.

In order to support the application's appearance in a clear and maintainable way, the Metrics Web Application uses themes. The theme is a configuration for the appearance (colors, text style, etc.) of a part of UI. Themes allow configuring how the UI or its part looks like and introduces the great support to change this appearance reactively (e.g. dark and light themes).

Our main concept of the theme is that we have a `MetricsThemeData` class that contains all the theme data for widgets. We can obtain the `MetricsThemeData` using the `MetricsTheme.of(context)` method. The `MetricsThemeData` consists of classes that implement the  `AttentionLevelThemeData` interface. This interface provides an `attentionLevel` field that provides the different variations of styles, applicable for separate group of widgets. Let's consider the class diagram that represents structure of `MetricsThemeData` and the relationships between classes in the theme data and widgets: 

![Metrics Theme Structure Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/software-platform/monorepo/widget_stucture_organization_document/metrics/web/docs/diagrams/theme_data_class_diagram.puml)

The main idea of the Metrics Theme inspired by Flutter default MaterialTheme that provides the `InheritedWidget` with the theme data to widgets. So, we have a `MetricsThemeData` class that contains the theme data for all the Metric widgets. Also, we have a `MetricsTheme` widget - the `InheritedWidget` that provides the `MetricsThemeData` to descendant widgets. To simplify the mechanism of changing the theme (from light to dart), there is the `MetricsThemeBuilder` widget that holds the light and dark themes and builds the MetricsTheme widget depending on the current theme state.

See the diagram below for a more detailed description of metrics theme structure: 

![Metrics Theme Structure Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/software-platform/monorepo/widget_stucture_organization_document/metrics/web/docs/diagrams/metrics_theme_structure_diagram.puml)

### Applying a Theme to a widget appearance [Pending]
> Explain the algorithm of applying the metrics theme to the widgets.

The main concept of applying the themes in the Metrics Web Application is to create a separate theme data or a separate field in `MetricsThemeData` class with `MetricWidgetThemeData` type for each high-level widget. The low-level widgets should not apply any theme. If the low-level widget requires any default colors, we should set them in the constructor default params or create some constants, but not use the metrics theme to make the low-level widgets independent of the Metrics Web Application context.

So, the low-level widget should have the color params in the constructor, and the high-level widget that uses this low-level widget should apply the appropriate theme for it. This means that the appearance of the low-level widget is always controlled outside of it.

If widgets require the custom theme (different from `MetricWidgetThemeData`, or any existing ones), we should create a new theme data (see [Adding a new Theme](#Adding_a_new_Theme)), specific for this widget. All the theme data classes should be stored in a `common/presentation/metrics_theme/model` folder. Let's consider the activity diagram that will explain the process of applying a theme data to a widget: 

![Apply Widget Theme Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/software-platform/monorepo/widget_stucture_organization_document/metrics/web/docs/diagrams/apply_widget_theme_diagram.puml)

### Adding a new Theme [Pending]
> Explain the algorithm of adding new theme components for new widgets.

To add a new theme to the `MetricsThemeData` you should follow the next steps: 
1. Create a new class in `common/presentation/metrics_theme/model` folder that will represent a new theme data.
2. Add the `newThemeData` field to the `MetricThemeData` class to be able to obtain it. 
3. Modify the `copyWith` method of the `MetricsThemeData` class and make it accept the created theme data. 
4. Configure the light and dark variants theme data for a new theme in corresponding classes.

That's all! Now you can use your new theme data in widgets, calling the `MetricsTheme.of(context).newThemeData` method.

![Add Theme Data Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/software-platform/monorepo/widget_stucture_organization_document/metrics/web/docs/diagrams/add_theme_data_diagram.puml)

# Dependencies
> What is the project blocked on?

No blockers.

> What will be impacted by the project?

The implementation of widgets impacted.

# Alternatives Considered
> Summarize alternative designs (pros & cons)

- Not document the Metrics Web Application widget structure organization:
    - Cons: 
        - The module appears to be tricky for newcomers without any document describing it on a top-level.

# Results
> What was the outcome of the project?

The document in widgets structure organization describing view models and different approaches in creating them, processes of widgets and theme data creation, and their usage with the Metrics Web Application.
