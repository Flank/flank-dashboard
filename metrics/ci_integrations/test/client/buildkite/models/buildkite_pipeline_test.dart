import 'package:ci_integration/client/buildkite/models/buildkite_pipeline.dart';
import 'package:test/test.dart';

void main() {
  group("BuildkitePipeline", () {
    const id = 'id';
    const name = 'test';
    const slug = 'slug';

    const pipelineJson = {
      'id': id,
      'name': name,
      'slug': slug,
    };

    const pipeline = BuildkitePipeline(
      id: id,
      name: name,
      slug: slug,
    );

    test(
      "creates an instance with the given parameters",
      () {
        const pipeline = BuildkitePipeline(
          id: id,
          name: name,
          slug: slug,
        );

        expect(pipeline.id, equals(id));
        expect(pipeline.name, equals(name));
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
        final actualPipeline = BuildkitePipeline.fromJson(pipelineJson);

        expect(actualPipeline, equals(pipeline));
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
      ".listFromJson() returns an empty list if the given one is empty",
      () {
        final list = BuildkitePipeline.listFromJson([]);

        expect(list, isEmpty);
      },
    );

    test(
      ".listFromJson() creates a list of Buildkite pipelines from the given list of JSON encodable objects",
      () {
        const anotherJson = {'slug': ''};
        const anotherPipeline = BuildkitePipeline(slug: '');
        const jsonList = [pipelineJson, anotherJson];
        const expectedList = [pipeline, anotherPipeline];

        final pipelineList = BuildkitePipeline.listFromJson(jsonList);

        expect(pipelineList, equals(expectedList));
      },
    );

    test(
      ".toJson() converts an instance to the json encodable map",
      () {
        final json = pipeline.toJson();

        expect(json, equals(pipelineJson));
      },
    );
  });
}
