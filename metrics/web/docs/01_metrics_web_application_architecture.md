# Metrics Web Application architecture
> Summary of the proposed change.

An explanation of the Metrics Web Application architecture.

# References
> Link to supporting documentation, GitHub tickets, etc.

- [Clean Architecture: A Craftsman's Guide to Software Structure and Design](https://www.amazon.com/Clean-Architecture-Craftsmans-Software-Structure/dp/0134494164)
- [Screaming architecture](https://blog.cleancoder.com/uncle-bob/2011/09/30/Screaming-Architecture.html)

# Motivation
> What problem is this project solving?

To make the Metrics Web Application architecture clean and understandable, we need to create a document that will explain the main principles and components of the Metrics Web Application.

# Goals
> Identify success metrics and measurable goals.

- Explain common principles of the Clean Architecture.
- Explain the components and modules of the Metrics Web Application.

# Non-Goals
> Identify what's not in scope.

- The document does not explain the Clean Architecture in detail.
- The document does not describe the details of the presentation layer and its components. 

# Design
> Explain and diagram the technical design.

## Clean architecture fundamentals
> Explain the basic principles of the [Screaming architecture](https://blog.cleancoder.com/uncle-bob/2011/09/30/Screaming-Architecture.html).

The `screaming architecture` supposes that the root directory of the project should describe all the main features/modules of the project. For example, our Metrics Web Application top-level package structure contains the `auth`, `dashboard`, `project_groups` packages, so the top-level structure states (or _screams_) about the project purpose - dashboard for project metrics.

> Explain what the application layers are and why do we need them.

The next level of abstraction is `layers`. We should divide our application into the following layers:
- `domain`
- `data`
- `presentation`

The main idea is to separate the business logic from the frameworks used, like `Flutter` or `Firebase`. Each of the layers has its own responsibilities. The `data` layer is responsible for saving and loading data from the persistent store. The `domain` layer is responsible for data processing, and interfacing with the `data` layer. The `presentation` layer is responsible for displaying the data to the user and gives an ability for the user to interact with data.

> Explain the clean architecture dependency rule.

The dependency rule defines how the application components should behave to each other and helps to avoid dependencies that will reduce the maintainability and testability of the application. Let us consider the components diagram that explains the dependencies between the application components according to the dependency rule: 

![Dependency rule diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/master/metrics/web/docs/diagrams/dependency_rule_diagram.puml)

See [The Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) article to get more wide explanation of the dependency rule.

## Metrics Web Application modules
> Explain the components of the application module.

As we mentioned above, our application is divided into modules. Each module is a set of related functionality (use cases) that has at least one page (or screen) in it to display and interact with data. Also, each module is divided into the following layers:

- The `data` layer that provides an ability to work with persistent storage.
- The `domain` layer that contains the main business logic and `entities` for this module.
- The `presentation` layer that displays the data and provides an ability to interact with it.

> List all current modules.

Currently, our application has the following modules: 
- `auth` - provides an ability to authenticate the user;
- `dashboard` - provides an ability to get information about the main metrics of the available projects.

## Clean architecture in the Metrics Web Application
> Add the abstract class diagram with packages that will explain the main class and layers relationships.

Let us consider the class diagram that will explain the main idea of the package structure and relationships between application layers in one module. Let's call this module `cool_module`: 

![Web Architecture Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/master/metrics/web/docs/diagrams/web_architecture_class_diagram.puml)

Once we have a class diagram that provides detailed information about layers and relationships between them, let's consider the details about layers and their constituents.

## Metrics Web Application data layer
> Explain what a `data` layer is and what it consists of in terms of the Metrics Web Application.

The `data` layer is the application layer responsible for data saving/loading from the persistent store. The `data` layer consists of the `model` and the `repository` packages that contain a concrete implementation of saving, loading data from the persistent store, and data serialization.

> Explain what a `model` is.

The `model` is a class that represents some data model in the persistent store. The `model`s can contain serialization methods used to map the objects into `JSON`, `CSV`, `XML`, etc. Also, the `data` layer can contain separate packages for deserializers, adapters, etc. used to map the `JSON`, `CSV` or any other formats into the data models if required.

> Explain what a `repository` is.

The `repository`, in its turn, is the class that provides an ability to interact with the persistent store.

## Metrics Web Application domain layer
> Explain what a `domain` layer is and what it consists of in terms of the Metrics Web Application.

The `domain` layer is a part of the Metrics Web Application responsible for data processing and interaction with the `data` layer. This layer consists of `entities`, `use cases`, and `repository`. The domain layer contains the major part of the application functionality and business logic. 

> Explain what an `entity` is.

An `entity` is an object that encapsulates the critical business rules and represents a critical business data. In other words, an `entity` is an object that contains the critical data for the selected knowledge domain and can contain the business logic that is closely connected to the `entity`'s data. This means that the only reason for changing the logic in the `entity` should be an outside change in the knowledge domain. An `entity` should have no application-specific dependencies.

> Explain what a `Use Case` is.

The `use case` is a class that represents a case of application usage. This means that each `use case` contains a part of the application logic specific for the current module. The `use case`s are used to interact with the `data` layer from the `presentation` layer. Also, the `use case`s should not have any `presentation` or `data`-specific dependencies according to the dependency rule. 

> Explain why a `domain` contains a `repository` as well.

Since the `domain` layer cannot depend on the `data` layer we should create an interface of the `repository` in the `domain` layer and use this repository interface in the `use case`s to make them more maintainable and testable. The `data` layer should implement the repository interface.

## Metrics Web Application presentation layer
> Explain what a `presentation` layer is and what it consists of in terms of the Metrics Web Application

The `presentation` layer is responsible for displaying the data for the users and provides an ability to interact with the data for the user. The `presentation` layer usually consists of the following parts:

- `view models`
- `pages` 
- `widgets`
- `strings`
- `state`

Note that the `presentation` layer can contain other packages. Also, the `presentation` layer not always contain all of the above packages. 

> Explain what a `view model` is.

A `view model` is a class that implements the humble object pattern and used for data transfer from the presenter to the view. The `view model` should not depend on any entities or anything from the domain level. The `view model` is needed to make the UI (pages and widgets) independent from the domain layer.

> Explain what a `page/widget` is.

A `widget` is the part of the Metrics Web Application UI that stands for displaying the piece of some data. A `page` is the widget that properly combines `widgets`. Represents the web page or screen of the application.

> Explain what a `state` is.

A `state`, or a presenter, is the part of the `presentation` layer that is the intermediary between the `domain` and the `presentation` layer. A state is responsible for holding the logic of the `presentation` layer - loading data, creating `view model`s from `entities`, saving data to the persistent store. The presenter separates the logic from UI to makes it more testable and structured.

To discover more details about the `presentation` layer and widgets for the Metrics Web Application, see the [Presentation Layer](02_presentation_layer_architecture.md) and [Widget structure organization](03_widget_structure_organization.md) documents.

## Communication between layers
> Explain and diagram how do these three layers work together more detailed.

As we noticed above, the `domain` uses the `data` layer to save and load the data from the persistent store, and the `presentation` layer to display this data. Also, the `presentation` uses business logic from the `domain` to interact with the persistent store. As we can see on the diagram in the [Clean architecture in the Metrics Web Application](#Clean-architecture-in-the-Metrics-Web-Application) section, the presentation layer has a `state` (ChangeNotifier) that contains all the available use cases for this application module. The UI components (widgets) call the `state` methods to get or save some updates in the persistent store. The `state`, in its turn, works with the repository (the `data` layer) to save or load the data from the persistent store.

Also, the `data` layer can notify the `domain` about data updates in the persistent store. For example, if the `use case` is subscribed to database collection updates. In this situation, the `use case`, which is from the `domain` layer, triggers the `state` and it will result in UI updates.

> Explain how the `presentation` layer works with the `domain` layer and how the `domain` layer works with the `data` layer.

Let's consider an example of the data migrations and transformations between different layers of the Metrics Web Application. Here, the diagram shows the process of loading abstract `cool metrics` from the persistent store to display it for the user `Bob`. 

![Web Layers Sequence Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/master/metrics/web/docs/diagrams/web_layers_sequence_diagram.puml)

# Package structure
> Explain and diagram the Metrics Web Application package structure.

## The `module` package structure

As we mentioned above, the Metrics Web Application uses the `Screaming Architecture` in combination with the `Clean Architecture`. So, on the top-level package structure, we can divide the application into modules that will contain the `data`, `domain`, and `presentation` layers. Thus, the module's package gets its _screaming_ look as follows:

> * module/
>    * `data_layer`
>    * `domain_layer`
>    * `presentation_layer`

The `data_layer` package represents the **`data` layer** of the module (see the [Metrics Web Application data layer](#Metrics-Web-Application-data-layer) section for more details). Let us consider the package structure of the `data_layer` package:

> * data/
>   * model/
>   * deserializer/
>   * repositories/

The `domain_layer` package represents the **`domain` layer** of the module (see the [Metrics Web Application domain layer](#Metrics-Web-Application-domain-layer) section for more details). The package structure for the `domain_layer` for each module looks as follows:

> * domain/
>   * entities/
>   * usecases/
>   * repositories/

Similarly, the `presentation_layer` package represents the **`presentation` layer** of the module (see the [Metrics Web Application presentation layer](#Metrics-Web-Application-presentation-layer) section and the [Presentation layer architecture](02_presentation_layer_architecture.md) document for more details). The package structure for the `presentation_layer` layer for each module looks as follows:

> * presentation/
>   * view_models/
>   * state/
>   * pages/
>   * strings/
>   * widgets/
>       * strategy/

Regardless of the module's purpose, its package structure must follow the same pattern described above. This helps to simplify navigation for all the application parts and make them similar to each other. 

Also, we have the `util` package that contains all the utility classes/extensions used in the Metrics Web Application.

## The `common` package structure

Unlike the usual module structure, the `common` module structure has a bit different `presentation` layer package structure. In the `common/presentation` package, we have separate packages for different presentation components like `metrics_theme` or `injector` that will contain any commonly used widgets or `view model`s. Also, the `common/presentation` package contains the `widgets` package that contains the commonly used widgets that could not be grouped into any package because there are no similar widgets. Let's call this package structure unit as `common_unit`.

> * common/
>    * `data_layer`
>    * `domain_layer`
>    * presentation/
>      * metrics_theme/
>      * injector/
>      * widgets/

Note that the `common/presentation` package does **NOT** contain the `base` widgets. All the widgets within the `common/presentation` are considered to be `metrics` that are used by the multiple modules of the Metrics Web Application. For example, the `MetricsThemeBuilder`, `InjectionContainer`, etc.

## The `base` package structure

Similar to the `common` package, we have the `base` package that contains all the classes that does not have any project-specific dependencies and can be easily reused in any other project. The `base` package contains all `base` widgets and generic interfaces. The `base` package structure should look like this (let's call it a `base_unit`): 

> * base/
>    * `data_layer`
>    * `domain_layer`
>    * presentation/
>      * graphs/
>      * widgets/

The `domain` and the `data` layers of this module will be the same as in other packages, but the `presentation` layer will look a bit different. It will contain any packages with the widgets groups like `graphs` and the `widgets` package that contains all widgets that cannot be grouped for some reason.

Please note, that the `base` module should contain only general classes that does **NOT** related to the Metrics Web Application at all.

## The Metrics Web Application package structure 

So, to sum up, let's consider the Metrics Web Application package structure: 

> * lib/
>   * `base_unit`
>   * `common_unit`
>   * dashboard/
>     * `data_layer`
>     * `domain_layer`
>     * `presentation_layer`
>   * auth/
>     * `data_layer`
>     * `domain_layer`
>     * `presentation_layer`
>   * some_another_module/
>     * `data_layer`
>     * `domain_layer`
>     * `presentation_layer`
>   * util/

# Dependencies
> What is the project blocked on?

No blockers.

> What will be impacted by the project?

- The document decreases the entry threshold for newcomers of the Metrics Web Application.
- The document simplifies the implementation process of the Metrics Web Application by explaining the common principles and concepts of the application architecture.

# Alternatives Considered
> Summarize alternative designs (pros & cons).

- Not document the Metrics Web Application widget structure organization:
    - Cons:
        - As the application grows, the future development of new modules and maintaining the old ones may be tricky without any document describing the module's structure and components.
        - With no written explanation in different parts of the Metrics Web Application, it will be longer for the new team members to become productive.

# Results
> What was the outcome of the project?

The document that explains the Metrics Web Application architecture and its design on a top-level. 
