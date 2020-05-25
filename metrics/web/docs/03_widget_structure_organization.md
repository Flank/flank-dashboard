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

- Described the pros and cons of the view model.
- The chosen approach of using the view model.
- Described algorithm of adding/modifying widgets.
- Described the structure and ways to use the metrics theme.

# Non-Goals
> Identify what's not in scope.

- The description of the approaches in testing widgets is out of scope.

# Design
> Explain and diagram the technical design.

## View models for UI components: pros & cons.
> Give the main pros & cons of using the `view model`.

The view model is the simple object implementing the humble object pattern and used to provide data from the presenter (ChangeNotifier) to the view (Widgets).

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

Let's consider the main pros and cons of this approach: 

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

### Composite view model
This approach means creating almost the same view models as in the previous approach, but in this case, it will consist of low-level view models for each part of the UI. For example, the project tile view model will contain the coverage view model, stability view model, and so on...

```dart
enum BuildStatus { success, failure }

class ProjectTileViewModel {
  final String projectName;
  final BuildStatus lastBuildStatus;
  final PerformanceViewModel performanceMetric;
  final BuildNumberViewModel buildNumberMetric;
  final PercentMetricViewModel coverage;
  final PercentMetricViewModel stability;

  ProjectTileViewModel1({
    this.projectName,
    this.lastBuildStatus,
    this.performanceMetric,
    this.buildNumberMetric,
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
```

Let's consider the pros & cons of this approach: 

Pros:
- Well-structured view model.
- This approach is highly-scalable because there are just a couple of actions you should perform to add some new information to display: 
    - Add a new data field into the widget view model.
    - Change the widget to display new data.

Cons:
- It provides a pretty complex data structure that could be a bit harder to understand. 


## Widget creation guidelines
> Explain and diagram an algorithm for creating a new `widget`.

There are a few main steps of adding a new widget to the Metrics Web Application.

1. First, you should answer the question: "Does a new widget contains any feature-specific child widgets?" In other words, does it's view model is supposed to use existing view models for existing widgets. Generally speaking, this step aims to classify a new widget view model - Plaint or Composite?
    - If no, then you should create a Plain view model containing all the data a new widget is required to display. Consider following an example in the section [Plain view model](#Plain-view-model).
    - If yes, then you should create a Composite view model that will use the existing view models for widgets a new widget is going to contain. Consider following an example in the section [Composite view model](#Composite-view-model).

2. Then you should check if there are any common widgets that can be used in a new widget.
    - If there are any, consider using them in your implementation to avoid code duplication.
    - If there are no existing common widgets you can use - try to separate a part of a new widget that could be used in another widget later. For example, you have to create a graph widget that will display the circle with the percent in it. Then you should create a simple widget that displays this circle with the text as the common widget and accept the basic dart types as an input (strings, integers, etc.). Try to avoid adding any specific logic to this widget. It should just display the given data but not apply any theme or calculate any data - it is the responsibility of a high-level widget.

3. Implement your widget using the view model from the first step and common widgets from the second step. Please note, that if the implemented widget uses low-level widgets then it should control their states if they are supported. Under `states`, the `active` \ `inactive` states are considered.

4. Once you've created a widget itself, its time to add some paints. To be able to change the application colors from one place, we've created the metrics theme - the single place you can configure the colors and appearance of the application. So, you should create an object that will be used to configure your widget's appearance. Then you should add this object to the `MetricsThemeData` to be able to access this theme in your widgets later, using the `MetricsTheme.of(context)` method.

5. If you've created any common widgets you should apply the `MetricsThemeData.defaultWidgetTheme` to it. It is required to keep all metric widgets in one style. Also, your widget should accept the color parameters that give an ability to control widget colors from outside, for example, from high-level widgets.

6. If widget contains any constant strings like titles, descriptions, error messages and so on, consider extracting them to a separate class in `strings` folder.

The following diagram describes the above process:

![Create Widget Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/software-platform/monorepo/widget_stucture_organization_document/metrics/web/docs/diagrams/create_widget_activity_diagram.puml)

The next question we should answer is: "Should we create a separate widget for each UI component?".
For example, we have one low-level widget that displays the circular percentage chart, and we have two metrics that should be displayed with this chart. The question is - should we create a separate widget for each of these metrics.

Let's consider the pros & cons of creating a separate widget for each metric: 

Pros: 
- SRP: one widget for one view.
- It makes the namings a bit more intuitive.
- Reduces the number of changes to make one widget looks different.

Cons: 
- Increases code duplication in realization and tests.
- Increases the amount of code.

Another way is to create a single configurable high-level widget for displaying these metrics. Let's consider the pros & cons of this approach:

Pros: 
- Keeps your code DRY.
- It does not violate the single responsibility principle.
- Reduces the amount of code and thus reduces the number of possible bugs, errors, etc.

Cons: 
- Makes your code less maintainable.
- Increases amount of changes to make one widget looks different.

Conclusion

## Metrics Theme guidelines

### Metrics Theme structure
> Explain and diagram the metrics theme structure.

In order to support the application's appearance in a clear and maintainable way, the Metrics Web Application uses themes. The theme is a configuration for the appearance (colors, text style, etc.) of a part of UI. Themes allow configuring how the UI or its part looks like and introduces the great support to change this appearance reactively (e.g. dark and light themes).

The main idea of the Metrics Theme is inspired by Flutter default MaterialTheme that provides the InheritedWidget with the theme data to widgets. So, we have a MetricsThemeData class that contains the theme data for all of the Metric widgets. Also, we have a MetricsTheme widget - the InheritedWidget that provides the MetricsThemeData to descendant widgets. To simplify the mechanism of changing the theme (from light to dart), there is the MetricsThemeBuilder widget that holds the light and dark themes and builds the MetricsTheme widget depending on the current theme state.

See the diagram below for a more detailed description of metrics theme structure: 

![Metrics Theme Structure Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/software-platform/monorepo/widget_stucture_organization_document/metrics/web/docs/diagrams/metrics_theme_structure_diagram.puml)

### Applying a Theme to a widget appearance
> Explain the algorithm of applying the metrics theme to the widgets.

Them main concept of applying the theme to the widgets is to apply the `defaultWidgetTheme` theme in the low-level widgets by default and give an ability to pass the colors to widget's constructor to change the colors of this widget. So, if we have some low-level widget that applies the `defaultWidgetTheme` and we have some high-level widget that uses the low-level widget and should apply another theme we are getting this theme in the high-level widget, using the `MetricsTheme.of(context)` method, and apply it to the low-level widget, using the constructor params. 

If a high-level widget requires the configurations of its appearance depends on the application theme (light or dark) then you should consider creating a theme for this widget. This means that if the widget has specific colors, text styles, or other theme-related components than these specific components should be moved to the theme data for this widget (see [Adding a new Theme](#Adding-a-new-Theme)). Otherwise, this widget should use the default metrics widgets theme. Moreover, if this widget supports `active` \ `inactive` states then it should use the default inactive metrics widgets theme for its `inactive` state. Hence, if the widget uses low-level widgets that support `active` \ `inactive` states then it should apply the default inactive metrics widgets theme to them as well.

As we've noticed above, the low-level widgets should apply the `MetricsThemeData.defaultWidgetTheme` by default. This means that the low-level widget should have the color params in the constructor, but if no colors passed, it should use the default metric theme (`defaultWidgetTheme`). Also, the low-level widgets, commonly, should not have any logic of applying the themes, for example, it should not decide if it is in an `active` or `inactive` state or something like this.

![Apply Widget Theme Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/software-platform/monorepo/widget_stucture_organization_document/metrics/web/docs/diagrams/apply_widget_theme_diagram.puml)

### Adding a new Theme
> Explain the algorithm of adding new theme components for new widgets.

To add a new theme to the `MetricsThemeData` you should follow the next steps: 
1. Create a new class that will represent a new theme data.
2. Add the `newThemeData` field to the `MetricThemeData` class to be able to obtain it. 
3. Modify the `copyWith` method of the `MetricsThemeData` class and make it accept the created theme data. 
4. Configure the light and dark variants theme data for a new theme in corresponding classes.

That's all! Now you can use your new theme data in widgets, calling the `MetricsTheme.of(context).newThemeData` method.

![Add Theme Data Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/software-platform/monorepo/widget_stucture_organization_document/metrics/web/docs/diagrams/add_theme_data_diagram.puml)

# Dependencies
> What is the project blocked on?

No blockers.

> What will be impacted by the project?

The implementation of widgets is impacted.

# Alternatives Considered
> Summarize alternative designs (pros & cons)

- Not document the Metrics Web Application widget structure organization:
    - Cons: 
        - The module appears to be tricky for newcomers without any document describing it on a top-level.

# Results
> What was the outcome of the project?

The document in widgets structure organization describing view models and different approaches in creating them, processes of widgets and theme data creation, and their usage with the Metrics Web Application.
