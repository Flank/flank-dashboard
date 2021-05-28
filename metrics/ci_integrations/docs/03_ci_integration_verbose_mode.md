# CI Integrations Verbose Mode

## TL;DR

Introducing a `verbose mode` for the [`CI Integrations`](https://github.com/Flank/flank-dashboard/tree/master/metrics/ci_integrations) tool. Running the `CI Integrations` tool in the `verbose mode` gives more context and provides additional details on what's going on during the tool running.

## References
> Link to supporting documentation, GitHub tickets, etc.

- [CI Integrations Tool Architecture](https://github.com/Flank/flank-dashboard/blob/master/metrics/ci_integrations/docs/01_ci_integration_module_architecture.md)

## Goals
> Identify success metrics and measurable goals.

This document meets the following goals: 
- Create a clear design of the CI Integrations Logger and verbose mode.
- Provide an overview of steps the new Logger implementation requires.

## Design
> Explain and diagram the technical design.

The following sequence diagram describes the process of displaying logs depends on the given `verbose` option:

![Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/master/metrics/ci_integrations/docs/diagrams/ci_integrations_verbose_mode_diagram.puml)

## API
> What will the proposed API look like?

This section provides verbose mode implementation details. Also, it defines the changes in the existing codebase needed to introduce the verbose mode.

### CI Integration Logger

To make logging actions easily, we need to update the existing `Logger` to have only static methods. It allows us to use the `Logger` class in different parts of the `CI Integrations` tool with no need to pass the `Logger` instance through the whole application.

Let's review methods the `Logger` should provide:

 - `setup` - method needed to set up the `Logger`. This method sets up a logger with `messageSink`, `errorSink` and `verbose` flag. _**Please, note: This method must be called before using any other methods of this Logger**_
 - `logError` - logs the given error to the error sink.
 - `logMessage` - logs the given message to the message sink.
 - `logInfo` - logs the given message with a timestamp to the output sink, if the `verbose mode` is enabled.

So, to use the `Logger` class we should configure it like the following:

```dart
Logger.setup(...);
```

And then we can use the `Logger` to log any messages in the application. See example:

```dart
Logger.logMessage('message');
```

### CI Integrations verbose mode

To allow enabling and disabling verbose logging, we should provide a `--verbose` flag. To make it available for any command of the `CI Integrations` CLI, we should specify this flag on the very top-level of the CLI - the `CiIntegrationsRunner` class:

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

As we have mentioned above, after we have finished with the `Logger` initialization, we can use the `Logger` class in any place of our application. 

The following examples show the usage of the `Logger`: 

```dart
Logger.logInfo('Parsing the given config file...');
final rawConfig = parseConfigFileContent(file);
```

```dart
Logger.logInfo('Sign in to the Firestore...');
await auth.signIn(...)
```
