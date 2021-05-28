# Widget structure organization
> Summary of the proposed change.

Description of widget structure and organization in the Metrics Web Application.

# References
> Link to supporting documentation, GitHub tickets, etc.

- [Clean Architecture: A Craftsman's Guide to Software Structure and Design](https://www.amazon.com/Clean-Architecture-Craftsmans-Software-Structure/dp/0134494164)
- [View model naming convention](https://caliburnmicro.com/documentation/naming-conventions)

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

## View models for UI components
> Give the main pros & cons of using the `view model`.

The `view model` is the simple object implementing the humble object pattern and used to provide data from the presenter (ChangeNotifier) to the view (Widgets). The view model should consists of simple Dart types (`string`s, `integer`s, `enum`s, etc.) or other `view model`s.

All the `view model` classes should be placed under the `module_name/presentation/view_models` folder. There should not be any common `view model`s since they should be module-specific.

<details>
  <summary>Pros & cons using the view model</summary>

    Pros: 
    - It helps to divide the UI from the business logic.
    - Improves testability and reduces the number of complex widget tests.
    - Reduces entities using in the presentation layer and thus reduces the connectedness between presentation and domain layers.

    Cons: 
    - Increases the amount of boilerplate code and code duplication in some cases.

</details>

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

So, to make the `view model`s in the Metrics Web Application well-structured and more scalable, we decided to use the combined approach. A Combined approach means that the main idea of using the `view model` is to create a [plain view model](#Plain-view-model) for metrics widgets that consists of base widgets or `Flutter` provided widgets and use the [Composite view model](#Composite-view-model) for widgets that consist of other metrics widgets.

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

Assume we have a `ProjectTileViewModel` from the [previous section](#Composite-view-model) and we have a `ProjectTile` widget that consists of the `PerformanceGraph`, `BuildNumberMetric`, `Coverage`, and `Stability` widgets that are `metrics` widgets: 

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

So, the `ProjectTileViewModel` is a composite view model that contains other view models for `metrics` widgets (see code sample in the [composite view model](#Composite-view-model) section). 

Let us take a more detailed look on one of `metrics` widgets, used in `ProjectTile`. For example, `Coverage` widget: 

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

The `Coverage` is a `metrics` widget, as a `ProjectTile`, but it consists of the `base` widget `CirclePercentage` that accepts only `double` percent value and some other params like colors, styles, etc. So, the `view model` for this widget will be `plain`, because there is no need to use any other `view model`s in it (see [Composite view model](#Composite-view-model) section for concrete examples).

Let us consider the class diagram that will explain relationships between `widget`s and `view model`s on `ProjectTile` widget example:

![View model usage class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/master/metrics/web/docs/diagrams/view_model_usage_class_diagram.puml)

On this diagram, we can see that all widgets that use the other `metrics` widgets (widgets from `dashboard/presentation/widgets` package) use a composite view model. The rest of the `metrics` widgets use a plain view model.

### Immutability

`View model`s must be immutable, which means all fields must be `final`. To make a class immutable, except `final` keywords, you must:

- Add an `@immutable` annotation or extend an `Equatable` class, that is already `@immutable`.

    ```dart
    import 'package:meta/meta.dart';

    @immutable
    class BuildNumberScorecardViewModel {
      final int numberOfBuilds;

      const BuildNumberScorecardViewModel({
        this.numberOfBuilds,
      });
    }
    ```

    ```dart
    import 'package:equatable/equatable.dart';

    class PercentViewModel extends Equatable {
      final double value;

      @override
      List<Object> get props => [value];

      const PercentViewModel(this.value);
    }
    ```

- Use `immutable` collections from package [collection](https://pub.dev/packages/collection) to make sure that the `view model` won't change somewhere.

    For example, if you have a `List` field, you must use an `UnmodifiableListView`, to make it `immutable`.

    ```dart
    import 'package:collection/collection.dart';
    import 'package:equatable/equatable.dart';

    class ProjectGroupDialogViewModel extends Equatable {
      final UnmodifiableListView<String> selectedProjectIds;

      const ProjectGroupDialogViewModel({
        this.selectedProjectIds,
      });
    }
    ```

### The naming convention for `view model`s.

`View model`s help the view to receive the required data to display, but these models themselves should state the view they are used in. Thus, one who looks at the `view model` should say "Oh, I know exactly where to use this". On the other hand, one who looks at the widget name should understand exactly what the `view model` is used for this widget without reading additional code documentation and examining the implementation. 

The above points lead us to the naming convention for the `view model`s that makes the code more clear and readable and simplifies the navigation (for more details, consider the article in the [**View model naming convention**](https://caliburnmicro.com/documentation/naming-conventions)). To name the `view model` class we should use the following rule: 

> `Entity Name` + `Widget Name` + `ViewModel`

 - The `Entity Name` is the name of an `entity`, which data the `view model` provides. 
 - The `Widget Name` is a short name of the `widget` that uses the `view model`. The _short name_ means the kind of UI element - say, `Card`, `Tile`, `Popup`, etc. 
 - The `ViewModel` is a suffix that marks the model as a `view model`.

Let's consider an example. Let there is an entity named `Project` with the project's data. This data should be displayed on the tile widget named `ProjectTile`. Hence, using the defined rule the `view model` for the `ProjectTile` widget is the following: 

> `Project` + `Tile` + `ViewModel` = `ProjectTileViewModel`

## Widget creation guidelines
> Explain and diagram an algorithm for creating a new `widget`.

As mentioned in the [Presentation Layer Architecture document](02_presentation_layer_architecture.md), all widgets can be one of the two following types:

1. `Base widget` is the widget that is responsible for only displaying the given data. These widgets should be highly-configurable and usable out of the Metrics Web Application context. The `base` widgets should be placed under the `base/presentation` package.
 
2. `Metrics widget` is the widget that is actually used in the Metrics Web Application context. It accepts the `view model` instance with data to display and displays the given data using `base widgets` and other `metrics widgets`. There are 2 types of the `metrics` widgets: 
  - Common `metrics` widgets - the `metrics` widgets that can be used across the modules and should be placed in `common/presentation` package.
  - Module-specific `metrics` widgets - the `metrics` widgets used only in one module. Should be placed under the `module_name/presentation` package.

To make widget creation process clear we should describe it in details for all the widget types.

### Base widget creation

To create a new base widget we should follow the next steps:

1. Implement the base widget considering that this widget must satisfy the following criteria:  
    - It should be highly configurable meaning that all the colors and styles can be configured from outside of this widget regardless of the default parameters used.
    - It should accept only Dart native data types like `string`s, `int`s, `bool`s, `Point`s, etc.
    - It should not apply any theme provided with the Metrics Web Application context.
2. Place the new widget in the `base/presentation/` folder, so it can be used by any module of the Metrics Web Application. If there are a couple of similar common widgets, we can place them into a separate folder. For example, a `base/presentation/dialog` folder will contain all the common dialogs. If the `base` widget has no similar widgets and cannot be united with any other widgets into some group, we are placing these widgets into `base/presentation/widgets` folder.

Generally speaking, the `base` widget should be implemented in the way it can be used outside of the Metrics Web Application. This allows creating high-reusable widgets not only within the Metrics Web Application scope but anywhere.

Notice, that the `base` widgets can contain only the logic that is closely related to the presentation-specific logic. It means that, for example, the `base` bar graph widget can contain the logic of displaying the points as a bar graph, but it should not contain any logic related to choosing how many bars it has to display.

![Create Base Widget Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/master/metrics/web/docs/diagrams/create_base_widget_activity_diagram.puml)

### Metrics widget creation

To create a new metrics widget, we should follow the next steps: 

1. If we have to use any base widgets, we should check if there any already existing base widgets that could be used, otherwise we need to try to separate the common (base) part of this widget and create it, using the instructions in [Base widget creation](#Base-widget-creation) section.

2. Create a view model for a new widget. If the widget uses other metrics widgets, we should create a [Composite view model](#Composite-view-model), otherwise, we should create a [Plain view model](#Plain-view-model). If we are creating the common widget, we should place the view model under the `common/presentation/view_models`. Otherwise, we should place the view model under the `module_name/presentation/view_models`.

3. Implement your widget using the view model from the previous step and base widgets from the first step, if any. If your new widget is a common `metrics` widget - place it under the `common/presentation/widgets` folder (or any specific folder like `common/presentation/graphs`), otherwise place it under the `module_name/presentation/widgets` directory.

4. Once you've created a widget itself, it's time to add some paints. To be able to change the application colors from one place, we've created the metrics theme - the single place you can configure the colors and appearance of the application. About theme approach and related guidelines see the [Metrics Theme guidelines](#Metrics-Theme-guidelines) section.

5. If the widget contains any constant strings like titles, descriptions, error messages, and so on, consider extracting them to a specialized class under the `module_name/presentation/strings` folder, where `module_name` could be the `common` if the widget is a common one.

Notice, that the `metrics` widgets can contain the presentation-specific logic that belongs to the concrete implementation of the widget. For example, the `metrics` bar graph widget can decide how to display the concrete bar depending on the data it represents. However, the `metrics` bar graph cannot choose how many bars to display. Moreover, the `metrics` widget can control its appearance depending on the data given. Let's consider the situation when the `metrics` bar graph widget obtains the number of points that is less than the given number of points to display. Then the `metrics` bar graph widget can populate the lacking points with placeholder bars and display them.

The following diagram describes the process of creation of the metrics widget:

![Create Metrics Widget Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/master/metrics/web/docs/diagrams/create_metrics_widget_activity_diagram.puml)

### Implementation guidelines

The next question we should answer is: _"Should we create a separate widget for each UI component?"_.

For example, we have one `base` widget that displays the circular percentage chart, and we have two metrics that should be displayed with this chart. The question is - should we create a separate widget for each of these metrics or we can create a common widget for them. 

So, it seems to be better to create a separate widget for each view even if these widgets look identical currently. It will allow us to simply change one of them later and increase maintainability.


<details>
  <summary>Pros & cons of described approaches</summary>

## Pros & cons of creating a separate widget for each metric

Pros: 
- SRP: one widget for one view.
- It makes the namings a bit more intuitive.
- Reduces the number of changes to make one widget look different.

Cons: 
- Increases code duplication in implementation and tests.

## Pros & cons of creating a common widget

Pros: 
- Keeps your code DRY.
- It does not violate the single responsibility principle.
- Reduces the amount of code and thus reduces the number of possible bugs, errors, etc.

Cons: 
- Makes your code less maintainable.
- Increases the number of changes to make one widget look different.

</details>

## Metrics Theme guidelines

### Metrics Theme structure
> Explain and diagram the metrics theme structure.

The Metrics Web Application uses themes to make visual elements style reusable and consistent. A theme is a set of colors, fonts logically structured to allow configuring how the UI in general or its parts look like. It provides an ability to swap themes (e.g. dark and light themes).

The main idea of the Metrics Theme inspired by Flutter default MaterialTheme that provides the `InheritedWidget` with the theme data to widgets. So, we have a `MetricsThemeData` class that contains the theme data for all the Metric widgets. Also, we have a `MetricsTheme` widget - the `InheritedWidget` that provides the `MetricsThemeData` to descendant widgets. To simplify the mechanism of changing the theme, there is the `MetricsThemeBuilder` widget that holds the light and dark themes and builds the MetricsTheme widget depending on the current theme state.

See the diagram below for a more detailed description of metrics theme organization: 

![Metrics Theme Structure Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/master/metrics/web/docs/diagrams/metrics_theme_structure_diagram.puml)

Let's consider the class diagram that represents structure of `MetricsThemeData` and the relationships between classes in the theme data and widgets: 

![Metrics Theme Structure Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/master/metrics/web/docs/diagrams/theme_data_class_diagram.puml)

#### How to get the Metrics Theme

Approach to applying the themes in the Metrics Web Application is to create separate theme data or a separate field in `MetricsThemeData` class with `MetricWidgetThemeData` type for each metrics widget. The base widgets should not apply any theme as they shouldn't be dependent on the Metrics Web Application context. If the base widget requires any default colors, we should set them in the constructor default params or create constants.

### Applying a Theme to a widget appearance
> Explain the algorithm of applying the metrics theme to the widgets.

The main concept of applying the themes in the Metrics Web Application is to create a separate theme data or a separate field in `MetricsThemeData` class with `MetricWidgetThemeData` type for each metrics widget. The base widgets should not apply any theme as they shouldn't be dependent of Metrics Web Application context. If the base widget requires any default colors, we should set them in the constructor default params or create some constants.

So, the base widget should have the color params in the constructor, and the metrics widget that uses this base widget should apply the appropriate theme to it.

If widgets require the custom theme (different from `MetricWidgetThemeData`, or any existing ones), we should create a new theme data (see [Adding a new Theme](#Adding-a-new-Theme)), specific for this widget. All the theme data classes should be stored in a `common/presentation/metrics_theme/model` folder. Let's consider the activity diagram that will explain the process of applying a theme data to a widget: 

![Apply Widget Theme Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/master/metrics/web/docs/diagrams/apply_widget_theme_diagram.puml)

### Adding a new Theme
> Explain the algorithm of adding new theme components for new widgets.

Before adding a new theme, you should keep in mind that there are several themes providing a common configuration of the application appearance. The `textTheme` and `metricsWidgetTheme` fields of the `MetricThemeData` provide all the common text styles and colors, respectively. So if the widget you've created can be styled using those common styles **do not** create a new theme. Consider creating a new theme data only if your widget appearance can't be styled with just common styles, but even in this case, try to use common styles to initialize parts of your custom theme data.

To add a new theme to the `MetricsThemeData` you should follow the next steps: 
1. Create a new class in `common/presentation/metrics_theme/model` folder that will represent a new theme data.
2. Add the `newTheme` field to the `MetricThemeData` class to be able to obtain it. 
3. Modify the `copyWith` method of the `MetricsThemeData` class and make it accept the created theme data. 
4. Configure the light and dark variants theme data for a new theme in corresponding classes.

That's all! Now you can use your new theme data in widgets, calling the `MetricsTheme.of(context).newTheme` method.

![Add Theme Data Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/master/metrics/web/docs/diagrams/add_theme_data_diagram.puml)

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
