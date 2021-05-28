# Metrics Logger Design

## TL;DR

Introducing Metrics Logger into the Metrics Web Application allows us to track errors that occurred within the application. Then, using logs we can identify errors and fix them. This integration simplifies maintenance of the Metrics Web Application and increases the velocity of bug fixing.

## References
> Link to supporting documentation, GitHub tickets, etc.

* [Sentry Dart documentation](https://docs.sentry.io/platforms/dart/)
* [Sentry SDK](https://pub.dev/packages/sentry)

## Goals
> Identify success metrics and measurable goals.

* A clear design of the Metrics Logger integration.
* An overview of logger integration into the application. 
* An overview of additional steps the Sentry integration requires.

## Design
> Explain and diagram the technical design.

The following sections provide an implementation of Metrics Logger integration into the Metrics Web Application. As Metrics Logger is used for tracking errors, we can avoid implementing different layers to make using this logger more clear and simple.

Here is a list of functionality points we should provide to the Metrics Logger class:
- initializing logger;
- logging errors;
- adding contexts.

Let's take a look on the classes the Metrics Logger integration requires. But first, the next section provides you with definitions the further text uses.

### Glossary

The next table lists the definitions used in the scope of Metrics Logger integration design.

| Term | Description |
| --- | --- |
| **context** | Contexts allow you to attach arbitrary data to an error you report. They could be anything useful data that can help identify an error as they are actually the contexts of this error. | 
| **logs output** | Is the destination point for logs. This can be a persistent storage, tool that manages logs, file, or even a console. |

### LoggerWriter

The `LoggerWriter` is an interface that provides methods for writing captured errors and their context. The writer is used to report captured errors to the logs output and save them. Generally speaking, the writer is a bridge between the [Metrics Logger](#metricslogger) within the application and logs output the concrete writer uses.

### MetricsLogger

The `MetricsLogger` is a main part of the logger integration. The application uses `MetricsLogger` to log errors and their contexts. The logger then uses the [`LoggerWriter`](#loggerwriter) to report these errors. This class provides only static methods to simplify the logging process. However, it must be initialized with the writer using the `initialize` method before logging errors.

The following class diagram demonstrates the structure of the logger integration and the relationships of classes this integration requires.

![Metrics Logger class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/metrics_logger/diagrams/metrics_logger_class_diagram.puml)

### Making Things Work

The main idea of the `Metrics Logger` integration is to initialize it with the `LoggerWriter` implementation you want to use to report errors. Also, you can initialize the logger with default contexts. Collect the desired contexts into one map and pass it as the parameter of the initialize method.

The following sequence diagram describes the process of `Metrics Logger` initializing with the `CoolLoggerWriter` implementation:

![Metrics Logger init sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/metrics_logger/diagrams/metrics_logger_initialize_sequence_diagram.puml)

And the following sequence diagram describes the logging process:

![Metrics Logger log sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/metrics_logger/diagrams/metrics_logger_log_error_sequence_diagram.puml)

To know more about the concrete writer integration, consider the [Sentry Integration](#sentry-integration) section.

### Capturing Errors 

Once you have initialized the Metrics Logger, you can manually capture an error using the `MetricsLogger.logError` method that takes an error and its optionally stacktrace as parameters. For example, logging an error in `try-catch` block looks as follows: 

```dart
try {
  aMethodThatMightFail();
} catch (exception, stackTrace) {
  await MetricsLogger.logError(
    exception,
    stackTrace: stackTrace,
  );
}
```

We can also configure the application to capture uncaught errors both of Flutter and Dart. The main idea is using zones as they establish an execution context for the code. This provides a convenient way to capture all errors that occur within that context. So, running the application within a [guarded zone](https://api.dart.dev/stable/2.10.4/dart-async/runZonedGuarded.html) allows us to set an error listener for this zone that would log all uncaught errors. Consider the following code as an example: 

```dart
  runZonedGuarded(() {
    // run your app here
    runApp(MetricsApp());
  }, (Object error, StackTrace stackTrace) {
    MetricsLogger.logError(error, stackTrace);
  });
```

To capture uncaught Flutter errors, we should override the [`FlutterError.onError`](https://api.flutter.dev/flutter/foundation/FlutterError/onError.html) property. Then we can either `MetricsLogger.logError` or send an error to the zone error handler defined. Here are examples for both cases respectively: 
- Capture exception within the `onError` handler.

```dart
FlutterError.onError = (details, {bool forceReport = false}) {
    MetricsLogger.logError(details.exception, stackTrace: details.stack);
};
```

- Send exception to the zone handler.

```dart
FlutterError.onError = (details, {bool forceReport = false}) {
    Zone.current.handleUncaughtError(details.exception, details.stack);
};
```

### Notes To Error Capturing

If you're setting up the `MetricsLogger` in your `main` function, overriding the `FlutterError.onError` property requires calling the [`WidgetsFlutterBinding.ensureInitialized`](https://api.flutter.dev/flutter/widgets/WidgetsFlutterBinding/ensureInitialized.html) method before. Moreover, in case of using guarded zone, move the `WidgetsFlutterBinding.ensureInitialized` method and related features into zone callback.

For example, the following code is incorrect as `FlutterError.onError` is set without `WidgetsFlutterBinding.ensureInitialized`:

```dart
Future<void> main() async {
  // MetricsLogger initialization goes here

  FlutterError.onError = (details, {bool forceReport = false}) {
    MetricsLogger.logError(details.exception, stackTrace: details.stack);
  };

  // run the app here
}
```

The following example is a complete example of setting up Dart & Flutter uncaught errors capturing:

```dart
Future<void> main() async {
  // MetricsLogger initialization goes here

  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();  

      FlutterError.onError = (details, {bool forceReport = false}) {
        Zone.current.handleUncaughtError(details.exception, details.stack);
      };
      
      // run the app here
    },
    (Object error, StackTrace stackTrace) {
      MetricsLogger.logError(error, stackTrace: stackTrace);
    }
  );
}
```

## Sentry Integration

To integrate Sentry logging to the application we should implement the `LoggerWriter` using the [Sentry SDK](https://pub.dev/packages/sentry).

### Initializing Sentry

Instead of the usual constructor, the desired writer provides the static `init` method. The reason is that the Sentry initialization is asynchronous and we must ensure the writer is ready to use before passing it to the `MetricsLogger`.

The Sentry SDK requires the DSN ([Data Source Name](#data-source-name)) to be set. Also, for the web applications, we are to set the [release](https://docs.sentry.io/platforms/flutter/configuration/releases/) to make Sentry know what version of the app caused the error. Consider the following code:

```dart
await Sentry.init((options) => options
 ..dsn = 'https://example@sentry.io/add-your-dsn-here'
 ..release = 'your-app-version',
);
```

About how to automate DSN and release binding, consider the [Sentry Options Binding](#sentry-options-binding) section.

### Processing Sentry Events

Sentry provides an API for processing their events before send it to the remote. This is called `event processor` and acts as a middleware for all events. Processor consumes the event to process and returns the event to send. This allows managing data for events (removing redundant information, adding request headers, etc.) and filtering events.

To set custom event processor, one should use the optional `eventProcessor` argument of the static `init` method. This argument consumes instance of the implementor of the `SentryEventProcessor` callable class. The `init` method then passes the given processor to the Sentry options as follows:

```dart
await Sentry.init((options) {
  // DSN and release initialization
  options.addEventProcessor(eventProcessor);
});
```

_**Note**: If the event processor results with `null` for the given event, this event won't be sent to Sentry._

### Creating Sentry Writer

The `SentryWriter` is the implementation of the `LoggerWriter` that uses the [Sentry SDK](https://pub.dev/packages/sentry). This writer reports the captured errors to the Sentry.io together with the given contexts.

The main idea is to use the [`Sentry.captureException`](https://pub.dev/documentation/sentry/latest/sentry/Sentry/captureException.html) and [`Sentry.configureScope`](https://pub.dev/documentation/sentry/latest/sentry/Sentry/configureScope.html) methods within the `SentryWriter.writeError` and `SentryWriter.setContext` respectively. For example, the following code sends the error to Sentry:

```dart
await Sentry.captureException(
  exception,
  stackTrace: stackTrace,
);
```

And the following one, sets the custom context for a project name:

```dart
final projectName = {'name' : 'test'};
Sentry.configureScope((scope) => scope.setContexts('project', projectName));
```

The Sentry SDK provides several specific classes to facilitate adding a [common contexts](https://develop.sentry.dev/sdk/event-payloads/contexts/):
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

_**Note**: Using the above classes to set the contexts with the same key is required. For example, Sentry fails setting a context by key `browser` if the given value is not of the `Browser` type._

The following class diagram demonstrates the complete structure of the Metrics Logger that uses the `SentryWriter`:

![Complete Metrics Logger class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/metrics_logger/diagrams/metrics_logger_sentry_class_diagram.puml)

### Sentry Options Binding

The following subsections describe how to bind `DSN` and `release` options to the Sentry SDK using your build environment.

_**Note**: The next sections operate environment variables and pass them to the `flutter build` command. This is required to use the `--dart-define` option to pass the environment variable. Otherwise, it won't be available in the application code._

#### Data Source Name (DSN)

The [DSN](https://docs.sentry.io/product/sentry-basics/dsn-explainer/) tells the SDK where to send the events. If this value is not provided, the SDK will try to read it from the `SENTRY_DSN` environment variable. If that variable also does not exist, the SDK will just not send any events.

The `DSN` can be public as it does not contain any secret data. Despite this fact, someone can use it to send events to your project. To tackle this you can block off certain requests using [inbound data filters](https://docs.sentry.io/product/accounts/quotas/#inbound-data-filters).

Let's focus on how to bind your `DSN` to the Sentry SDK. The main idea is to use the `SENTRY_DSN` environment variable while building your app. You should pass it to the `flutter build` command using the `--dart-define` option with argument that stands for environment variable. For example, consider the following code:

```bash
# Declare the SENTRY_DSN variable

flutter build web --dart-define=SENTRY_DSN=$SENTRY_DSN
```

Then, within the application, you can access the variable value using the [`String.fromEnvironment`](https://api.dart.dev/stable/2.10.4/dart-core/String/String.fromEnvironment.html) method:

```dart
const sentryDsn = String.fromEnvironment('SENTRY_DSN');
```

#### Release

A release is a version of your code that is deployed to an environment. Specifying the release version gives the following opportunities:
- determine issues and regressions introduced in a new release;
- predict which commit caused an issue and who is likely responsible;
- resolve issues by including the issue number in your commit message;
- receive email notifications when your code gets deployed;
- manage code source maps to make errors and their stack traces more readable.

The release is commonly a git SHA or a custom version number, it also must follow the listed limitations:
- can't contain newlines or spaces;
- can't use a forward slash (/), backslash (\\), period (.), or double period (..);
- can't exceed 200 characters.

The best practice to set up the release is to set up the environment variable during the build process, which gives the ability to initialize it depending on the other build environment variables like build number and so on. Then, you should pass the resulting variable value to the `flutter build` command using the `--dart-define` option with arguments that stand for the desired environment variable. Consider the following example: 

```bash
# Declare the SENTRY_RELEASE variable

flutter build web --dart-define=SENTRY_RELEASE=$SENTRY_RELEASE
```

Then within the application, you can access the variable value using the [`String.fromEnvironment`](https://api.dart.dev/stable/2.10.4/dart-core/String/String.fromEnvironment.html) method:

```dart
const release = const String.fromEnvironment('SENTRY_RELEASE');
```

### Updating Source Maps

Flutter minifies JavaScript code building the web application. This makes applications faster but also results in not readable errors and their stack traces. To resolve this problem we should [update the JS sourcemaps](https://docs.sentry.io/platforms/javascript/sourcemaps) each time we build a new application release.

Updating source maps requires the [`Sentry CLI`](https://docs.sentry.io/product/cli/) to be installed and [configured](https://docs.sentry.io/product/cli/configuration/) (the organization slug, project and auth token configurations are required). Also, it requires the [release binding](#release) described in the previous section. Finally, we should pass the `--source-maps` flag to the `flutter build web` command to indicate that we need source maps to be generated. Consider the following example:

```bash
# Declare the SENTRY_RELEASE variable

flutter build web --source-maps --dart-define=SENTRY_RELEASE=$SENTRY_RELEASE

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

To test the `MetricsLogger` class we should inject the `LoggerWriter` test implementation. The best approach is using a [mockito](https://pub.dev/packages/mockito) package and mock the writer class to inject.

The main idea in testing Sentry integration is to use the [`Sentry.bindClient`](https://pub.dev/documentation/sentry/latest/sentry/Sentry/bindClient.html) method and bind a test client to use in test cases. 

As Sentry is a third-party integration it should be tested using the [third-party API testing](https://github.com/Flank/flank-dashboard/blob/master/docs/03_third_party_api_testing.md) approach that uses the [mock server](https://github.com/Flank/flank-dashboard/blob/master/docs/04_mock_server.md). It is possible to mock the client using a [mockito](https://pub.dev/packages/mockito) package as well.

## Results
> What was the outcome of the project?

The document describing the integration of the Sentry into the Metrics Web Application.
