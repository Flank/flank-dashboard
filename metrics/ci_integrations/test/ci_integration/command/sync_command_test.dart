import 'dart:io';

import 'package:ci_integration/ci_integration/ci_integration.dart';
import 'package:ci_integration/ci_integration/command/sync_command.dart';
import 'package:ci_integration/ci_integration/config/model/raw_integration_config.dart';
import 'package:ci_integration/ci_integration/config/model/sync_config.dart';
import 'package:ci_integration/ci_integration/parties/supported_integration_parties.dart';
import 'package:ci_integration/common/client/destination_client.dart';
import 'package:ci_integration/common/client/source_client.dart';
import 'package:ci_integration/common/config/model/destination_config.dart';
import 'package:ci_integration/common/config/model/source_config.dart';
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

void main() {
  group(
    "SyncCommand",
    () {
      const jobName = 'test_project';
      const firebaseProjectId = 'firebaseId';
      const configFileContent = '''
      source:
        jenkins:
          url: sample_url
          job_name: $jobName
          username: username
          api_key: key
      destination:
        firestore:
          firebase_project_id: $firebaseProjectId
          metrics_project_id: id
    ''';
      final RawIntegrationConfig integrationConfig = RawIntegrationConfig(
        sourceConfigMap: {
          'jenkins': {
            'url': 'sample_url',
            'job_name': jobName,
            'username': 'username',
            'api_key': 'key',
          },
        },
        destinationConfigMap: {
          'firestore': {
            'firebase_project_id': firebaseProjectId,
            'metrics_project_id': 'id',
          },
        },
      );
      final loggerStub = LoggerStub();
      final fileMock = FileMock();

      final ciIntegrationMock = _CiIntegrationMock();

      final sourceClientMock = SourceClientMock();
      final destinationClientMock = DestinationClientMock();

      final sourceConfigMock = SourceConfigMock();
      final destinationConfigMock = DestinationConfigMock();

      final sourceClientFactoryStub = ClientFactoryStub(sourceClientMock);
      final destinationClientFactoryStub =
          ClientFactoryStub(destinationClientMock);

      final sourceConfigParserMock = ConfigParserMock<SourceConfig>();
      final destinationConfigParserMock = ConfigParserMock<DestinationConfig>();

      final sourcePartyStub = IntegrationPartyStub(
        sourceClientFactoryStub,
        sourceConfigParserMock,
      ) as SourceParty;
      final destinationPartyStub = IntegrationPartyStub(
        destinationClientFactoryStub,
        destinationConfigParserMock,
      ) as DestinationParty;

      final sourcePartiesMock = PartiesMock<SourceParty>();
      final destinationPartiesMock = PartiesMock<DestinationParty>();

      final syncCommand = SyncCommandStub(
        loggerStub,
        SupportedIntegrationParties(
          sourceParties: sourcePartiesMock,
          destinationParties: destinationPartiesMock,
        ),
        fileMock,
        ciIntegrationMock,
      );
      final syncConfig = SyncConfig(
        destinationProjectId: firebaseProjectId,
        sourceProjectId: jobName,
      );

      setUp(() {
        loggerStub.clearLogs();
        reset(fileMock);
        reset(ciIntegrationMock);
        reset(sourceClientMock);
        reset(destinationClientMock);
        reset(sourceConfigParserMock);
        reset(destinationConfigParserMock);
        reset(sourcePartiesMock);
        reset(destinationPartiesMock);
        reset(sourceConfigMock);
        reset(destinationConfigMock);
      });

      PostExpectation<SourceClient> whenCreateSourceClient(
        Map<String, dynamic> configMap,
      ) {
        when(sourcePartiesMock.parties).thenReturn([sourcePartyStub]);
        when(sourceConfigParserMock.canParse(configMap)).thenReturn(true);
        when(sourceConfigParserMock.parse(
          configMap,
        )).thenReturn(sourceConfigMock);
        return when(sourceClientFactoryStub.create(sourceConfigMock));
      }

      PostExpectation<DestinationClient> whenCreateDestinationClient(
        Map<String, dynamic> configMap,
      ) {
        when(destinationPartiesMock.parties).thenReturn([destinationPartyStub]);
        when(destinationConfigParserMock.canParse(configMap)).thenReturn(true);
        when(destinationConfigParserMock.parse(
          configMap,
        )).thenReturn(destinationConfigMock);
        return when(destinationClientFactoryStub.create(destinationConfigMock));
      }

      PostExpectation<Future<InteractionResult>> whenRunSync(
        SyncConfig syncConfig,
      ) {
        when(fileMock.existsSync()).thenReturn(true);
        when(fileMock.readAsStringSync()).thenReturn(configFileContent);
        whenCreateSourceClient(
          integrationConfig.sourceConfigMap,
        ).thenReturn(sourceClientMock);
        whenCreateDestinationClient(
          integrationConfig.destinationConfigMap,
        ).thenReturn(destinationClientMock);
        when(
          sourceConfigMock.sourceProjectId,
        ).thenReturn(syncConfig.sourceProjectId);
        when(
          destinationConfigMock.destinationProjectId,
        ).thenReturn(syncConfig.destinationProjectId);
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

      test(".parseConfigFileContent() should parse the config file content",
          () {
        final expected = integrationConfig;
        when(fileMock.readAsStringSync()).thenReturn(configFileContent);

        final result = syncCommand.parseConfigFileContent(fileMock);

        expect(result, equals(expected));
      });

      test(
        ".getParty() should throw an UnimplementedError if the given parties is empty",
        () {
          when(sourcePartiesMock.parties).thenReturn([]);

          expect(
            syncCommand.getParty(
              integrationConfig.sourceConfigMap,
              sourcePartiesMock,
            ),
            throwsUnimplementedError,
          );
        },
      );

      test(
        ".getParty() should throw an UnimplementedError if the given parties does not contain appropriate party",
        () {
          when(sourcePartiesMock.parties).thenReturn([sourcePartyStub]);
          when(sourceConfigParserMock.canParse(
            integrationConfig.sourceConfigMap,
          )).thenReturn(false);

          expect(
            syncCommand.getParty(
              integrationConfig.sourceConfigMap,
              sourcePartiesMock,
            ),
            throwsUnimplementedError,
          );
        },
      );

      test(
        ".getParty() should return the SourceParty instance for the source config map",
        () {
          when(sourcePartiesMock.parties).thenReturn([sourcePartyStub]);
          when(sourceConfigParserMock.canParse(
            integrationConfig.sourceConfigMap,
          )).thenReturn(true);

          final result = syncCommand.getParty(
            integrationConfig.sourceConfigMap,
            sourcePartiesMock,
          );

          expect(result, isA<SourceParty>());
        },
      );

      test(
        ".getParty() should return the DestinationParty instance for the destination config map",
        () {
          when(destinationPartiesMock.parties)
              .thenReturn([destinationPartyStub]);
          when(destinationConfigParserMock.canParse(
            integrationConfig.destinationConfigMap,
          )).thenReturn(true);

          final result = syncCommand.getParty(
            integrationConfig.destinationConfigMap,
            destinationPartiesMock,
          );

          expect(result, isA<DestinationParty>());
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
        ".parseConfig() should return the SourceConfig instance for the source config map",
        () {
          final party = JenkinsSourceParty();

          final result = syncCommand.parseConfig(
            integrationConfig.sourceConfigMap,
            party,
          );

          expect(result, isA<SourceConfig>());
        },
      );

      test(
        ".parseConfig() should return the DestinationConfig instance for the destination config map",
        () {
          final party = FirestoreDestinationParty();

          final result = syncCommand.parseConfig(
            integrationConfig.destinationConfigMap,
            party,
          );

          expect(result, isA<DestinationConfig>());
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
        whenRunSync(syncConfig).thenAnswer(any);

        await syncCommand.run();

        verify(sourceClientMock.dispose()).called(1);
        verify(destinationClientMock.dispose()).called(1);
      });

      test(".run() should call dispose once if sync throws", () async {
        whenRunSync(syncConfig).thenThrow(Exception());

        await syncCommand.run();

        verify(sourceClientMock.dispose()).called(1);
        verify(destinationClientMock.dispose()).called(1);
      });

      test(".run() should log error if sync throws", () async {
        whenRunSync(syncConfig).thenThrow(Exception());

        await syncCommand.run();

        expect(loggerStub.errorLogsNumber, equals(1));
      });

      test(
        ".run() should log an error if creating the source client throws",
        () async {
          when(fileMock.existsSync()).thenReturn(true);
          when(fileMock.readAsStringSync()).thenReturn(configFileContent);
          whenCreateDestinationClient(
            integrationConfig.destinationConfigMap,
          ).thenReturn(destinationClientMock);
          whenCreateSourceClient(
            integrationConfig.sourceConfigMap,
          ).thenThrow(Exception());

          await syncCommand.run();

          expect(loggerStub.errorLogsNumber, equals(1));
        },
      );

      test(
        ".run() should log an error if creating the destination client throws",
        () async {
          when(fileMock.existsSync()).thenReturn(true);
          when(fileMock.readAsStringSync()).thenReturn(configFileContent);
          whenCreateSourceClient(
            integrationConfig.sourceConfigMap,
          ).thenReturn(sourceClientMock);
          whenCreateDestinationClient(
            integrationConfig.destinationConfigMap,
          ).thenThrow(Exception());

          await syncCommand.run();

          expect(loggerStub.errorLogsNumber, equals(1));
        },
      );

      test(
        ".run() should run sync on the given config",
        () async {
          whenRunSync(syncConfig).thenAnswer(any);

          await syncCommand.run();

          verify(ciIntegrationMock.sync(syncConfig)).called(1);
        },
      );

      test(
        ".sync() should print a message if an interaction result is success",
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
        ".sync() should print an error message if an interaction result is error",
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
        ".dispose() should dispose source client",
        () async {
          await syncCommand.dispose(
            sourceClientMock,
            destinationClientMock,
          );

          verify(sourceClientMock.dispose()).called(1);
        },
      );

      test(
        ".dispose() should dispose destination client",
        () async {
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

  SyncCommandStub(
    Logger logger,
    SupportedIntegrationParties supportedParties,
    this.fileMock,
    this.ciIntegrationMock,
  ) : super(logger, supportedParties: supportedParties);

  @override
  File getConfigFile(String configFilePath) {
    return fileMock;
  }

  @override
  CiIntegration createCiIntegration(
    SourceClient sourceClient,
    DestinationClient destinationaClient,
  ) {
    return ciIntegrationMock;
  }

  @override
  dynamic getArgumentValue(String name) {
    return 'config.yaml';
  }
}
