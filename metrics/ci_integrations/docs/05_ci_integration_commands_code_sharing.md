# CI Integration Commands Code Sharing

## Motivation
> What problem is this project solving?

The implementation of the `ci_integrations` commands may require the same functionality currently contained in the `SyncCommand`, such as:
- Reading the configuration from the file.
- Parsing the `RawIntegrationConfig` from the config file content.
- Selecting the `IntegrationParty` that accepts the given source and the destination config.
- Parsing the source or the destination config to the party-specific `Config` instance.

So, the motivation of this document is to describe the code sharing between the commands.

## Goals
> Identify success metrics and measurable goals.

This document aims the goal to describe:
- [Config file reading code sharing](#configuration-file-reading).
- [`RawIntegrationConfig` parsing code sharing](#rawintegrationconfig-parsing).
- [Sharing the code of selecting the `IntegrationParty` depending on the provided configuration](#selecting-the-integrationparty).
- [Integration-specific `Config` parsing code sharing](#integration-specific-config-parsing).

## Proposed Change

### Configuration File Reading

First, we need to share the code that helps us to read the configuration file contents by the provided configuration file path.

To do that, we need to implement the following classes:

1. A `FileHelper` that provides the `File` by the given file path.
2. A `FileReader` class that reads the `File` contents by the given file path. The `FileHelper` needs to be into it for testing purposes.

### RawIntegrationConfig parsing

A `RawIntegrationConfig` is a class that stores the source, and the destination config map. 

To create the `RawIntegrationConfig`, let's create a `RawIntegrationConfigFactory` that creates the `RawIntegrationConfig` by the provided config file path.
To keep this class testable, we need to inject a `FileReader`, and a `RawIntegrationConfigParser` into it.

Now, to create a `RawIntegrationConfig`, we just need to create a `RawIntegrationConfigFactory` and call its `.create(configFilePath)` method.

### Selecting the `IntegrationParty`

Now, when we've parsed the source, and the destination config map, we need to select the right `IntegrationParty`s that accept these configs.

Consider the following steps needed to do that:

1. Add an `acceptsConfig(Map<String, dynamic> configMap)` method to the `IntegrationParty` class, that returns `true`, if this integration party can use this config, and `false` otherwise.
2. Add a `getParty(Map<String, dynamic> configMap)` method to the `Parties` abstract class. This method returns an `IntegrationParty` that can use this config or throws an `UnimplementedError` if the party that accepts the given config is not found.

Now, just call the `Parties.getParty(configMap)` method to select the right `IntegrationParty` that accepts the given config.

### Integration-specific `Config` parsing

A `Config` is an `IntegrationParty`-specific config, that can be used by the `ConfigValidator`, or `IntegrationClientFactory` classes.

First, let's create a `ConfiguredParty` class. This class stores the parsed `Config` and an `IntegrationParty` that accepts this config. As we need the source and the destination `ConfiguredParty`, let's create a `ConfiguredParties` class that stores the `ConfiguredSourceParty` and the `ConfiguredDestinationParty`.

After we've implemented the base classes, it's time to implement a `ConfiguredPartiesFactory` that shares the `Config` parsing and `IntegrationParty` selection code.

Consider the following steps needed to do that:

1. Create a `ConfiguredParty` that holds the `IntegrationParty` and the `Config` this party accepts. Create `ConfiguredSourceParty` and `ConfiguredDestinationParty` that extend the `ConfiguredParty` abstract class.
2. Create a `ConfiguredParties` class that holds source and destination configured parties.
3. Create a `ConfiguredPartiesFactory` class that creates the `ConfiguredParties` from the `RawIntegrationConfig` and the `SupportedIntegrationParties`.

Now, we can use this factory to create the `ConfiguredSourceParties` and access the source, and the destination `IntegrationParty` and its specific `Config`.

## Approaches Comparison

Consider the following code snippets that show how the proposed changes may simplify the codebase, assuming that the desired code goal is to get the source and destination `IntegrationParties` and parse their specific `Config`s.

### Before

```dart
  @override
  Future<void> run() async {
    final configFilePath = getArgumentValue(_configFileOptionName) as String;
    final file = getConfigFile(configFilePath);

    if (file.existsSync()) {
      logger.info('Parsing the given config file...');
      final rawConfig = parseConfigFileContent(file);
  
      logger.info('Creating integration parties...');
      final sourceParty = getParty(
        rawConfig.sourceConfigMap,
        supportedParties.sourceParties,
      );
      final destinationParty = getParty(
        rawConfig.destinationConfigMap,
        supportedParties.destinationParties,
      );
  
      logger.info('Creating source configs...');
      final sourceConfig = parseConfig(
        rawConfig.sourceConfigMap,
        sourceParty,
      );
      final destinationConfig = parseConfig(
        rawConfig.destinationConfigMap,
        destinationParty,
      );
      // specific logic here
    }
  }

  File getConfigFile(String configFilePath) {
    return File(configFilePath);
  }

  RawIntegrationConfig parseConfigFileContent(File file) {
    final content = file.readAsStringSync();
    return _rawConfigParser.parse(content);
  }

  T getParty<T extends IntegrationParty>(
    Map<String, dynamic> configMap,
    Parties<T> supportedParties,
  ) {
    final party = supportedParties.parties.firstWhere(
      (party) => party.configParser.canParse(configMap),
      orElse: () => null,
    );

    if (party == null) {
      throw UnimplementedError('The given source config is unknown');
    }

    logger.info('$party was created.');

    return party;
  }

  T parseConfig<T extends Config>(
    Map<String, dynamic> configMap,
    IntegrationParty<T, IntegrationClient> party,
  ) {
    final config = party.configParser.parse(configMap);
    logger.info('$config was created.');

    return config;
  }
```

### After

```dart
  CoolCommand({
    this.rawIntegrationConfigFactory,
    this.configuredPartiesFactory,
  });

  @override
  Future<void> run() async {
    final configFilePath = getArgumentValue('config-file-path') as String;
    
    final rawIntegrationConfig = rawIntegrationConfigFactory.create(configFilePath);
    
    final configuredParties = configuredPartiesFactory.create(rawIntegrationConfig);
    
    final configuredSourceParty = configuredParties.configuredSourceParty;
    final configuredDestinationParty = configuredParties.configuredDestinationParty;
    
    final sourceParty = configuredSourceParty.party;
    final sourceConfig = configuredSourceParty.config;
    // specific logic here
    
    final destinationParty = configuredDestinationParty.party;
    final destinationConfig = configuredDestinationParty.config;
    // specific logic here
  }
```

## General Class Diagram

Consider the following class diagram that describes the required classes and interfaces used to share the code between commands:

![Class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/ci_integrations/docs/diagrams/commands_code_sharing.puml)
