# Metrics Web presentation layer architecture
> Summary of the proposed change.

The detailed description of the Metrics Web Application's presentation layer.

# References
> Link to supporting documentation, GitHub tickets, etc.

- [Clean Architecture: A Craftsman's Guide to Software Structure and Design](https://www.amazon.com/Clean-Architecture-Craftsmans-Software-Structure/dp/0134494164)
- [Presentation model](https://martinfowler.com/eaaDev/PresentationModel.html)

# Motivation
> What problem is this project solving?

To make the Metrics Web Application clear, we have to create a document that will explain the main components of the presentation layer and the principles used in this layer.

# Goals
> Identify success metrics and measurable goals.

- Explain the architecture of the Metrics Web Application's presentation layer and it's components.
- Create the component diagram that explains the relationships between UI components of the Metrics Web Application.

# Non-Goals
> Identify what's not in scope.

- The document does not aim to describe processes and approaches in testing the Metrics Web Application. 
- The algorithm of adding a new module into the Metrics Web Application is out of scope.

# Design
> Explain and diagram the technical design.

## The main components of the presentation layer

### The main principles of the view model
> Explain what the `view model` is.

A `view model` is a class that implements the humble object pattern and used for data transfer from the presenter to the view. The view model should lay under the `module_name/presentation/view_model` package.

> Explain a difference between a `view model` and an `entity`.

Unlike an `entity`, which can contain the critical business rules and business data, a `view model` should store only the view-ready data displayed on the UI.

> Explain the main parts of the `view model`.

A `view model` can consist of Dart's native objects like `int`, `String`, `Point`, etc, and other `view model` classes. Only fields that used for storing some data are allowed - that means that `view model` classes cannot have any methods neither static nor public. Generally, the static fields are also should be avoided, but if they help to simplify code structure and reduce the boilerplate code - then the static fields are allowed. 

> Explain the main responsibilities of the `view model` and where to use it.

A `view model`'s main responsibility is to provide data to the view. It should be as simple as possible and contain only data that will be displayed. The `view model` should be constructed in the presenter of the presentation layer (`ChangeNotifier` in our case) and should not depend on any `entities`. 

For the more detailed overview in a `view-model`, take a look at the [Widget structure organization](03_widget_structure_organization.md) document. 

### What is the state and why do we need it
> Explain what the `state` of the module is.

A `state`, or a `presenter`, is the part of the presentation layer that is the intermediary between the `domain` and the `presentation` layer. The `state` classes lay under the `module_name/presentation/view_model` folder.

> Explain the main responsibilities of the `state`.

A `state` is responsible for holding the logic of the presentation layer - loading data, creating view models from entities, saving data to the persistent store. The `presenter` is needed to separate the logic from UI to make it more testable and structured.

### Widget creation

There are three main types of the UI components in the Metrics Web Application: 
1. `pages`
2. `high-level widgets`
3. `low-level widgets`

> Explain the difference between `page` and `widget`.

A `page` is a very high-level widget that stands for the web-page (or screen) and combines all the UI units. Neither the `high-level widgets` nor `low-level widgets` know where they are used and placed - this is what the `page` purpose in. Each `feature` should consist at least of one page, meaning that the feature is presented by several pages in the UI. 

> Explain the difference between `low-level` and `high-level` widgets.

1. Low-level widgets.

`Low-level widgets` are highly-reusable widgets that should only present the given data. The most common approach is using the `low-level widgets` to create `high-level widgets` that will properly configure them for different needs. See more details about high-level widgets in the [Widget Structure Organization](03_widget_structure_organization.md) document.

2. High-level widgets

`High-level widgets` are used to actually display the data for a user. Commonly, these widgets use `low-level widgets` as a building component to create the required view. Also, these widgets should accept the `view model`. See [Widget Structure Organization](03_widget_structure_organization.md) document to get more information about `high-level` widgets.

So, to sum up: 

1. Page - the widget that properly combines the high-level widgets. Represents the web page or screen of the application. These widgets lay under the `module_name/presentation/pages` folder.
2. High-level widgets - the widgets that may, or may not, consist of low-level widgets and properly configures them. It should accept the `view model` on input. Can obtain any other params like `ThemeStrategy` to make it more testable.
3. Low-level widgets - the configurable widgets that simply displays the data. They should accept the Dart's native types, like `int`, `String`, `Point`, `bool` (can accept types from any UI packages if necessary). They should be highly reusable. Low-level widgets should be placed under the `common/presentation` package.

> Explain the way of using the `strings` in the widgets and where to place them.

Once we have widgets, we probably have some constant texts in them like titles, descriptions, error messages, etc. To make these strings reusable in different parts of our application like tests or even `ci integrations module`, we should extract strings to the separate classes. Commonly, we have a single class with strings for a module, and it is placed under the `module_name/presentation/strings` folder. Another reason to extract the strings into the separate class is translations. To add translations to our application, we have to wrap each string into `Intl.message` method from the [intl](https://pub.dev/packages/intl) package. So, if strings from our application will be placed into one file per module, it will be easy to integrate the translations, by changing the static fields to static getters. 

> Explain the main principles of creating/editing widgets.

As all widgets we create are divided into `low-level` and `high-level`, then we should examine the process of creating these types separately. The below statements are the short description of the widgets creating process. See the [Widget structure organization document](03_widget_structure_organization.md) for more details about creating a new widget.

To create a `high-level` widget, we commonly should use the `low-level` widgets in the implementation and create a `view model` for this widget.

To create a `low-level` widget, we should implement the widget that will be highly-configurable and reusable in different parts of the application.

## Widget structure
> Create the class diagram explaining the structure of widgets.

Let's consider a class diagram explaining the structure of widgets in the Metrics Web Application: 

![Widget Structure Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/software-platform/monorepo/presentation_layer_structure_document/metrics/web/docs/diagrams/widget_structure_class_diagram.puml)

> Explain the package structure of the presentation layer.

The package structure is also an important part of the Metrics Web Application presentation layer. Every presentation unit has a similar package structure. Let's consider the example of the `cool_module`'s package structure.

> * cool_module/
>    * data/...
>    * domain/...
>    * presentation/
>       * view_model/
>       * state/
>       * pages/
>       * strings/
>       * widgets/
>           * strategy/

So, each module's presentation layer consists of the `view_model`, `state`, `pages`, `strings`, and `widgets` packages. The `widgets` package can be divided into several packages that will simplify the navigation if necessary. 

# Dependencies
> What is the project blocked on?

No blockers.

> What will be impacted by the project?

- The implementation of presentation layer components of the Metrics Web Application is impacted.
- Since a developer should consider creating low-level widgets and then use it for creating the desired module-specific one, hence the process of delivering a presentation layer component is impacted. 

# Testing
> How will the project be tested?

The presentation layer will be unit-tested and integration-tested using the core [flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html) package and the [flutter_driver](https://api.flutter.dev/flutter/flutter_driver/flutter_driver-library.html) package respectively.

# Alternatives Considered
> Summarize alternative designs (pros & cons)

- Not document the presentation layer of the Metrics Web Application:
    - Cons: 
        - As the application grows, the future development of new modules and maintaining the old ones may be tricky without any document describing the presentation layer.
        - As there is no explanation in differences between top-level and low-level widgets in the context of the Metrics Web Application, newcomers will be required to investigate this by themselves. This point makes the Metrics Web Application entry threshold quite hight.

# Results
> What was the outcome of the project?

The document in the presentation layer architecture describing all the parts this layer consists of.
