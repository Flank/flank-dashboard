import 'dart:io';

import 'package:ci_integration/ci_integration/ci_integration.dart';
import 'package:ci_integration/ci_integration/command/sync_command.dart';
import 'package:ci_integration/ci_integration/parties/parties.dart';
import 'package:ci_integration/ci_integration/parties/supported_destination_parties.dart';
import 'package:ci_integration/ci_integration/parties/supported_integration_parties.dart';
import 'package:ci_integration/ci_integration/parties/supported_source_parties.dart';
import 'package:ci_integration/common/client/destination_client.dart';
import 'package:ci_integration/common/client/source_client.dart';
import 'package:ci_integration/common/logger/logger.dart';
import 'package:ci_integration/common/model/interaction_result.dart';
import 'package:ci_integration/common/party/destination_party.dart';
import 'package:ci_integration/common/party/source_party.dart';
import 'package:ci_integration/firestore/party/firestore_destination_party.dart';
import 'package:ci_integration/jenkins/party/jenkins_source_party.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_util/mock/mocks.dart';
import '../test_util/stub/stubs.dart';
import '../test_util/test_data/config_test_data.dart';

void main() {
  group(
    "SyncCommand",
    () {
      const configFileContent = ConfigTestData.configFileContent;
      final syncConfig = ConfigTestData.syncConfig;
      final integrationConfig = ConfigTestData.integrationConfig;

      final supportedSourceParties = SupportedSourceParties();
      final supportedDestinationParties = SupportedDestinationParties();

      final fileMock = FileMock();
      final ciIntegrationMock = _CiIntegrationMock();
      final sourceClientMock = SourceClientMock();
      final destinationClientMock = DestinationClientMock();
      final sourcePartiesMock = PartiesMock<SourceParty>();
      final destinationPartiesMock = PartiesMock<DestinationParty>();

      final loggerStub = LoggerStub();
      final syncCommand = SyncCommandStub(
        loggerStub,
        SupportedIntegrationParties(
          sourceParties: sourcePartiesMock,
          destinationParties: destinationPartiesMock,
        ),
        fileMock,
        ciIntegrationMock,
      );

      setUp(() {
        loggerStub.clearLogs();
        syncCommand.reset();
        reset(fileMock);
        reset(ciIntegrationMock);
        reset(sourceClientMock);
        reset(destinationClientMock);
        reset(sourcePartiesMock);
        reset(destinationPartiesMock);
      });

      PostExpectation<Future<InteractionResult>> whenRunSyncWithParties(
        Parties<SourceParty> sourceParties,
        Parties<DestinationParty> destinationParties,
      ) {
        when(sourcePartiesMock.parties).thenReturn(sourceParties.parties);
        when(destinationPartiesMock.parties)
            .thenReturn(destinationParties.parties);
        when(fileMock.existsSync()).thenReturn(true);
        when(fileMock.readAsStringSync()).thenReturn(configFileContent);
        return when(ciIntegrationMock.sync(syncConfig));
      }

      test("should have the 'config-file' option", () {
        final argParser = syncCommand.argParser;
        final options = argParser.options;

        expect(options, contains('config-file'));
      });

      test("should have the command name equal to 'sync'", () {
        final name = syncCommand.name;

        expect(name, equals('sync'));
      });

      test("should have a non-empty description", () {
        final description = syncCommand.description;

        expect(description, isNotEmpty);
      });

      test(
        ".parseConfigFileContent() should parse the config file content",
        () {
          final expected = integrationConfig;
          when(fileMock.readAsStringSync()).thenReturn(configFileContent);

          final result = syncCommand.parseConfigFileContent(fileMock);

          expect(result, equals(expected));
        },
      );

      test(
        ".getParty() should throw an UnimplementedError if the given parties are empty",
        () {
          when(sourcePartiesMock.parties).thenReturn([]);

          expect(
            () => syncCommand.getParty(
              integrationConfig.sourceConfigMap,
              sourcePartiesMock,
            ),
            throwsUnimplementedError,
          );
        },
      );

      test(
        ".getParty() should throw an UnimplementedError if the given parties do not contain an appropriate party",
        () {
          final parties = supportedDestinationParties;

          expect(
            () => syncCommand.getParty(
              integrationConfig.sourceConfigMap,
              parties,
            ),
            throwsUnimplementedError,
          );
        },
      );

      test(
        ".getParty() should return the appropriate party instance for the given config map",
        () {
          final parties = supportedSourceParties;

          final result = syncCommand.getParty(
            integrationConfig.sourceConfigMap,
            parties,
          );

          expect(result, isA<JenkinsSourceParty>());
        },
      );

      test(
        ".parseConfig() should return null if the given party cannot parse the given config",
        () {
          final party = JenkinsSourceParty();

          final result = syncCommand.parseConfig(
            integrationConfig.destinationConfigMap,
            party,
          );

          expect(result, isNull);
        },
      );

      test(
        ".parseConfig() should return the SourceConfig instance matching the given source config map",
        () {
          final party = JenkinsSourceParty();
          final jenkinsConfig = ConfigTestData.jenkinsSourceConfig;

          final result = syncCommand.parseConfig(
            ConfigTestData.integrationConfig.sourceConfigMap,
            party,
          );

          expect(result, equals(jenkinsConfig));
        },
      );

      test(
        ".parseConfig() should return the DestinationConfig instance matching the given destination config map",
        () {
          final party = FirestoreDestinationParty();
          final firestoreConfig = ConfigTestData.firestoreConfig;

          final result = syncCommand.parseConfig(
            ConfigTestData.integrationConfig.destinationConfigMap,
            party,
          );

          expect(result, equals(firestoreConfig));
        },
      );

      test(
        ".run() should log an error if the given config file does not exist",
        () async {
          when(fileMock.existsSync()).thenReturn(false);

          await syncCommand.run();

          expect(loggerStub.errorLogsNumber, equals(1));
        },
      );

      test(
        ".run() should not run sync if the given config file does not exist",
        () async {
          when(fileMock.existsSync()).thenReturn(false);

          await syncCommand.run();

          verifyNever(ciIntegrationMock.sync(any));
        },
      );

      test(".run() should call dispose once", () async {
        whenRunSyncWithParties(
          supportedSourceParties,
          supportedDestinationParties,
        ).thenAnswer((_) => Future.value(any));

        await syncCommand.run();

        expect(syncCommand.disposeCallCount, equals(1));
      });

      test(".run() should call dispose once if sync throws", () async {
        whenRunSyncWithParties(
          supportedSourceParties,
          supportedDestinationParties,
        ).thenThrow(Exception());

        await syncCommand.run();

        expect(syncCommand.disposeCallCount, equals(1));
      });

      test(".run() should log an error if sync throws", () async {
        whenRunSyncWithParties(
          supportedSourceParties,
          supportedDestinationParties,
        ).thenThrow(Exception());

        await syncCommand.run();

        expect(loggerStub.errorLogsNumber, equals(1));
      });

      test(
        ".run() should run sync on the given config",
        () async {
          whenRunSyncWithParties(
            supportedSourceParties,
            supportedDestinationParties,
          ).thenAnswer((_) => Future.value(any));

          await syncCommand.run();

          verify(ciIntegrationMock.sync(syncConfig)).called(1);
        },
      );

      test(
        ".sync() should print a message if a sync result is a success",
        () async {
          const interactionResult = InteractionResult.success();

          when(ciIntegrationMock.sync(syncConfig))
              .thenAnswer((_) => Future.value(interactionResult));

          await syncCommand.sync(
            syncConfig,
            sourceClientMock,
            destinationClientMock,
          );

          expect(loggerStub.messageLogsNumber, equals(1));
        },
      );

      test(
        ".sync() should print an error message if a sync result is an error",
        () async {
          const interactionResult = InteractionResult.error();

          when(ciIntegrationMock.sync(syncConfig))
              .thenAnswer((_) => Future.value(interactionResult));

          await syncCommand.sync(
            syncConfig,
            sourceClientMock,
            destinationClientMock,
          );

          expect(loggerStub.errorLogsNumber, equals(1));
        },
      );

      test(
        ".dispose() should dispose the given source client",
        () async {
          final syncCommand = SyncCommand(loggerStub);

          await syncCommand.dispose(
            sourceClientMock,
            destinationClientMock,
          );

          verify(sourceClientMock.dispose()).called(1);
        },
      );

      test(
        ".dispose() should dispose the given destination client",
        () async {
          final syncCommand = SyncCommand(loggerStub);

          await syncCommand.dispose(
            sourceClientMock,
            destinationClientMock,
          );

          verify(destinationClientMock.dispose()).called(1);
        },
      );
    },
  );
}

class _CiIntegrationMock extends Mock implements CiIntegration {}

/// A stub class for a [SyncCommand] class providing test implementation for
/// methods.
class SyncCommandStub extends SyncCommand {
  /// A config file mock to use for testing purposes.
  final FileMock fileMock;

  /// A CI integration mock to use for testing purposes.
  final _CiIntegrationMock ciIntegrationMock;

  /// A counter used to save the number of times the [dispose] method called.
  int _disposeCallCount = 0;

  int get disposeCallCount => _disposeCallCount;

  SyncCommandStub(
    Logger logger,
    SupportedIntegrationParties supportedParties,
    this.fileMock,
    this.ciIntegrationMock,
  ) : super(logger, supportedParties: supportedParties);

  /// Resets this stub to ensure tests run independently.
  void reset() {
    _disposeCallCount = 0;
  }

  @override
  File getConfigFile(String configFilePath) {
    return fileMock;
  }

  @override
  CiIntegration createCiIntegration(
    SourceClient sourceClient,
    DestinationClient destinationClient,
  ) {
    return ciIntegrationMock;
  }

  @override
  dynamic getArgumentValue(String name) {
    return 'config.yaml';
  }

  @override
  Future<void> dispose(
    SourceClient sourceClient,
    DestinationClient destinationClient,
  ) async {
    _disposeCallCount += 1;
  }
}
