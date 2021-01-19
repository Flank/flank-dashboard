# CI Integrations Verbose Mode

## TL;DR

Introducing a `verbose mode` for the [`CI Integrations`](https://github.com/platform-platform/monorepo/tree/master/metrics/ci_integrations) tool. Running the `CI Integrations` tool in the `verbose mode` gives more context and provides additional details on what's going on during the tool running.

## References
> Link to supporting documentation, GitHub tickets, etc.

- [CI Integrations Tool Architecture](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/01_ci_integration_module_architecture.md)

## Goals
> Identify success metrics and measurable goals.

This document meets the following goals: 
- A clear design of the CI Integrations Logger and verbose mode.
- An overview of steps the new Logger implementation requires.

## Design
> Explain and diagram the technical design.

The following sequence diagram describes the process of displaying logs depends on the given `verbose` option:

![Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/ci_integration_verbose_design/metrics/ci_integrations/docs/diagrams/ci_integrations_verbose_mode_diagram.puml)

## API
> What will the proposed API look like?

This section provides verbose mode implementation details. Also, it defines the changes in the existing codebase needed to introduce the verbose mode.

Here is a list of changes we should provide:
1. [CI Integration Logger](#ci-integration-logger).
2. [CI Integrations verbose mode](#ci-integrations-verbose-mode).
3. [Making things work](#making-things-work).
4. [Logging actions](#logging-actions).

### CI Integration Logger

To make logging actions easily, we need to update the existing `Logger` to have only static methods. It allows us to use the `Logger` class in different parts of the `CI Integrations` tool with no need to pass the `Logger` instance through the whole application.

Let's review methods the `Logger` should provide:

 - `setup` - responsible for initializing the Logger class.
 - `logError` - prints the given error.
 - `logMessage` - prints the given message.
 - `logInfo` - prints the given message, if the `verbose mode` is enabled.

The `Logger.setup()` method can accept the `verbose` parameter and print logs depends on its value through the new `Logger.logInfo()` method.

_**Note**: The `Logger.setup()` method should be called before calling any other `Logger` methods._

In addition, the `setup` method also accepts the `errorSink` and `messageSink` as it accepts earlier in the constructor.

Other methods stay as it is, but now, they are all static.

As we converted methods of the `Logger` to the static ones, we should remove the `Logger` parameter from the following class constructors:
- `CiIntegrationsRunner`
- `CiIntegrationCommand`
- `SyncCommand`

We should replace the existing call to the `logger.printMessage()` and `logger.printError()` methods with the `Logger.logMessage()` and `Logger.logError()`.

Here is an example:

```dart
if (result.isSuccess) {
  Logger.logMessage(result.message); // old was logger.printMessage(result.message)
} else {
  throw SyncError(message: result.message);
}
```

### CI Integrations verbose mode

To allow enabling and disabling verbose logging, we should provide an `--verbose` flag. To make it available for any command of the `CI Integrations` CLI, we should specify this flag on the very top-level of the CLI - the `CiIntegrationsRunner` class:

```dart
CiIntegrationsRunner(...) {
    argParser.addFlag(
      'verbose',
      abbr: 'v',
    );
    addCommand(SyncCommand());
}
```

### Making things work

Once we have a new implementation of the `Logger` and the `verbose` flag, we should configure the `Logger` to use it across the whole application.

The most suitable case to do so - the `run` method of the `CiIntegrationsRunner` class:

```dart
@override
Future run(Iterable<String> args) {
  final result = argParser.parse(args);
  final verbose = result['verbose'] as bool;

  Logger.setup(verbose: verbose);

  return super.run(args);
}
```

### Logging actions

When we've finished with the `Logger` initialization, we can use the `Logger` class in any place of our application. 

The following example shows the usage of the `Logger`: 

```dart
Logger.logInfo('Parsing the given config file...');
final rawConfig = parseConfigFileContent(file);

// or

Logger.logInfo('Sign in to the Firestore...');
await auth.signIn(...)
```
