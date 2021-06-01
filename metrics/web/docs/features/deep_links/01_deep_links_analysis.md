# Deep Links Design
> Feature description / User story.

As a user, I want to pass direct links to project and/or project groups, so that other users can navigate easier.

# Analysis
> Describe the general analysis approach.

The `Deep Linking` feature improves the navigation experience by allowing users to navigate to a specific resource of an application and to save the application state in a URL.

The analysis stage aims the following goals:
1. Define the detailed requirements for the deep linking feature;
2. Investigate existing implementation approaches for the deep linking in Flutter Web application.
3. Select the implementation approach for the Metrics Web application that will satisfy the requirements.

# Requirements
> Define requirements and make sure that they are complete.

The deep links implementation approach that we are to select must satisfy the following requirements:
- Possibility to handle deep links and restore the application's state using them;
- Possibility to reflect the application's state in deep links as a response to UI events (e.g. filtering, dropdown selections, searching, etc.);

# Prerequisites
Before deep diving into deep linking feature analysis, make sure to get familiar with the Flutter new navigation system ([Navigator 2.0](https://flutter.dev/docs/release/breaking-changes/route-navigator-refactoring)) which is [used in the Metrics Web application](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/features/navigation/01_navigation_design.md). The understanding of Navigator 2.0 approach is important for the understanding deep linking feature.

# Feasibility study
> A preliminary study of the feasibility of implementing this feature.

The `Deep Linking` feature improves the overall user experience in terms of the navigation, so this feature makes sense for the project.

To be able to implement the `Deep Linking` feature we should be able to perform the following actions:
- Parsing the `query parameters` from the URL;
- Updating the URL and the `query parameters` in response to any events.

Since the `Navigator 2.0` provides the navigation system that allows performing the actions listed above, and the Metrics Web application uses the `Navigator 2.0`, it is possible to implement the `Deep Linking` feature in the Metrics Web application.

## Landscape
> Look for existing solutions in the area.

There are 2 main approaches for implementing the `Deep Linking` feature in the Metrics Web application:
- Using 3-rd party package (such as [`routemaster`](https://pub.dev/packages/routemaster), [`beamer`](https://pub.dev/packages/beamer), etc.);
- A custom implementation based on the existing `Navigator 2.0` integration.

Let's compare the listed approaches in a bit more details.

### 3-rd party package approach
Consider the following pros and cons of the 3-rd party package utilization approach:

Pros:
- Provides ready-to-use implementation out of the box, including the deep linking, nested navigation and many other features.

Cons:
- May require code generation;
- Requires the navigation system reintegration - meaning that we must use the 3-rd party `RouteInformationParser`s and `RouterDelegate`s.

### Custom implementation
Consider the following pros and cons of the custom implementation approach:

Pros:
- Highly customizable approach;
- Well testable approach;

Cons:
- Requires more code comparing to the 3-rd party package approach.

According to the comparison above, we choose the [`Custom implementation`](#custom-implementation) approach, as it fits the current navigation approach used in the Metrics Web application, and satisfies the customization and testability requirements.

Consider this diagram that briefly describes the custom implementation approach:
![Custom approach diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/update_deep_links_analysis/metrics/web/docs/features/deep_links/diagrams/custom_approach_component_diagram.puml)

### Prototyping
> Create a simple prototype to confirm that implementing this feature is possible.

The following code snippet demonstrates the process of parsing the route parameters from the URL:
```dart
final url = 'https://some-website/page?queryParameter=someParameter';

final uri = Uri.parse(url);

print(uri.queryParameters); // {queryParameter : someParameter)
```

The following code snippet demonstrates the process of updating the URL in the browser (using the [`universal_html`](https://pub.dev/packages/universal_html) package):
```dart
import 'package:universal_html/universal_html.dart' show window;

final history = window.history;

final path = '/page';
final queryParameters = {
  'queryParameter' : 'someParameter',
};
final uri = Uri(path: path, queryParameters: queryParameters);

print('$uri'); // /page?queryParameter=someParameter

history.replaceState(path: '$uri'); 
```

### System modeling
> Create an abstract model of the system/feature.

The `Deep Linking` feature implementation mostly includes the modification of existing components of the navigation system used in the Metrics Web application. Consider the following component diagram that demonstrates this:

![Deep links integration diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/update_deep_links_analysis/metrics/web/docs/features/deep_links/diagrams/deep_links_integration_component_diagram.puml)