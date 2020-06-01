# Metrics Web Application architecture
> Summary of the proposed change.

An explanation of the Metrics Web Application architecture.

# References
> Link to supporting documentation, GitHub tickets, etc.

- [Clean Architecture: A Craftsman's Guide to Software Structure and Design](https://www.amazon.com/Clean-Architecture-Craftsmans-Software-Structure/dp/0134494164)

# Motivation
> What problem is this project solving?

To make the Metrics Web Application architecture clean and understandable we have to create a document that will explain the main principles and components of the Metrics Web Application.

# Goals
> Identify success metrics and measurable goals.

- Explain common principles of the Clean Architecture.
- Explain components and modules of the Metrics Web Application.

# Non-Goals
> Identify what's not in scope.

- The document does not explain the Clean Architecture in details.
- The document does not describe the details of presentation layer and it's components. 

# Design
> Explain and diagram the technical design.

## Clean architecture fundamentals
> Explain the basic principles of the [Screaming architecture](https://blog.cleancoder.com/uncle-bob/2011/09/30/Screaming-Architecture.html).

The screaming architecture supposes that the root directory of the project should tell about all `use cases` this project provides. This means that the newcomer's first impression should be like "oh, that is a project about metrics and their displaying". So, we should create such a package structure that will "scream" about the purpose of the application, but not about the frameworks or the tools used in it. To make our package structure clean, understandable, and make it scream about `use cases` we are dividing the application to separate modules like the `dashboard`, `auth`, etc. to be able to see all the `use cases` of the application from the top level and navigate in the source code freely.

> Explain what are the application layers and why do we need them.

The next level of abstraction is `layers`. We should divide our application into several layers - the `domain`, `data`, and `presentation` layers to separate the business logic from the frameworks used, like `Flutter` or `Firebase`. Each of the layers has it's own responsibilities. The `data` layer responsible for saving and loading data from persistent store, the `domain` layer responsible for data processing and interaction with `data` layer. The `presentation` layer responsible for displaying the data to the user and gives an ability for user to interact with data. So, these layers encapsulates the business logic of different application layers and makes our application more maintainable. Also, it allows us to write more granular tests and test different pieces of the application separately from each other.

> Explain the clean architecture dependency rule.

The dependency defines how the application components should behave to each other and helps to avoid dependencies that will reduce the maintainability and testability of the application. Let us consider the components diagram that explains the dependencies between the application components according to the dependency rule: 

![Dependency rule diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/software-platform/monorepo/widget_stucture_organization_document/metrics/web/docs/diagrams/dependency_rule_diagram.puml)


## Metrics Web Application modules
> Explain the components of the application module.

As we mentioned above, our application is divided into modules. Each module is a set of related functionality (use cases) that has at least one page (or screen) in it to display and interact with data. Also, each module is divided into `data`, `domain`, and `presentation` layers that contains different parts of functionality (persistent store interaction, data processing, etc.).

So, each module consists of: 
1. The `data` layer that provides an ability to work with persistent storage.
2. The `domain` layer that contains the main business logic and `entities` for this module.
3. The `presentation` layer that displays the data and provides an ability to interact with it.

> List all current modules.

Currently, our application has the following modules: 
- `auth` - provides an ability to authenticate the user;
- `dashboard` - provides an ability to get information about the main metrics of the available projects.

## Clean architecture in the Metrics Web Application
> Explain the way we are implementing the clean architecture in the Metrics Web Application.

In the Metrics Web Application, we are using the `Clean Architecture` in combination with the `Screaming architecture` that provides the package structure. We are dividing our application into a couple of modules that give a top-level understanding of the purposes of the application. The modules lays on the top level of the project structure and give an ability to understand the application use cases from the very beginning. In turn, each module divided into `data`, `domain`, and presentation layers as the Clean Architecture suggests. Using the Clean Architecture provides high maintainability and testability of our application.

> Add the abstract class diagram with packages that will explain the main class and layers relationships.

Let us consider the class diagram that will explain the main idea of the package structure and relationships between application layers in one module. Let's call this module `cool_module`: 

![Web Architecture Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/software-platform/monorepo/widget_stucture_organization_document/metrics/web/docs/diagrams/web_architecture_class_diagram.puml)

Once we have a class diagram that provides detailed information about layers and relationships between them, let's consider the details about layers and their constituents.

## Metrics Web Application data layer
> Explain what a `data` layer is and what it consists of in terms of the Metrics Web Application.

The data layer is the application layer responsible for data saving/loading from the persistent store. The data layer consists of the `model` and the `repository` packages that contain a concrete implementation of saving, loading data from the persistent store, and data serialization.

> Explain what a `model` is.

The `model` is a part of the data layer that represents the entity in some persistent store. The `model`s contain the serialization methods used in concrete repository implementation. Commonly, the `model`s inherit from an entity that they represent.

> Explain what a `repository` is.

The `repository`, in it's turn, is the class that provides an ability to interact with the persistent store.

## Metrics Web Application domain layer
> Explain what a `domain` layer is and what it consists of in terms of the Metrics Web Application.

The `domain` layer is a part of the Metrics Web Application responsible for data processing and interaction with the `data` layer. This layer consists of `entities`, `use cases`, and `repository`. The domain layer contains the major part of the application functionality and business logic. 

> Explain what an `entity` is.

An `entity` is an object that encapsulates the critical business rules and represents a critical business data. In other words, an `entity` is an object that contains the critical data for the selected knowledge domain and can contain the business logic that is closely connected to the `entity`'s data. This means that the only reason for changing the logic in the `entity` should be an outside change in the knowledge domain. An `entity` should have no application-specific dependencies.

> Explain what a `Use Case` is.

The `use case` is a class that represents a case of application using. This means that each use case contains a part of the application logic specific for the current module. The `use case`s are used to interact with the `data` layer from the presentation layer. Also, the use cases should not have any presentation or data-specific dependencies according to the dependency rule. 

> Explain why a `domain` contains a `repository` as well.

Once the `domain` layer cannot depend on the `data` layer we should create an interface of the `repository` in the `domain` layer and use this repository in the `use case`s to make them more maintainable and testable.

## Metrics Web Application presentation layer
> Explain what a `presentation` layer is and what it consists of in terms of the Metrics Web Application

The `presentation` layer is responsible for displaying the data for the users and provides an ability to interact with the data for the user. The presentation layer consists of the `view model`, `page`, `widgets` and `state`.

> Explain what a `view model` is.

A `view model` is a class that implements the humble object pattern and used for data transfer from the presenter to the view. The `view model` should not depend on any entities or anything from the domain level. The `view model` is needed to make the UI (pages and widgets) independent from the domain layer.

> Explain what a `page/widget` is.

A `widget` is the part of the Metrics Web Application UI that stands for displaying the piece of some data. A `page` is the widget that properly combines `widgets`. Represents the web page or screen of the application.

> Explain what a `state` is.

A `state`, or a presenter, is the part of the presentation layer that is the intermediary between the domain and the presentation layer. A state is responsible for holding the logic of the presentation layer - loading data, creating `view model`s from `entities`, saving data to the persistent store. The presenter is needed to separate the logic from UI to make it more testable and structured.

To discover more details about presentation layer and widgets for the Metrics Web Application, see the [Presentation Layer](02_presentation_layer_architecture) and [Widget structure](03_widget_structure_organization) organization documents.

## Communication between layers
> Explain and diagram how do these three layers work together more detailed.



> Explain how the `presentation` layer works with the `domain` layer and how the `domain` layer works with the `data` layer.

1. Add a data flow diagram explaining data migrations and transformations in the context of layers.
    `data layer(repo)` -> `domain(use case)` -> `presentation(store)` -> `view(UI)` and vice-versa

# Package structure
> Explain and diagram the Metrics Web Application package structure.

`data_unit`
> * data/
>   * deserializer/
>   * repositories/

`domain_unit`
> * domain/
>   * entities/
>   * usecases/
>   * repositories/

`presentation_unit`
> * presentation/
>   * view_model/
>   * state/
>   * pages/
>   * strings/
>   * widgets/
>       * strategy/

`module_unit`
> * module/
>    * `data_unit`
>    * `domain_unit`
>    * `presentation_unit`

`common`
> * common/
>    * `data_unit`
>    * `domain_unit`
>    * `presentation_unit`

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
        - The module appears to be tricky for newcomers without any document describing it on a top-level.

# Results
> What was the outcome of the project?

The document that explains the Metrics Web Application architecture and its design on a top level. 
