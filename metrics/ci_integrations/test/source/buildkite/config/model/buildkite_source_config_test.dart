import 'package:ci_integration/source/buildkite/config/model/buildkite_source_config.dart';
import 'package:test/test.dart';

import '../../test_utils/test_data/buildkite_config_test_data.dart';

void main() {
  group("BuildkiteSourceConfig", () {
    const accessToken = BuildkiteConfigTestData.accessToken;
    const organizationSlug = BuildkiteConfigTestData.organizationSlug;
    const pipelineSlug = BuildkiteConfigTestData.pipelineSlug;
    const coverageArtifactName = BuildkiteConfigTestData.coverageArtifactName;

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
            coverageArtifactName: coverageArtifactName,
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
            coverageArtifactName: coverageArtifactName,
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
            coverageArtifactName: coverageArtifactName,
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
            coverageArtifactName: coverageArtifactName,
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
            coverageArtifactName: coverageArtifactName,
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
            coverageArtifactName: coverageArtifactName,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the coverage artifact name is null",
      () {
        expect(
          () => BuildkiteSourceConfig(
            accessToken: accessToken,
            pipelineSlug: pipelineSlug,
            organizationSlug: organizationSlug,
            coverageArtifactName: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the coverage artifact name is empty",
      () {
        expect(
          () => BuildkiteSourceConfig(
            accessToken: accessToken,
            pipelineSlug: pipelineSlug,
            organizationSlug: organizationSlug,
            coverageArtifactName: '',
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
          coverageArtifactName: coverageArtifactName,
        );

        expect(config.accessToken, equals(accessToken));
        expect(config.pipelineSlug, equals(pipelineSlug));
        expect(config.organizationSlug, equals(organizationSlug));
        expect(config.coverageArtifactName, equals(coverageArtifactName));
      },
    );

    test(
      ".fromJson returns null if the given json is null",
      () {
        final actualConfig = BuildkiteSourceConfig.fromJson(null);

        expect(actualConfig, isNull);
      },
    );

    test(
      ".fromJson creates a new instance from the given json",
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
