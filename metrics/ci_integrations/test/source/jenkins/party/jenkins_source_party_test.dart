// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/stub/base/config/validator_factory/validator_factory_stub.dart';
import 'package:ci_integration/source/jenkins/client_factory/jenkins_source_client_factory.dart';
import 'package:ci_integration/source/jenkins/config/parser/jenkins_source_config_parser.dart';
import 'package:ci_integration/source/jenkins/party/jenkins_source_party.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsSourceParty", () {
    final jenkinsSourceParty = JenkinsSourceParty();

    test("uses JenkinsSourceClientFactory as a client factory", () {
      final clientFactory = jenkinsSourceParty.clientFactory;

      expect(clientFactory, isA<JenkinsSourceClientFactory>());
    });

    test("uses JenkinsConfigParser as a config parser", () {
      final configParser = jenkinsSourceParty.configParser;

      expect(configParser, isA<JenkinsSourceConfigParser>());
    });

    test("uses ValidatorFactoryStub as a validator factory", () {
      final validatorFactory = jenkinsSourceParty.configValidatorFactory;

      expect(validatorFactory, isA<ValidatorFactoryStub>());
    });
  });
}
