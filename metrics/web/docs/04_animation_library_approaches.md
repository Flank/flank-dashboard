# Animation Library Approaches

## Motivation

> What problem is this project solving?

To improve the user experience of the Metrics Web Application, we need to add some animated visual effects.

Therefore, the document's goal is to investigate the main approaches of animations displaying in Flutter considering both web and mobile and select the best approach for the Metrics Web Application.

## References

> Link to supporting documentation, GitHub tickets, etc.

- [Flutter guide: Introduction to animations](https://flutter.dev/docs/development/ui/animations).
- [Lottie library](https://airbnb.io/lottie/#/).
- [Rive app](https://rive.app/).

## Analysis

### Process

This analysis begins with the comparison of main approaches to display animations in the Metrics Web Application. It provides the main pros and cons and a short description of each approach we've investigated.

The research should conclude with a chosen approach and a short description of why did we choose such an approach.

#### Manual

The first approach is to create the animations using Flutter's built-in animations without using any 3-rd party packages.

Pros:
- Allows building fully customizable animations from scratch. 

Cons:
- Hard to implement complex pixel-perfect animation.

#### Lottie

The second approach is to utilize [`lottie_package`](https://pub.dev/packages/lottie).
Lottie is a library created by Airbnb that parses Adobe After Effects animations exported as JSON and renders them natively in the application.

Pros:
- Provides Flutter-like widgets to render animation: `Lottie.asset`, `Lottie.network`, etc.
- Good performance.

Cons:
- Animations are poorly rendered on mobile devices.

#### Rive

The third approach is to use [`rive_package`](https://pub.dev/packages/rive). Rive is a real-time interactive design and animation tool.

Pros:
- Animations are rendered as expected on both web and mobile. 
- Good performance.
- Fits well with the existing widget and driver tests.

### Decision

As we've analyzed above, even though the `Lottie` library has a better developer experience, it is not suitable for mobile at the moment, so we are going to use the `Rive` package to render the animations for the Metrics Web Application.
