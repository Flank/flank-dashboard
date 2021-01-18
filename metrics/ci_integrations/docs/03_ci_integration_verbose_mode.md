# CI Integrations Verbose Mode

## TL;DR

Introducing a `verbose mode` for the [`CI Integrations`](https://github.com/platform-platform/monorepo/tree/master/metrics/ci_integrations) tool. Running the `CI Integrations` tool in the `verbose mode` gives more context and provides additional details of what it's doing while working.

## References
> Link to supporting documentation, GitHub tickets, etc.

- [CI Integrations Tool Architecture](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/01_ci_integration_module_architecture.md)

## Goals
> Identify success metrics and measurable goals.

- A clear design of the CI Integrations verbose mode.
- An overview of steps the verbose mode implementation requires.

## Design
> Explain and diagram the technical design.

The following section provides an implementation of the `verbose mode` and changes that need to do to the existing `CI Integrations` codebase.

Here is a list of changes we should provide:
1. [Change the existing Logger class](#change-the-logger).
2. [Remove accepting the Logger instance](#remove-accepting-the-logger-instance).
3. [Replace logging messages and errors](#replace-logging-messages-and-errors).
4. [Add verbose option](#add-verbose-option).
5. [Setup the Logger](#setup-logger).
6. [Logging actions](#logging-actions).

### Change the Logger

To make logging actions easily, we need to convert the existing `Logger` class to the class with static methods. It allows us to show logs in different parts of the `CI Integrations` tool without the need to accept the logger instance in every class, that wants to log actions.

Here is an example of how the `Logger` class should look:

```
class Logger {
  static IOSink _errorSink = stderr;

  static IOSink _messageSink = stdout;

  static bool _verbose = false;

  static void setup({
    IOSink errorSink,
    IOSink messageSink,
    bool verbose,
  }) {
    _errorSink = errorSink ?? stderr;
    _messageSink = messageSink ?? stdout;
    _verbose = verbose ?? false;
  }

  static void printError(Object error) => _errorSink.writeln(error);

  static void printMessage(Object message) => _messageSink.writeln(message);

  static void printLog(Object message) {
    if (_verbose) _messageSink.writeln("[${DateTime.now()}] $message");
  }
}
```

The `Logger.setup()` method can accept the `verbose` parameter and print logs depends on its value through the new `Logger.printLog()` method.

In addition, the `setup` method also accepts the `errorSink` and `messageSink` as it accepts earlier in the constructor.

Other methods stay as it is, but now, they are all static.

### Remove accepting the Logger instance

As we converted methods of the `Logger` to the static ones, we should remove accepting the `Logger` instance from the following classes:
- `CiIntegrationsRunner`
- `CiIntegrationCommand`
- `SyncCommand`

### Replace logging messages and errors

We should replace the existing call to the `logger.printMessage()` and `logger.printError()` methods with the static analogs.

Here is an example:

```
try {
    await runner.run(arguments);
    exit(0);
  } catch (error) {
    Logger.printError(error); // old was the logger.printError(error)
    exit(1);
  }
}
```

### Add verbose option

To log actions depends on the given `verbose` value, we should add the `verbose` option in the `CiIntegrationsRunner` constructor before command registrations to make the option global.

Here is an example:

```
CiIntegrationsRunner(...) {
    argParser.addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Noisy logging, including all shell commands executed.',
    );

    addCommand(SyncCommand());
}
```

### Setup logger

After the `verbose` is registered we should configure the `Logger` to accept the `verbose` option's value.

We can make it in the `run` method of the `CiIntegrationsRunner`:

```
@override
Future run(Iterable<String> args) {
  final result = argParser.parse(args);
  final verbose = result['verbose'] as bool;

  Logger.setup(verbose: verbose);

  return super.run(args);
}
```

### Logging actions

To log actions we should use the `Logger.printLog()` method with the message, we want to display to the output.

Here is an example:

```
Logger.printLog('Parsing the given config file...');
final rawConfig = parseConfigFileContent(file);

// or

Logger.printLog('Sign in to the Firestore...');
await auth.signIn(...)
```

## Making Things Work

![Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/master/metrics/ci_integrations/docs/diagrams/ci_integrations_verbose_mode_diagram.puml)
