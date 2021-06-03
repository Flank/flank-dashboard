# Metrics Storybook design

> Feature description / User story.

Storybook in JavaScript world is a tool for UI development. It makes development faster and easier in an isolated manner. It allows you to browse a components library, view the different states of each component, and interactively develop and test components.

A similar concept we want to apply to the Metrics Web Application.

## Contents

- [**Analysis**](#analysis)
    - [Feasibility study](#feasibility-study)
    - [Requirements](#requirements)
    - [Landscape](#landscape)
        - [Using existing packages](#using-existing-packages)
        - [Manually create a Storybook from scratch](#manually-create-a-storybook-from-scratch)
- [**Design**](#design)
    - [Architecture](#architecture)
    - [User Interface](#user-interface)
    - [Database](#database)
    - [Program](#program)

# Analysis

> Describe a general analysis approach.

During the analysis stage, we should understand a [feasibility](#feasibility-study) to implement the feature along with a list of the given [requirements](#requirements). For this purpose, we need to define a set of components, that we want to extract from the Metrics Web Application into the Metrics storybook. After that, we should consider examples of existing component libraries and packages for Flutter projects, that provide a possibility to create similar UI libraries.

Based on the analysis, we should make a decision about an optimal approach that satisfies the [requirements](#requirements) for the Metrics storybook.

### Feasibility study

> A preliminary study of the feasibility of implementing this feature.

First of all, the great purpose of the Metrics storybook is that each widget and story (a specific state of a widget) can be easily reused across the entire project by any developer who works on it, ensuring consistent design and UX.

The storybook application can be shared with and commented on by designers so that they can add their input regarding the implementation of the designs.

Another group that can use this feature is clients. Storybook makes it easy to show pieces of the software to keep the client in the loop. Even small pieces of UI can be shared and made available for feedback, preventing longer periods without any deliverables.

As you write your components in isolation, without regard to business logic, you can potentially put a greater emphasis on code quality and reusability.

Metrics storybook creating allows developers to work in parallel on widgets and do not touch the main Metrics Web Application's codebase. It also, makes it easier to add new widgets, since we can test them separately and only then make changes to the code of the application.

### Requirements

> Define requirements and make sure that they are complete.

- Displays a set of Metrics widgets.
- An ability to manage themes.
- Contains a tab with widget documentation.
- Contains a list of inputs to change widgets' appearance (height, width, color, etc.).
- Contains the Metrics color palette to view all project's colors.
- An ability to search across components.
- Visually groups widgets by their types.
- Change viewport size (view widgets on different devices).

### Landscape

> Look for existing solutions in the area.

Before launching the solutions, we need to determine which components from the Metrics Web Application should be included in the storybook.

There are [two types of widgets](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/03_widget_structure_organization.md#widget-creation-guidelines):
 - *base* - a widget that is responsible for only displaying the given data. These widgets should be highly configurable and usable out of the Metrics Web Application context.
 - *common* - is a widget that is actually used in the Metrics Web Application context and can be used across the modules.

The main question is whether we want to extract to the Metrics storybook only base widgets or add common widgets as well.

If we add only base widgets to the storybook, we can accidentally duplicate the existing common Metrics widgets with the same functionality. Also, we will not be able to view the entire list of possible components that are used in the application.

That's why our choice is to take out base widgets together with common ones.

According to the [widget structure organization document](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/03_widget_structure_organization.md#applying-a-theme-to-a-widget-appearance) common widgets use the Metrics theme. Thus to display these widgets in the storybook correctly we should move the Metrics theme along with them. The disadvantage of moving common widgets is the loss of the ability to customize them as base widgets.

Now, when we've determined a set of components to extract to the storybook we can investigate existing solutions that provide the logic to showcase widgets.

There are two approaches to create the storybook for Flutter widgets - [using existing packages](#using-existing-packages) or [creating a UI from scratch](#Manually-create-a-storybook-from-scratch).

#### Using existing packages

At this time, there are only a few packages, that provide the functionality to write Storybook for Flutter widgets.

Let's take a closer look at the packages:

1. [Storyboard](https://pub.dev/packages/storyboard)

There are simple classes, which provide all the logic to start writing the storybook. It is just a little package, that helps to reduce a boilerplate.

Pros:

- Simple classes without much complex logic.

Cons:

- It is more a simple boilerplate rather than a storybook project.
- Not frequent updates to code.
- Managing themes are done on our own.
- Does not have a docs tab that supports MDX (or similar) with the documentation about the widget.
- Does not have a search across components functionality.
- It's not so popular (has only a few stars on GitHub).

2. [Monarch](https://pub.dev/packages/monarch)

Provides a sandbox to build Flutter widgets in an isolation. The isolation is provided through `Stories` - a function that returns a `Widget`. A story captures a rendered state of a Flutter widget.

To make it work, we should install the Xcode and download the Monarch binary.

Pros:

- Does not need to create a separate project to have a storybook.
- Allows managing themes.
- Views widgets on different devices.

Cons:

- Requires to download the Monarch binary.
- Requires to install XCode.
- Does not contain a panel with inputs to change widgets' appearance.
- Does not support Web as a device target to test UI components.
- Does not have an ability to group widgets by their types (base/common).
- Does not have a docs tab that supports MDX (or similar) with the documentation about the widget.
- Requires to update a Dart version to 2.12.0 or higher.
- It's not so popular (has only a few stars on GitHub).

3. [Dashbook](https://pub.dev/packages/dashbook)

Dashbook is a UI development tool for Flutter, it allows showcasing widgets. It supports both mobile and web. The package has a similar principle for isolating and previewing a list of widgets.

Pros:

- Allows managing themes.
- Allows group widgets by their types.
- Contains a list of inputs to change widgets' appearance.

Cons:

- Provides only a plain UI.
- On the preview screen, users cannot select the viewport size.
- Does not have a docs tab that supports MDX (or similar) with the documentation about the widget.
- Does not have a search across components functionality.
- It's not so popular (has only a few stars on GitHub).
- Requires to update a Dart version to 2.12.0 or higher.

4. [Storybook_flutter](https://pub.dev/packages/storybook_flutter)

A cross-platform storybook for showcasing widgets. It works on all platforms supported by Flutter.

Pros:

- Allows managing themes.
- Allows creating a custom Storybook (e.g. UI).
- Allows approximating how a particular widget looks and performs on different devices (requires additional related package).

Cons:

- Provides only a plain UI.
- Does not have a docs tab that supports MDX (or similar) with the documentation about the widget.
- Does not have a search across components functionality.
- Requires to update a Dart version to 2.12.0 or higher.
- It's not so popular (has only a few stars on GitHub).

#### Manually create a Storybook from scratch

Another solution is to provide a completely new Flutter project with the [required functionality](#requirements).

Pros:

- Allows creating a custom Storybook with all required features.

Cons:

- Requires designing a new UI for the Metrics storybook.
- Takes extra time to realize the new UI.

#### Conclusion

The described above packages do not suit us for several reasons:

- They are rather libraries to showcasing widgets with an ability to change their appearance, but the storybook is a bit more than that. A storybook contains documentation about widgets, information about the possible parameters that widgets can accept, search across widgets functionality, and more.

- The management of themes in these packages is reduced only to the possibility of switching between the dark and the light themes, as well as the presence of a toggle theme button, the behavior of which we cannot control. Even though the packages allow managing themes, it becomes a complex task to integrate the Metrics theme into the storybook. The described above packages do not allow to provide the theme data for all the Metric widgets. See [Metrics Theme guidelines](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/03_widget_structure_organization.md#metrics-theme-guidelines) to get more metrics theme implementation details.

- The UI in these packages is, also very basic, without thoughtful design and UX.

Summing up the consideration of approaches and given the above explanations, the best solution would be to create this library from [scratch](#manually-create-a-storybook-from-scratch).

# Design

### Architecture
> Fundamental structures of the feature and context (diagram).

### User Interface
> How users will interact with the feature (API, CLI, Graphical interface, etc.).

### Database
> How relevant data will be persisted.

### Program
> Detailed solution description to class/method level.
