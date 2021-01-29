import 'package:ci_integration/client/buildkite/models/buildkite_pipeline.dart';
import 'package:test/test.dart';

void main() {
  const slug = 'test';

  const pipelineJson = {'slug': slug};

  const expectedPipeline = BuildkitePipeline(slug: slug);

  group("BuildkitePipeline", () {
    test(
      "create an instance with the given slug",
      () {
        const pipeline = BuildkitePipeline(slug: slug);

        expect(pipeline.slug, equals(slug));
      },
    );

    test(
      ".fromJson() returns null if the given json is null",
      () {
        final pipeline = BuildkitePipeline.fromJson(null);

        expect(pipeline, isNull);
      },
    );

    test(
      ".fromJson() creates an instance from the given json",
      () {
        final pipeline = BuildkitePipeline.fromJson(pipelineJson);

        expect(pipeline, equals(expectedPipeline));
      },
    );

    test(
      ".listFromJson() returns null if the given list is null",
      () {
        final list = BuildkitePipeline.listFromJson(null);

        expect(list, isNull);
      },
    );

    test(
      ".listFromJson() maps an empty list to an empty one",
      () {
        final list = BuildkitePipeline.listFromJson(
          [],
        );

        expect(list, isEmpty);
      },
    );

    test(
      ".listFromJson() maps a list of buildkite slugs",
      () {
        const anotherJson = {'slug': ''};
        const anotherPipeline = BuildkitePipeline(slug: '');
        const jsonList = [pipelineJson, anotherJson];
        const expectedList = [expectedPipeline, anotherPipeline];

        final pipelineList = BuildkitePipeline.listFromJson(jsonList);

        expect(pipelineList, equals(expectedList));
      },
    );

    test(
      ".toJson converts an instance to the json encodable map",
      () {
        final json = expectedPipeline.toJson();

        expect(json, equals(pipelineJson));
      },
    );
  });
}
