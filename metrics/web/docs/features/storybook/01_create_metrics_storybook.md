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
    - [Prototyping](#prototyping)
    - [System modeling](#system-modeling)
- [**Design**](#design)
    - [Architecture](#architecture)
    - [User Interface](#user-interface)
    - [Database](#database)
    - [Program](#program)

# Analysis

> Describe general analysis approach.

During the analysis stage, we should understand a [feasibility](#feasibility-study) to implement the feature along with a list of the given [requirements](#requirements). For this purposes we need to define a set of components, that we want to extract from the Metrics Web Application into the Metrics storybook - base widgets, Metrics specific widgets, the Metrics theme(To read more about widgets and theme in the Metrics Web Application consider the following link: [Widget structure organization](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/03_widget_structure_organization.md#widget-creation-guidelines). After that we consider examples of existing component libraries and packages for Flutter projects, that provide a possibility to create similar UI libraries.

Based on the analysis, we should make a decision about an optimal approach that satisfies the [requirements](#requirements) for the Metrics storybook.

### Feasibility study

> A preliminary study of the feasibility of implementing this feature.

First of all, the great purpose of the Metrics storybook is that each widget and story can be easily reused across the entire project by any developer who works on it, ensuring consistent design and UX.

The storybook application can be shared with and commented on by designers so that they can add their input regarding the implementation of the designs.

Another group that can use this feature is clients. Storybook makes it easy to show pieces of the software in order to keep the client in the loop. Even small pieces of UI can be shared and made available for feedback, preventing longer periods without any deliverables.

As you write your components in isolation, without regard to business logic, you can potentially put a greater emphasis on code quality and reusability.

Metrics storybook creating allows developers to work in parallel on widgets and do not touch the main Metrics Web Application's codebase. It also, makes it easier to add new widgets, since we can test them separately and only then make changes to the code of the application.

### Requirements

> Define requirements and make sure that they are complete.

- Displays a set of Metrics widgets.
- An ability to manage themes.
- Contains a tab with a widget documentation.
- Contains a list of inputs to change widgets' appearance(height, width, color, etc.).
- Contains the Metrics color palette to view all project's colors.
- An ability to search across components.
- Visually groups widgets by their types.

### Landscape

> Look for existing solutions in the area.

Before launching the solutions, we need to determine which components from the Metrics Web Application should be included in the storybook.

There are [two types of widgets](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/03_widget_structure_organization.md#widget-creation-guidelines):
 - *base* - a widget that is responsible for only displaying the given data. These widgets should be highly configurable and usable out of the Metrics Web Application context.
 - *common* - is a widget that is actually used in the Metrics Web Application context and can be used across the modules.

The main question is whether we want to extract to the Metrics storybook only base widgets or add common widgets as well.

If we add only base widgets to the storybook, we can accidentally duplicate the existing common Metrics widgets with the same functionality. Also, we will not be able to view the entire list of possible components that are used in the application.

That's why our choice is to take out base widgets together with common ones.

According to the [widget structure organization document](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/03_widget_structure_organization.md#applying-a-theme-to-a-widget-appearance) common widgets use the Metrics theme. Thus to display these widgets in the storybook correctly we should move the Metrics theme along with them.

The disadvantage of moving common widgets is the loss of the ability to customize them as base widgets.

At this time there are two approaches to create the Storybook for Flutter widgets - using existing packages or creating a UI from scratch.

#### Using existing packages

To follow the DRY principle we can provide a list of `Pros` and `Cons`, related to all the packages, described below:

Pros:

- Building widgets without the entire application context.
- UI testing can be done without running your full-stack or changing values in a database.
- Easy to find bugs in widget implementation, because we have not an entire screen of widgets, but a testable widget in the isolation.
- An ability to work on multiple widgets at the same time.

Cons:

- Don't have a docs tab that supports MDX (or similar) with the documentation about the widget.
- Don't have a search across components.
- Require to update a Dart version to 2.12.0 or higher.
- Not so popular (have only a few stars on GitHub).

Now, let's take a closer look at the packages:

1. [Storyboard](https://pub.dev/packages/storyboard)

It is simple classes, which provide all the logic to start writing the storybook. It is just a little package, that helps to reduce a boilerplate.

Pros:

- A simple classes without much complex logic.

Cons:

- It is more a simple boilerplate rather than a storybook.
- Not frequent updates to code.
- Managing themes are done on our own.

2. [Monarch](https://pub.dev/packages/monarch)

Provides a sandbox to build Flutter widgets in an isolation. The isolation is provided through `Stories`. It is a function that returns a `Widget`. A story captures a rendered state of a Flutter widget.

To make it work, we should install the Xcode and download the Monarch binary. After that, we can create stories (files with the following form: `*_stories.dart`) to emulate different widget states.

Pros:

- Does not need to create a separate project to have a storybook.
- Allows managing themes.
- Views widgets on different devices.

Cons:

- Requires to download the Monarch binary.
- Requires to install XCode.
- Does not contain a panel with inputs to change widgets' appearance.
- Does not support Web as a device target, to test UI components.
- Does not have an ability to group widgets by their types (base/common).

3. [Dashbook](https://pub.dev/packages/dashbook)

The package has a similar principle for isolate and previews the list of widgets.

Pros:

- Allows managing themes.
- Allows group widgets by their types.
- Contains a list of inputs to change widgets' appearance.

Cons:

- On the preview screen in Storybook, users cannot select the viewport size.

4. [Storybook_flutter](https://pub.dev/packages/storybook_flutter)

A cross-platform storybook for showcasing widgets. It works on all platforms supported by Flutter.

Pros:

- Allows managing themes.
- Allows creating a custom Storybook (e.g. UI).
- Allows approximating how a particular widget looks and performs on different devices (requires additional related package).

The management of themes in the described packages is reduced only to the possibility of switching between the dark and the light themes, as well as the presence of a toggle theme button, the behavior of which we cannot control.

Even though the packages allow managing themes, it becomes a complex task to integrate the Metrics theme into the storybook. The described above packages do not allow to use `MetricsThemeData` to provide the theme data for all the Metric widgets. See [Metrics Theme guidelines](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/03_widget_structure_organization.md#metrics-theme-guidelines) to get more metrics theme implementation details.

#### Manually create a Storybook from scratch

Pros:

- Allows creating a custom Storybook with all required features.

Cons:

- Requires designing a new Storybook UI.
- Takes extra time to realize the new UI.

#### Conclusion

Summing up the consideration of approaches, and given the fact that we do not want to create a storybook in its pure form, but rather a specific library of metrics widgets, and also, we want to manage the Metrics theme, the best solution would be to create this library from [scratch](#manual-create-a-storybook-from-scratch).
