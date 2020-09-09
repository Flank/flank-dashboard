const {
  setupTestDatabaseWith,
  getApplicationWith,
  tearDown,
} = require("./test_utils/test-app-utils");
const { assertFails, assertSucceeds } = require("@firebase/testing");
const {
  projectGroups,
  getAllowedEmailUser,
  getDeniedEmailUser,
  googleSignInProviderId,
  passwordSignInProviderId,
  allowedEmailDomains,
  getProjectGroup,
} = require("./test_utils/test-data");

describe("Project groups collection rules", async function () {
  const passwordProviderAllowedEmailApp = await getApplicationWith(
    getAllowedEmailUser(passwordSignInProviderId)
  );
  const passwordProviderNotAllowedEmailApp = await getApplicationWith(
    getDeniedEmailUser(passwordSignInProviderId)
  );
  const googleProviderAllowedEmailApp = await getApplicationWith(
    getAllowedEmailUser(googleSignInProviderId)
  );
  const googleProviderNotAllowedEmailApp = await getApplicationWith(
    getDeniedEmailUser(googleSignInProviderId)
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

  it("does not allow creating a project group with not allowed fields", async () => {
    await assertFails(
      passwordProviderAllowedEmailApp.collection(collectionName).add({
        name: "name",
        projectIds: [],
        notAllowedField: "test",
      })
    );
  });

  it("does not allow creating a project group without a name", async () => {
    await assertFails(
      passwordProviderAllowedEmailApp.collection(collectionName).add({
        projectIds: [],
      })
    );
  });

  it("does not allow creating a project group with a name having other than a string value", async () => {
    let names = [false, 123, []];

    names.forEach(async (name) => {
      await assertFails(
        passwordProviderAllowedEmailApp
          .collection(collectionName)
          .add({ name, projectIds: [] })
      );
    });
  });

  it("does not allow creating a project group with a projectIds having other than a list value", () => {
    let projectIdsValues = [123, false, "test"];

    projectIdsValues.forEach(async (projectIds) => {
      await assertFails(
        passwordProviderAllowedEmailApp
          .collection(collectionName)
          .add({ name: "test", projectIds })
      );
    });
  });

  it("allows to update a project group with name size less or equal than 255", async () => {
    const testName = "testName";

    await assertSucceeds(
      passwordProviderAllowedEmailApp.collection(collectionName).doc("2").update({
        name: testName,
        projectIds: [],
      })
    );
  });

  it("allows to update a project group with project ids length less or equal than 20", async () => {
    const testProjectIds = ["1", "2"];

    await assertSucceeds(
      passwordProviderAllowedEmailApp.collection(collectionName).doc("2").update({
        name: "name",
        projectIds: testProjectIds,
      })
    );
  });

  it("allows to create a project group with name size less or equal than 255", async () => {
    const testName = "testName";

    await assertSucceeds(
      passwordProviderAllowedEmailApp.collection(collectionName).add({
        name: testName,
        projectIds: [],
      })
    );
  });

  it("allows to create a project group with project ids length less or equal than 20", async () => {
    const testProjectIds = ["1", "2"];

    await assertSucceeds(
      passwordProviderAllowedEmailApp.collection(collectionName).add({
        name: "name",
        projectIds: testProjectIds,
      })
    );
  });

  it("does not allow updating a project group with name size greater than 255", async () => {
    const testName = "a".repeat(256);

    await assertFails(
      passwordProviderAllowedEmailApp.collection(collectionName).doc("2").update({
        name: testName,
        projectIds: [],
      })
    );
  });

  it("does not allow updating a project group with project ids length greater than 20", async () => {
    const testProjectIds = [...Array(21)].map((_, i) => `${i}`);

    await assertFails(
      passwordProviderAllowedEmailApp.collection(collectionName).doc("2").update({
        name: "name",
        projectIds: testProjectIds,
      })
    );
  });

  it("does not allow creating a project group with name size greater than 255", async () => {
    const testName = "a".repeat(256);

    await assertFails(
      passwordProviderAllowedEmailApp.collection(collectionName).add({
        name: testName,
        projectIds: [],
      })
    );
  });

  it("does not allow creating a project group with project ids length greater than 20", async () => {
    const testProjectIds = [...Array(21)].map((_, i) => `${i}`);

    await assertFails(
      passwordProviderAllowedEmailApp.collection(collectionName).add({
        name: "name",
        projectIds: testProjectIds,
      })
    );
  });

  /**
   * The password auth provider user specific tests
   */

  it("allows to create a project group by an authenticated with a password and allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderAllowedEmailApp.collection(collectionName).add(getProjectGroup())
    );
  });

  it("allows reading project groups by an authenticated with a password and allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderAllowedEmailApp.collection(collectionName).get()
    );
  });

  it("allows to update a project group by an authenticated with a password and allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderAllowedEmailApp
        .collection(collectionName)
        .doc("2")
        .update(getProjectGroup())
    );
  });

  it("allows to delete a project group by an authenticated with a password and allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderAllowedEmailApp.collection(collectionName).doc("1").delete()
    );
  });

  it("allows to create a project group by an authenticated with a password and not allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderNotAllowedEmailApp
        .collection(collectionName)
        .add(getProjectGroup())
    );
  });

  it("allows reading project groups by an authenticated with a password and not allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderNotAllowedEmailApp.collection(collectionName).get()
    );
  });

  it("allows to update a project group by an authenticated with a password and not allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderNotAllowedEmailApp
        .collection(collectionName)
        .doc("2")
        .update(getProjectGroup())
    );
  });

  it("allows to delete a project group by an authenticated with a password and not allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderNotAllowedEmailApp.collection(collectionName).doc("1").delete()
    );
  });

  /**
   * The google auth provider user specific tests
   */

  it("allows to create a project group by an authenticated with google and allowed email domain user", async () => {
    await assertSucceeds(
      googleProviderAllowedEmailApp.collection(collectionName).add(getProjectGroup())
    );
  });

  it("allows reading a project group by an authenticated with google and allowed email domain user", async () => {
    await assertSucceeds(
      googleProviderAllowedEmailApp.collection(collectionName).get()
    );
  });

  it("allows to update a project group by an authenticated with google and allowed email domain user", async () => {
    await assertSucceeds(
      googleProviderAllowedEmailApp
        .collection(collectionName)
        .doc("2")
        .update(getProjectGroup())
    );
  });

  it("allows to delete a project group by an authenticated with google and allowed email domain user", async () => {
    await assertSucceeds(
      googleProviderAllowedEmailApp.collection(collectionName).doc("1").delete()
    );
  });

  it("does not allow creating a project group by an authenticated with google and not allowed email domain user", async () => {
    await assertFails(
      googleProviderNotAllowedEmailApp
        .collection(collectionName)
        .add(getProjectGroup())
    );
  });

  it("does not allow reading project groups by an authenticated with google and not allowed email domain user", async () => {
    await assertFails(
      googleProviderNotAllowedEmailApp.collection(collectionName).get()
    );
  });

  it("does not allow updating a project group by an authenticated with google and not allowed email domain user", async () => {
    await assertFails(
      googleProviderNotAllowedEmailApp
        .collection(collectionName)
        .doc("2")
        .update(getProjectGroup())
    );
  });

  it("does not allow deleting a project group by an authenticated with google and not allowed email domain user", async () => {
    await assertFails(
      googleProviderNotAllowedEmailApp.collection(collectionName).doc("1").delete()
    );
  });

  /**
   * The unauthenticated user specific tests
   */

  it("does not allow creating a project group by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(collectionName).add(getProjectGroup())
    );
  });

  it("does not allow reading project groups by an unauthenticated user", async () => {
    await assertFails(unauthenticatedApp.collection(collectionName).get());
  });

  it("does not allow updating a project group by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp
        .collection(collectionName)
        .doc("2")
        .update(getProjectGroup())
    );
  });

  it("does not allow deleting a project group by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(collectionName).doc("1").delete()
    );
  });

  after(async () => {
    await tearDown();
  });
});
