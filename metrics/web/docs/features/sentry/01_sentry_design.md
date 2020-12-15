# Sentry design

## TL;DR

Introducing Sentry plugin into the Metrics Web Application allows us to identify and fix production errors.

## References
> Link to supporting documentation, GitHub tickets, etc.
* [Sentry Dart documentation](https://docs.sentry.io/platforms/dart/)
* [Sentry SDK for Dart](https://pub.dev/packages/sentry)

## Goals
> Identify success metrics and measurable goals.
* A clear design of the Sentry integration.

## Design
> Explain and diagram the technical design.

The following sections provide an implementation of a Sentry integration into the Metrics Web Application.

To integrate the Sentry into the Metrics Web Application, we should provide the following functionality:

- initializing the Sentry SDK;
- capturing uncaught Flutter and Dart errors;
- capturing specific exceptions in the try-catch block;
- adding contexts.

### Initializing the Sentry

To start identifying errors we should initialize the Sentry SDK using the DSN issued by Sentry.io and the release name.

Example: 

```dart
await Sentry.init((options) => options
 ..dsn = 'https://example@sentry.io/add-your-dsn-here'
 ..release = 'release',
);
```

### Capturing uncaught Flutter and Dart errors

Also, we should add an ability to capture uncaught Flutter and Dart errors:

- To capture uncaught Dart errors, we should give the app runner callback to the `Sentry.init` method, if it's not null the Sentry SDK runs a guarded `Zone` over the app runner, or run the app inside your own guarded `Zone` and handle errors inside using the `Sentry.captureException` method. Zones establish an execution context for the code. This provides a convenient way to capture all errors that occur within that context.
- To capture uncaught Flutter errors, we should override the `FlutterError.onError` property and send the error to the callback defined in the previous step.

Example of the overriding the FlutterError.onError property:

```dart
FlutterError.onError = (details, {bool forceReport = false}) {
    Zone.current.handleUncaughtError(details.exception, details.stack);
};
```

### Capturing exceptions

As described in the previous step, we have the ability to catch uncaught Flutter and Dart errors, but we still need to catch specific errors in the try-catch block. To do that we have to use a Sentry SDK `captureException` method.

Example: 

```dart
try {
  aMethodThatMightFail();
} catch (exception, stackTrace) {
  await Sentry.captureException(
    exception,
    stackTrace: stackTrace,
  );
}
```

### Adding contexts

The Contexts interface provides an additional context data. For example, the device or browser version. The contexts type can be used to define arbitrary contextual data on the event. To do that we have to use a Sentry SDK `configureScope` method.

To add a new custom context, you should give it a name and related key/value pairs:

```dart
final projectName = {'name' : 'test'};
Sentry.configureScope((scope) => scope.setContexts('project', projectName));
```

Also, the Sentry SDK contains specific classes to facilitate adding a [common context](https://develop.sentry.dev/sdk/event-payloads/contexts/):

- To create an app context, you should use an `App` class.
- To create a browser context, you should use a `Browser` class.
- To create a device context, you should use a `Device` class.
- To create an operation system context, you should use an `OperationSystem` class.
- To create a GPU context, you should use a `GPU` class.
- To create a runtime context, you should use a `Runtime` class.

Example of adding a common context using the Sentry SDK built-in classes:

```dart
final browser = Browser(name: 'chrome', version: '87.0.4280.88');
Sentry.configureScope((scope) => scope.setContexts(Browser.type, browser));
```

## Sentry util

To provide an easy way to use the Sentry SDK, we should create a wrapper named `SentryUtil`. 

The wrapper should contain methods, that meet our requirements described in the [design steps](#design):

- a `configureDefaultContexts` private method that configures default contextual data on the error event. It should add context about the current user `operation system`, and depending on running the application on the `web` or `mobile` - about the current user `browser` or `device`;
- an `initialize` method , that provides an easy way to [initialize the Sentry](#initializing-the-sentry) with an ability to [capture uncaught Dart and Flutter errors](#capturing-uncaught-flutter-and-dart-errors), set the DSN and release name;
- a `captureException` method, that delegates to the `Sentry` method described in the [Capturing exceptions](#capturing-exceptions) step;
- an `addContext` method, that delegates to the `Sentry` method described in the [Adding Contexts](#adding-contexts) step.


The following class diagram represents the classes required for Sentry integration: 

![Sentry class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/sentry_design/metrics/web/docs/features/sentry/diagrams/sentry_util_class_diagram.puml)

## Data Source Name (DSN)
The [DSN](https://docs.sentry.io/product/sentry-basics/dsn-explainer/) tells the SDK where to send the events. If this value is not provided, the SDK will try to read it from the `SENTRY_DSN` environment variable. If that variable also does not exist, the SDK will just not send any events.

The `DSN` is not a secret, worst thing someone could do is sending events to your account. If that ever happens you have a few options tackling this, you can either [block off certain request](https://docs.sentry.io/product/accounts/quotas/#inbound-data-filters) or cycle the `DSN`.

Despite on the previous step, we still should to improve our security in using the `DSN`, so we should build the Flutter app providing the `DNS` enviroment variable.

```bash
export SENTRY_DSN=`your_dsn_here`
flutter build web --dart-define=SENTRY_DSN=$SENTRY_DSN
```

Then in the app code we can take the `DSN` using `String.fromEnviroment()` method.

```dart
const dsn = const String.fromEnvironment('SENTRY_DSN');
```



## Minifying and update the source map

Due to flutter minifying, the release app errors are not readable in the Sentry. To resolve the problem you should [update the js sourcemaps](https://docs.sentry.io/platforms/javascript/sourcemaps). 

To get it work in the `Dart` we should build the Flutter app providing the `release name` and updating the source maps.

```bash
export SENTRY_RELEASE=release-name
flutter build web --dart-define=SENTRY_RELEASE=$SENTRY_RELEASE

# Upload source maps
sentry-cli releases new $SENTRY_RELEASE

sentry-cli releases files $SENTRY_RELEASE upload-sourcemaps . \
    --ext dart \
    --rewrite

cd ./build/web/
sentry-cli releases files $SENTRY_RELEASE upload-sourcemaps . \
    --ext map \
    --ext js \
    --rewrite

sentry-cli releases finalize $SENTRY_RELEASE
```

Then in the app code, we should take the `release name` using `String.fromEnviroment()` method.

```dart
const release = const String.fromEnvironment('SENTRY_RELEASE');
```
## Testing
??
## Results
> What was the outcome of the project?

The document describing the integration of the Sentry into the Metrics Web Application.
