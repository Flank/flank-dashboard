# Deep Links Design
> Feature description / User story.

As a user, I want to pass direct links to project and/or project groups, so that other users can navigate easier.

# Analysis
> Describe the general analysis approach.

Consider the following goals of the analysis stage:
1. Define the detailed requirements for the deep linking feature;
2. Investigate existing implementation approaches for the deep linking in Flutter Web application.
3. Select the implementation approach for the Metrics Web application that will satisfy the requirements.

Before deep diving into deep linking feature analysis, make sure to get familiar with the Flutter new navigation system ([Navigator 2.0](https://flutter.dev/docs/release/breaking-changes/route-navigator-refactoring)) which is [used in the Metrics Web application](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/features/navigation/01_navigation_design.md). The understanding of Navigator 2.0 approach is important for the understanding deep linking feature.

## Requirements
> Define requirements and make sure that they are complete.

The deep links implementation approach that we are to select must satisfy the following requirements:
- Possibility to handle deep links and restore the application's state using them;
- Possibility to reflect the application's state in deep links as a response to UI events (e.g. filtering, dropdown selections, searching, etc.);
- Extensible and testable implementation approach.

## Feasibility study
> A preliminary study of the feasibility of implementing this feature.

The Navigator 2.0 empowers the two main aspects needed to implement the deep linking feature: extracting the query parameters from the URL and updating query parameters in response to the application state changes; so, as we already use the Navigator 2.0 in the Metrics Web application, it is possible to implement the deep linking feature.

## Landscape
> Look for existing solutions in the area.

Currently, the [custom implementation of the Navigator 2.0](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/features/navigation/01_navigation_design.md) in the Metrics Web application does not support deep linking. 

There's also several third-party packages that allow handling deep links in the Flutter Web application and simplify working with the vanilla Navigator 2.0:
- The [`routemaster`](https://pub.dev/packages/routemaster) package;
- The [`beamer`](https://pub.dev/packages/beamer) package;
- The [`yeet`](https://pub.dev/packages/yeet) package;
- The [`navi`](https://pub.dev/packages/navi) package.

The third-party packages doesn't work well with the existing implementation of the navigation in the Metrics Web application and involve some amount of codegen, hence it is not the best option to use.

### Prototyping

> Create a simple prototype to confirm that implementing this feature is possible.

### System modeling

> Create an abstract model of the system/feature.
