# Metrics Web presentation layer architecture
> Summary of the proposed change.

The detailed description of the Metrics Web Application's presentation layer.

# References
> Link to supporting documentation, GitHub tickets, etc.

- [Clean Architecture: A Craftsman's Guide to Software Structure and Design](https://www.amazon.com/Clean-Architecture-Craftsmans-Software-Structure/dp/0134494164)
- [Presentation model](https://martinfowler.com/eaaDev/PresentationModel.html)

# Motivation
> What problem is this project solving?

To make the Metrics Web Application structure well-defined, we need to create a document that will explain the main concepts, principles and modules of the presentation layer.

# Goals
> Identify success metrics and measurable goals.

- Explain the architecture of the Metrics Web Application's presentation layer and its components.
- Create the class diagram that explains the relationships between UI components of the Metrics Web Application.

# Non-Goals
> Identify what's not in scope.

- The document does not aim to describe processes and approaches in testing the Metrics Web Application. 
- The algorithm of adding a new module into the Metrics Web Application is out of scope.

# Design
> Explain and diagram the technical design.

## The main components of the presentation layer

### View model
> Explain what the `view model` is.

A `view model` is a class that implements the humble object pattern and used for data transfer from the presenter to the view. The view model should lay under the `module_name/presentation/view_model` package.

> Explain a difference between a `view model` and an `entity`.

Unlike an `entity`, which can contain the critical business rules and business data, a `view model` should store only the view-ready data displayed on the UI.

> Explain the main parts of the `view model`.

A `view model` can consist of Dart's native objects like `int`, `String`, `Point`, etc, and other `view model` classes. Only fields that used for storing some data are allowed - that means that `view model` classes cannot have any methods neither static nor public. Generally, the static fields are also should be avoided, but if they help to simplify code structure and reduce the boilerplate code - then the static fields are allowed. 

> Explain the main responsibilities of the `view model` and where to use it.

A `view model`'s main responsibility is to provide data to the view. It should be as simple as possible and contain only data that will be displayed. The `view model` should be constructed in the presenter of the presentation layer (`ChangeNotifier` in our case) and should not depend on any `entities`. 

For the more detailed overview in a `view-model`, take a look at the [Widget structure organization](03_widget_structure_organization.md) document. 

### State
> Explain what the `state` of the module is.

A `state`, or a `presenter`, is the part of the presentation layer that is the intermediary between the `domain` and the `presentation` layer. The `state` classes lay under the `module_name/presentation/state` folder. The `state` folder holds the state management mechanism for the current presentation layer.

> Explain the main responsibilities of the `state`.

A `state` is responsible for holding the logic of the presentation layer - loading data, creating view models from entities, saving data to the persistent store. The `presenter` separates the logic from UI to make both more testable and structured.

> Explain the principle of interactions between `state`s.

To expose the data from one `state` (ChangeNotifier) to other `state`s, we need to follow the next steps: 

1. Create a `model` for the data to be exposed.
2. Create a `ChangeNotifierProxyProvider` in the `InjectionContainer` widget that connects these notifiers.
3. Create a method in the consumer notifier that allows updating the data from outside.
4. Connect these notifiers using the `ChangeNotifierProxyProvider`, created in the second step.

### Model
> Explain what the `model` of the module is.

A `model` is a class that transfers the data across the presentation layer components. The most common use of the `model` is transferring the data between two different `state`s (`ChangeNotifier`s).

The main difference between a `model` and a `view model` is that the latter is used only by the widgets. This means that if one `state` should expose some data to use in another `state`(s), then this data must be represented by `model`.

The `model`s of the current module should be placed under the `module_name/presentation/models` package.

### UI elements

There are three main types of the UI components in the Metrics Web Application: 
1. `pages`
2. `base widgets`
3. `metrics widgets` 

> Explain the difference between `page` and `widget`.

1. Page

A `page` is the widget that properly combines the metrics widgets. Represents the web page or screen of the application. These widgets lay under the `module_name/presentation/pages` folder. Each module should consist of at least one `page`.

> Explain the difference between `base` and `metrics` widgets.

2. Base widgets.

`Base widgets` are highly-reusable widgets that should only present the given data. This type of widgets can contain only common presentation logic. For example, the logic of displaying the given points as a graph. `Base widgets` should not contain any project-specific functionality. The most common approach is using the `base widgets` to create `metrics widgets` that will properly configure them for different needs. 

3. Metrics widgets.

`Metrics widgets` are specific to the Metrics Web Application widgets that use `MetricsTheme` for coloring and `view model` as input. Should use `base widgets` as much as possible. Metrics widgets can obtain any other params like `ThemeStrategy` to make it more testable.

See [Widget structure organization](03_widget_structure_organization.md) document to get more information about `metrics` and `base` widgets.

### Strings

Once we have widgets, we probably have some constant texts in them like titles, descriptions, error messages, etc. To make these strings reusable in different parts of our application like tests or even `ci integrations module`, we should extract strings to the separate classes. Commonly, we have a single class with strings for a module, and it is placed under the `module_name/presentation/strings` folder. Another reason to extract the strings into the separate class is translations. To add translations to our application, we have to wrap each string into `Intl.message` method from the [intl](https://pub.dev/packages/intl) package. So, if strings from our application will be placed into one file per module, it will be easier to integrate the translations, by changing the static fields to static getters. 

## Presentation module structure
> Create the class diagram explaining the structure of widgets.

Let's consider a class diagram explaining the structure of widgets in the Metrics Web Application: 

![Widget Structure Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/master/metrics/web/docs/diagrams/widget_structure_class_diagram.puml)

> Explain the package structure of the presentation layer.

The package structure is also an important part of the Metrics Web Application presentation layer. Every presentation unit has a similar package structure. Let's consider the example of the `cool_module`'s package structure.

> * cool_module/
>    * data/...
>    * domain/...
>    * presentation/
>       * models/
>       * view_models/
>       * state/
>       * pages/
>       * strings/
>       * widgets/
>           * strategy/

So, each module's presentation layer consists of the `view_models`, `state`, `pages`, `strings`, and `widgets` packages. The `widgets` package can be divided into several packages that will simplify the navigation if necessary. Also, there could be a `models` package that will contain all the `model`s used in this module.

# Dependencies
> What is the project blocked on?

No blockers.

> What will be impacted by the project?

- The implementation of presentation layer components of the Metrics Web Application is impacted.

# Testing
> How will the project be tested?

The presentation layer will be unit-tested and integration-tested using the core [flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html) package and the [flutter_driver](https://api.flutter.dev/flutter/flutter_driver/flutter_driver-library.html) package respectively.

# Alternatives Considered
> Summarize alternative designs (pros & cons)

- Not document the presentation layer of the Metrics Web Application:
    - Cons: 
        - As the application grows, the future development of new modules and maintaining the old ones may be tricky without any document describing the presentation layer.
        - With no written explanation in differences between metrics and base widgets in the context of the Metrics Web Application, it will be longer for the new team members to become productive.

# Results
> What was the outcome of the project?

The document describing the structure of the presentation layer.
