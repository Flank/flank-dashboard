# Animation Library Approaches

## Motivation

> What problem is this project solving?

To improve the user experience of the Metrics Web Application, we need to add some animated visual effects.

Therefore, the document's goal is to investigate the main approaches of animations displaying in Flutter considering both web and mobile and select the best approach for the Metrics Web Application.

## References

> Link to supporting documentation, GitHub tickets, etc.

- [Flutter guide: Introduction to animations](https://flutter.dev/docs/development/ui/animations).
- [Lottie library](https://airbnb.io/lottie/#/).
- [Lottie package](https://pub.dev/packages/lottie)
- [Rive app](https://rive.app/).
- [Rive package](https://pub.dev/packages/rive).

## Analysis

### Process

This analysis begins with the comparison of main approaches to display animations in the Metrics Web Application. It provides the main pros and cons and a short description of each approach we've investigated.

The research should conclude with a chosen approach and a short description of why did we choose such an approach.

#### Manual

The first approach is to create the animations using Flutter's built-in animations without using any 3-rd party packages.

Pros:
- Allows building fully customizable animations from scratch. 
- Easy to test and maintain.

Cons:
- Hard to implement complex pixel-perfect animation.

#### Lottie

The second approach is to utilize [`lottie_package`](https://pub.dev/packages/lottie).
Lottie is a library created by Airbnb that parses Adobe After Effects animations exported as JSON and renders them natively in the application.

Consider the following code snippet that demonstrates the usage of the `Lottie` library to display animations:

```dart
@override
Widget build(Buildcontext context) {
  return Lottie.network(
    'web/animation_name.json',
    alignment: Alignment.center,
    animate: true,
    controller: controller,
    framerate: FrameRate(50),
  );
}
```

Pros:
- Provides good Flutter-like API.
- Well customizable.
- Good performance.

Cons:
- Animations are not rendered correctly on mobile devices.
- Needs additional setup for testing.

#### Rive

The third approach is to use [`rive_package`](https://pub.dev/packages/rive). Rive is a real-time interactive design and animation tool.

Consider the following code snippet that demonstrates the usage of the `Rive` library to display animations:

```dart
class _SomeAnimationWidgetState extends State<SomeAnimationWidget> {

  final animationController = SimpleAnimation('animation_name');

  Artboard _animationArtboard;

  bool get _isAnimationLoaded => _animationArtboard != null;

  @override
  void initState() {
    super.initState();

    _loadAnimation();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAnimationLoaded) return const SizedBox();

    return Rive(
      artboard: _animationArtboard,
      alignment: Alignment.center,
      fit: BoxFit.cover,
      useArtboardSize: false,
    );
  }

  Future<void> _loadAnimation() async {
    final animationBytes = await rootBundle.load('animation_asset_name.riv');

    final riveFile = RiveFile();
    riveFile.import(animationBytes);

    final artboard = riveFile.mainArtboard;
    artboard.addController(animationController);

    setState(() {
      _animationArtboard = artboard;
    });
  }
}
```

To test the `Rive` package, we will need to inject the `RootBundle` to be able to mock the animation asset bytes.

Pros:
- Animations are rendered as expected on both web and mobile. 
- Good performance.

Cons:
- Has worse API comparing to the [Lottie](#lottie).
- Needs additional setup for testing.


### Decision

As we've analyzed above, even though the `Lottie` library has a better developer experience, it is not suitable for mobile at the moment, so we are going to use the `Rive` package to render the animations for the Metrics Web Application.
