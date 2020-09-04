const {
  setupTestDatabaseWith,
  getApplicationWith,
  tearDown,
} = require("./test_utils/test-app-utils");
const { assertFails, assertSucceeds } = require("@firebase/testing");
const {
  projectGroups,
  getAllowedEmailDomainUser,
  getNotAllowedDomainUser,
  googleSignInProviderId,
  passwordSignInProviderId,
  allowedEmailDomains,
  getProjectGroup,
} = require("./test_utils/test-data");

describe("Project groups collection rules", async function () {
  const passwordProviderAllowedDomainApp = await getApplicationWith(
    getAllowedEmailDomainUser(passwordSignInProviderId)
  );
  const passwordProviderNotAllowedDomainApp = await getApplicationWith(
    getNotAllowedDomainUser(passwordSignInProviderId)
  );
  const googleProviderAllowedDomainApp = await getApplicationWith(
    getAllowedEmailDomainUser(googleSignInProviderId)
  );
  const googleProviderNotAllowedDomainApp = await getApplicationWith(
    getNotAllowedDomainUser(googleSignInProviderId)
  );
  const unauthenticatedApp = await getApplicationWith(null);
  const collectionName = "project_groups";

  before(async () => {
    await setupTestDatabaseWith(
      Object.assign({}, projectGroups, allowedEmailDomains)
    );
  });

  /**
   * Common tests
   */

  it("does not allow to create a project group with not allowed fields", async () => {
    await assertFails(
      passwordProviderAllowedDomainApp.collection(collectionName).add({
        name: "name",
        projectIds: [],
        notAllowedField: "test",
      })
    );
  });

  it("does not allow to create a project group without a name", async () => {
    await assertFails(
      passwordProviderAllowedDomainApp.collection(collectionName).add({
        projectIds: [],
      })
    );
  });

  it("does not allow to create a project group with a name having other than a string value", async () => {
    let names = [false, 123, []];

    names.forEach(async (name) => {
      await assertFails(
        passwordProviderAllowedDomainApp
          .collection(collectionName)
          .add({ name, projectIds: [] })
      );
    });
  });

  it("does not allow to create a project group with a projectIds having other than a list value", () => {
    let projectIdsValues = [123, false, "test"];

    projectIdsValues.forEach(async (projectIds) => {
      await assertFails(
        passwordProviderAllowedDomainApp
          .collection(collectionName)
          .add({ name: "test", projectIds })
      );
    });
  });

  it("allows updating a project group with name size less or equal than 255", async () => {
    const testName = "testName";

    await assertSucceeds(
      passwordProviderAllowedDomainApp.collection(collectionName).doc("2").update({
        name: testName,
        projectIds: [],
      })
    );
  });

  it("allows updating a project group with project ids length less or equal than 20", async () => {
    const testProjectIds = ["1", "2"];

    await assertSucceeds(
      passwordProviderAllowedDomainApp.collection(collectionName).doc("2").update({
        name: "name",
        projectIds: testProjectIds,
      })
    );
  });

  it("allows creating a project group with name size less or equal than 255", async () => {
    const testName = "testName";

    await assertSucceeds(
      passwordProviderAllowedDomainApp.collection(collectionName).add({
        name: testName,
        projectIds: [],
      })
    );
  });

  it("allows creating a project group with project ids length less or equal than 20", async () => {
    const testProjectIds = ["1", "2"];

    await assertSucceeds(
      passwordProviderAllowedDomainApp.collection(collectionName).add({
        name: "name",
        projectIds: testProjectIds,
      })
    );
  });

  it("does not allow updating a project group with name size greater than 255", async () => {
    const testName = "a".repeat(256);

    await assertFails(
      passwordProviderAllowedDomainApp.collection(collectionName).doc("2").update({
        name: testName,
        projectIds: [],
      })
    );
  });

  it("does not allow updating a project group with project ids length greater than 20", async () => {
    const testProjectIds = [...Array(21)].map((_, i) => `${i}`);

    await assertFails(
      passwordProviderAllowedDomainApp.collection(collectionName).doc("2").update({
        name: "name",
        projectIds: testProjectIds,
      })
    );
  });

  it("does not allow creating a project group with name size greater than 255", async () => {
    const testName = "a".repeat(256);

    await assertFails(
      passwordProviderAllowedDomainApp.collection(collectionName).add({
        name: testName,
        projectIds: [],
      })
    );
  });

  it("does not allow creating a project group with project ids length greater than 20", async () => {
    const testProjectIds = [...Array(21)].map((_, i) => `${i}`);

    await assertFails(
      passwordProviderAllowedDomainApp.collection(collectionName).add({
        name: "name",
        projectIds: testProjectIds,
      })
    );
  });

  /**
   * The google auth provider user specific tests
   */

  it("does not allow to create a project group by an authenticated google user with not allowed email domain", async () => {
    await assertFails(
      googleProviderNotAllowedDomainApp
        .collection(collectionName)
        .add(getProjectGroup())
    );
  });

  it("allows creating a project group by an authenticated google user with allowed email domain", async () => {
    await assertSucceeds(
      googleProviderAllowedDomainApp.collection(collectionName).add(getProjectGroup())
    );
  });

  it("does not allow to read project groups by an authenticated google user with not allowed email domain", async () => {
    await assertFails(
      googleProviderNotAllowedDomainApp.collection(collectionName).get()
    );
  });

  it("allows reading a project group by an authenticated google user with allowed email domain", async () => {
    await assertSucceeds(
      googleProviderAllowedDomainApp.collection(collectionName).get()
    );
  });

  it("does not allow to update a project group by an authenticated google user with not allowed email domain", async () => {
    await assertFails(
      googleProviderNotAllowedDomainApp
        .collection(collectionName)
        .doc("2")
        .update(getProjectGroup())
    );
  });

  it("allows updating a project group by an authenticated google user with allowed email domain", async () => {
    await assertSucceeds(
      googleProviderAllowedDomainApp
        .collection(collectionName)
        .doc("2")
        .update(getProjectGroup())
    );
  });

  it("does not allow to delete a project group by an authenticated google user with not allowed email domain", async () => {
    await assertFails(
      googleProviderNotAllowedDomainApp.collection(collectionName).doc("1").delete()
    );
  });

  it("allows deleting a project group by an authenticated google user with allowed email domain", async () => {
    await assertSucceeds(
      googleProviderAllowedDomainApp.collection(collectionName).doc("1").delete()
    );
  });

  /**
   * The password auth provider user specific tests
   */

  it("allows creating a project group by an authenticated password user with allowed email domain", async () => {
    await assertSucceeds(
      passwordProviderAllowedDomainApp.collection(collectionName).add(getProjectGroup())
    );
  });

  it("allows creating a project group by an authenticated password user with not allowed email domain", async () => {
    await assertSucceeds(
      passwordProviderNotAllowedDomainApp
        .collection(collectionName)
        .add(getProjectGroup())
    );
  });

  it("allows reading project groups by an authenticated password user with allowed email domain", async () => {
    await assertSucceeds(
      passwordProviderAllowedDomainApp.collection(collectionName).get()
    );
  });

  it("allows reading project groups by an authenticated password user with not allowed email domain", async () => {
    await assertSucceeds(
      passwordProviderNotAllowedDomainApp.collection(collectionName).get()
    );
  });

  it("allows updating a project group by an authenticated password user with allowed email domain", async () => {
    await assertSucceeds(
      passwordProviderAllowedDomainApp
        .collection(collectionName)
        .doc("2")
        .update(getProjectGroup())
    );
  });

  it("allows updating a project group by an authenticated password user with not allowed email domain", async () => {
    await assertSucceeds(
      passwordProviderNotAllowedDomainApp
        .collection(collectionName)
        .doc("2")
        .update(getProjectGroup())
    );
  });

  it("allows deleting a project group by an authenticated password user with allowed email domain", async () => {
    await assertSucceeds(
      passwordProviderAllowedDomainApp.collection(collectionName).doc("1").delete()
    );
  });

  it("allows deleting a project group by an authenticated password user with not allowed email domain", async () => {
    await assertSucceeds(
      passwordProviderNotAllowedDomainApp.collection(collectionName).doc("1").delete()
    );
  });

  /**
   * The unauthenticated user specific tests
   */

  it("does not allow to create a project group by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(collectionName).add(getProjectGroup())
    );
  });

  it("does not allow to read project groups by an unauthenticated user", async () => {
    await assertFails(unauthenticatedApp.collection(collectionName).get());
  });

  it("does not allow to update a project group by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp
        .collection(collectionName)
        .doc("2")
        .update(getProjectGroup())
    );
  });

  it("does not allow to delete a project group by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(collectionName).doc("1").delete()
    );
  });

  after(async () => {
    await tearDown();
  });
});
