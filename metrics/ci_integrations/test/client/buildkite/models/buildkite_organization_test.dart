import 'package:ci_integration/client/buildkite/models/buildkite_organization.dart';
import 'package:test/test.dart';

void main() {
  const name = 'test';

  const organizationJson = {'name': name};

  const expectedOrganization = BuildkiteOrganization(name: name);

  group("BuildkiteOrganization", () {
    test(
      "create an instance with the given name",
      () {
        const organization = BuildkiteOrganization(name: name);

        expect(organization.name, equals(name));
      },
    );

    test(
      ".fromJson() returns null if the given json is null",
      () {
        final organization = BuildkiteOrganization.fromJson(null);

        expect(organization, isNull);
      },
    );

    test(
      ".fromJson() creates an instance from the given json",
      () {
        final organization = BuildkiteOrganization.fromJson(organizationJson);

        expect(organization, equals(expectedOrganization));
      },
    );

    test(
      ".listFromJson() returns null if the given list is null",
      () {
        final list = BuildkiteOrganization.listFromJson(null);

        expect(list, isNull);
      },
    );

    test(
      ".listFromJson() maps an empty list to an empty one",
      () {
        final list = BuildkiteOrganization.listFromJson(
          [],
        );

        expect(list, isEmpty);
      },
    );

    test(
      ".listFromJson() maps a list of buildkite names",
      () {
        const anotherJson = {'name': ''};
        const anotherOrganization = BuildkiteOrganization(name: '');
        const jsonList = [organizationJson, anotherJson];
        const expectedList = [expectedOrganization, anotherOrganization];

        final organizationList = BuildkiteOrganization.listFromJson(jsonList);

        expect(organizationList, equals(expectedList));
      },
    );

    test(
      ".toJson converts an instance to the json encodable map",
      () {
        final json = expectedOrganization.toJson();

        expect(json, equals(organizationJson));
      },
    );
  });
}
