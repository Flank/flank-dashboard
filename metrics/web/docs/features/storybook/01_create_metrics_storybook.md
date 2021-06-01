# Metrics Storybook design

> Feature description / User story.

Storybook in JavaScript world is a tool for UI development. It makes development faster and easier in an isolated manner. It allows you to browse a components library, view the different states of each component, and interactively develop and test components.

A similar concept we want to apply to the Metrics widgets. The project should consist of a set of widgets along with the Metrics theme.

# Analysis

> Describe general analysis approach.

During the analysis stage, we are going to investigate approaches providing logic for showcasing widgets and chose the most suitable one for us.

### Feasibility study

> A preliminary study of the feasibility of implementing this feature.

Since we can build UI using Flutter in a modular manner, we are able to create a Storybook.

There are few packages providing the functionality of creating Storybook for Flutter:

- [storyboard](https://pub.dev/packages/storyboard)
- [monarch](https://pub.dev/packages/monarch)
- [dashbook](https://pub.dev/packages/dashbook)
- [storybook_flutter](https://pub.dev/packages/storybook_flutter)

Also, we can provide the same functionality from the scratch and do not use any package from the list above.

### Requirements

> Define requirements and make sure that they are complete.

- A library with a set of Metrics widgets.
- An ability to manage themes to view widgets within different states.
- Ease of sharing and reusing widgets.
- Easy to test widgets in an isolation.

### Landscape

> Look for existing solutions in the area.

At this time there are two approaches to create the Storybook for Flutter widgets - using existing packages or creating a UI from scratch.

#### Packages

To follow the DRY principle we can provide a list of `Pros` and `Cons`, related to all the packages, described below:

Pros:

- Building widgets without the entire application context.
- UI testing can be done without running your full-stack or changing values in a database.
- Easy to find bugs in widget implementation, because we have not an entire screen of widgets, but a testable widget in the isolation.
- An ability to work on multiple widgets at the same time.

Cons:

- Don't have a docs tab that supports MDX (or similar) with the documentation about the widget.
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

- Do not need to create a separate project to have a storybook.
- Allows managing themes.
- View widgets on different devices.

Cons:

- Requires to download the Monarch binary.
- Requires to install XCode.
- Does not support Web as a device target, to test UI components.

3. [Dashbook](https://pub.dev/packages/dashbook)

The package has a similar principle for isolate and previews the list of widgets.

Pros:

- Allows managing themes.

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

#### Manual create a Storybook from scratch

Pros:

- Allows creating a custom Storybook with all required features.

Cons:

- Requires designing a new Storybook UI.
- Takes extra time to realize the new UI.

#### Conclusion

Summing up the consideration of approaches, and given the fact that we do not want to create a storybook in its pure form, but rather a specific library of metrics widgets, and also, we want to manage the Metrics theme, the best solution would be to create this library from [scratch](#manual-create-a-storybook-from-scratch).
