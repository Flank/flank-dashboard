# Sentry design

## TL;DR

Introducing Sentry into the Metrics Web Application allows us to track errors that occurred within the application. Then, using Sentry logs we can identify errors and fix them. This integration simplifies maintenance of the Metrics Web Application and increases the velocity of bug fixing.

## References
> Link to supporting documentation, GitHub tickets, etc.

* [Sentry Dart documentation](https://docs.sentry.io/platforms/dart/)
* [Sentry SDK](https://pub.dev/packages/sentry)

## Goals
> Identify success metrics and measurable goals.

* A clear design of the Sentry integration.
* A review of additional steps the Sentry integration requires.

## Design
> Explain and diagram the technical design.

The following sections provide an implementation of Sentry integration into the Metrics Web Application. 
As Sentry is used for tracking errors, we can avoid implementing different layers to make Sentry using more clear and simple. 
Instead, we should think about Sentry as a logger and provide a utility class that would simplify working with Sentry.

Here is a list of functionality points we should provide to the utility class working with Sentry:
- initializing Sentry SDK;
- capturing errors;
- adding contexts.

Let's proceed to the below sections that cover the implementation points.

### Initializing Sentry

The very first step is to initialize Sentry. Its SDK requires the DSN ([Data Source Name](#data-source-name)) to be set. 
Also, for the web applications, we are to set the [release](https://docs.sentry.io/platforms/flutter/configuration/releases/) to make Sentry know what version of the app caused the error. 
Consider the following code:

```dart
await Sentry.init((options) => options
 ..dsn = 'https://example@sentry.io/add-your-dsn-here'
 ..release = 'your-app-version',
);
```

About how to automate DSN and release binding, consider the [Sentry Options Binding](#sentry-options-binding) section.

### Capturing errors

To manually capture the error using Sentry, we should call the appropriate method that Sentry SDK provides. The [`Sentry.captureException`](https://pub.dev/documentation/sentry/latest/sentry/Sentry/captureException.html) method takes the exception and its optionally stack trace and reports to the `Sentry.io`. Consider the following example:

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

We can also configure the application to capture uncaught errors both of Flutter and Dart. Consider the following options to capture uncaught Dart errors:
- Pass the app runner callback to the [`Sentry.init`](https://pub.dev/documentation/sentry/latest/sentry/Sentry/init.html) method as the `appRunner` parameter. Sentry then runs your application within a [guarded zone](https://api.dart.dev/stable/2.10.4/dart-async/runZonedGuarded.html).
- Run the app within your own guarded zone providing the `onError` callback that would `Sentry.captureException`.

The main idea is using zones as they establish an execution context for the code. This provides a convenient way to capture all errors that occur within that context.

To capture uncaught Flutter errors, we should override the [`FlutterError.onError`](https://api.flutter.dev/flutter/foundation/FlutterError/onError.html) property. Then we can either `Sentry.captureException` or send an error to the zone error handler defined. Here are examples for both cases respectively: 
- Capture exception within the `onError` handler.

```dart
FlutterError.onError = (details, {bool forceReport = false}) {
    Sentry.captureException(details.exception, stackTrace: details.stack);
};
```

- Send exception to the zone handler.

```dart
FlutterError.onError = (details, {bool forceReport = false}) {
    Zone.current.handleUncaughtError(details.exception, details.stack);
};
```

Once we know how to capture exceptions, it's time to discover how to provide Sentry with an app execution context.

### Adding Contexts

Contexts allow you to attach arbitrary data to an event you report to Sentry. These could be anything useful data that can help identify an error as they are actually the contexts of this error. For example, the contexts could be browser data with version, device information, etc. To add contexts, you should use the [`Sentry.configureScope`](https://pub.dev/documentation/sentry/latest/sentry/Sentry/configureScope.html) method. For example:

```dart
final projectName = {'name' : 'test'};
Sentry.configureScope((scope) => scope.setContexts('project', projectName));
```

The Sentry SDK provides several specific classes to facilitate adding a [common context](https://develop.sentry.dev/sdk/event-payloads/contexts/):
- `App` class with application-related information.
- `Browser` class with browser-related information.
- `Device` class with device-related information.
- `OperationSystem` class with OS-related information.
- `GPU` class with GPU-related information.
- `Runtime` class with runtime-related information.

Consider an example of using the `Browser` class to set the browser common context:

```dart
final browser = Browser(name: 'chrome', version: '87.0.4280.88');
Sentry.configureScope((scope) => scope.setContexts(Browser.type, browser));
```

## Sentry Util

To simplify working with Sentry SDK, we are to implement a utility class that would wrap Sentry calling. This wrapper has to contain methods that meet the requirements described in the [Design section](#design). Here is a list of these methods:
- a `configureDefaultContexts` method that configures default contextual data on the error event. This method adds all common contexts as user's `operation system`, `browser` information, and so on;
- an `initialize` method that simplifies [initializing the Sentry](#initializing-the-sentry) process;
- a `captureException` method that delegates to the `Sentry` capture exceptions;
- an `addContext` method that simplifies adding contexts to the `Sentry`.

The following class diagram describes the structure of Sentry integration:

![Sentry class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/sentry_design/metrics/web/docs/features/sentry/diagrams/sentry_util_class_diagram.puml)

## Sentry Options Binding

The following subsections describe how to bind `DSN` and `release` options to the Sentry SDK using your build environment.

### Data Source Name (DSN)

The [DSN](https://docs.sentry.io/product/sentry-basics/dsn-explainer/) tells the SDK where to send the events. If this value is not provided, the SDK will try to read it from the `SENTRY_DSN` environment variable. If that variable also does not exist, the SDK will just not send any events.

The `DSN` can be public as it does not contain any secret data. Despite this fact, someone can use it to send events to your project. There are a few options to tackle this:
- block off certain requests using [inbound data filters](https://docs.sentry.io/product/accounts/quotas/#inbound-data-filters);
- secure your `DSN`.

Let's focus on how to secure your `DNS` and prevent someone from using it. The main idea is to use the `SENTRY_DSN` environment variable while building your app. Consider the following example:

```bash
export SENTRY_DSN=`your_dsn_here`
flutter build web --dart-define=SENTRY_DSN=$SENTRY_DSN
```

Then within the application, you can access the variable value using the [`String.fromEnviroment`](https://api.dart.dev/stable/2.10.4/dart-core/String/String.fromEnvironment.html) method:

```dart
const sentryDsn = String.fromEnvironment('SENTRY_DSN');
```

### Release

A release is a version of your code that is deployed to an environment. Specifying the release version gives the following opportunities:
- determine issues and regressions introduced in a new release;
- predict which commit caused an issue and who is likely responsible;
- resolve issues by including the issue number in your commit message;
- receive email notifications when your code gets deployed.

The release is commonly a git SHA or a custom version number, it's also followed the listed limitations:
- can't contain newlines or spaces;
- can't use a forward slash (/), back slash (\), period (.), or double period (..);
- can't exceed 200 characters.

The best practice to set up the release is to set up the environment variable during the build process, which gives the ability to initialize it depending on the other build environment variables like build number and so on. 
Consider the following example: 

```bash
export SENTRY_RELEASE=`your_release_here`
flutter build web --dart-define=SENTRY_RELEASE=$SENTRY_RELEASE
```

Then within the application, you can access the variable value using the [`String.fromEnviroment`](https://api.dart.dev/stable/2.10.4/dart-core/String/String.fromEnvironment.html) method:

```dart
const release = const String.fromEnvironment('SENTRY_RELEASE');
```

## Updating Source Maps

Flutter minifies JavaScript code building the web application. This makes applications faster but also results in not readable errors and their stack traces. To resolve this problem we should [update the JS sourcemaps](https://docs.sentry.io/platforms/javascript/sourcemaps) each time we build a new application release.

Updating source maps requires the [`Sentry CLI`](https://docs.sentry.io/product/cli/) to be installed. Also, it requires the [release binding](#release) described in the previous section. Consider the following example:

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

## Testing

The Sentry should be tested using a [mockito](https://pub.dev/packages/mockito) package, which allows replacing a [`SentryClient`](https://pub.dev/documentation/sentry/latest/sentry/SentryClient-class.html) with a mock one using a [`Sentry.bindClient()`](https://pub.dev/documentation/sentry/latest/sentry/Sentry/bindClient.html) method. 
Also, the approaches discussed in [3rd-party API testing](https://github.com/platform-platform/monorepo/blob/master/docs/03_third_party_api_testing.md) and [here](https://github.com/platform-platform/monorepo/blob/master/docs/04_mock_server.md) should be used testing a Sentry client direct HTTP calls. 

## Results
> What was the outcome of the project?

The document describing the integration of the Sentry into the Metrics Web Application.
