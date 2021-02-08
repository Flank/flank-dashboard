// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/source/buildkite/config/model/buildkite_source_config.dart';
import 'package:test/test.dart';

import '../../test_utils/test_data/buildkite_config_test_data.dart';

void main() {
  group("BuildkiteSourceConfig", () {
    const accessToken = BuildkiteConfigTestData.accessToken;
    const organizationSlug = BuildkiteConfigTestData.organizationSlug;
    const pipelineSlug = BuildkiteConfigTestData.pipelineSlug;

    const configMap = BuildkiteConfigTestData.sourceConfigMap;
    final config = BuildkiteConfigTestData.sourceConfig;

    test(
      "throws an ArgumentError if the given access token is null",
      () {
        expect(
          () => BuildkiteSourceConfig(
            accessToken: null,
            pipelineSlug: pipelineSlug,
            organizationSlug: organizationSlug,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given access token is empty",
      () {
        expect(
          () => BuildkiteSourceConfig(
            accessToken: '',
            pipelineSlug: pipelineSlug,
            organizationSlug: organizationSlug,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given pipeline slug is null",
      () {
        expect(
          () => BuildkiteSourceConfig(
            accessToken: accessToken,
            pipelineSlug: null,
            organizationSlug: organizationSlug,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given pipeline slug is empty",
      () {
        expect(
          () => BuildkiteSourceConfig(
            accessToken: accessToken,
            pipelineSlug: '',
            organizationSlug: organizationSlug,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given organization slug is null",
      () {
        expect(
          () => BuildkiteSourceConfig(
            accessToken: accessToken,
            pipelineSlug: pipelineSlug,
            organizationSlug: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given organization slug is empty",
      () {
        expect(
          () => BuildkiteSourceConfig(
            accessToken: accessToken,
            pipelineSlug: pipelineSlug,
            organizationSlug: '',
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given values",
      () {
        final config = BuildkiteSourceConfig(
          accessToken: accessToken,
          pipelineSlug: pipelineSlug,
          organizationSlug: organizationSlug,
        );

        expect(config.accessToken, equals(accessToken));
        expect(config.pipelineSlug, equals(pipelineSlug));
        expect(config.organizationSlug, equals(organizationSlug));
      },
    );

    test(
      ".fromJson() returns null if the given json is null",
      () {
        final actualConfig = BuildkiteSourceConfig.fromJson(null);

        expect(actualConfig, isNull);
      },
    );

    test(
      ".fromJson() creates a new instance from the given json",
      () {
        final actualConfig = BuildkiteSourceConfig.fromJson(configMap);

        expect(actualConfig, equals(config));
      },
    );

    test(".sourceProjectId returns the given pipeline slug value", () {
      const expected = pipelineSlug;

      final sourceProjectId = config.sourceProjectId;

      expect(sourceProjectId, equals(expected));
    });
  });
}
