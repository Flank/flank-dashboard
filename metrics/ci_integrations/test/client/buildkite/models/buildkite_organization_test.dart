// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/buildkite/models/buildkite_organization.dart';
import 'package:test/test.dart';

void main() {
  group("BuildkiteOrganization", () {
    const id = 'id';
    const name = 'test';
    const slug = 'slug';

    const organizationJson = {
      'id': id,
      'name': name,
      'slug': slug,
    };

    const organization = BuildkiteOrganization(
      id: id,
      name: name,
      slug: slug,
    );

    test(
      "creates an instance with the given parameters",
      () {
        const organization = BuildkiteOrganization(
          id: id,
          name: name,
          slug: slug,
        );

        expect(organization.id, equals(id));
        expect(organization.name, equals(name));
        expect(organization.slug, equals(slug));
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
        final actualOrganization = BuildkiteOrganization.fromJson(
          organizationJson,
        );

        expect(actualOrganization, equals(organization));
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
      ".listFromJson() returns an empty list if the given one is empty",
      () {
        final list = BuildkiteOrganization.listFromJson([]);

        expect(list, isEmpty);
      },
    );

    test(
      ".listFromJson() creates a list of Buildkite organizations from the given list of JSON encodable objects",
      () {
        const anotherJson = {'name': ''};
        const anotherOrganization = BuildkiteOrganization(name: '');
        const jsonList = [organizationJson, anotherJson];
        const expectedList = [organization, anotherOrganization];

        final organizationList = BuildkiteOrganization.listFromJson(jsonList);

        expect(organizationList, equals(expectedList));
      },
    );

    test(
      ".toJson() converts an instance to the json encodable map",
      () {
        final json = organization.toJson();

        expect(json, equals(organizationJson));
      },
    );
  });
}
