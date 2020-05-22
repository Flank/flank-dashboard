const {
  setupTestDatabaseWith,
  getApplicationWith,
  tearDown,
} = require("./test_utils/test-app-utils");
const { assertFails, assertSucceeds } = require("@firebase/testing");
const {
  projectGroups,
  user,
  getProjectGroup,
} = require("./test_utils/test-data");

describe("Project groups collection rules", async function () {
  const authenticatedApp = await getApplicationWith(user);
  const unauthenticatedApp = await getApplicationWith(null);
  const collectionName = "project_groups";

  before(async () => {
    await setupTestDatabaseWith(projectGroups);
  });

  /**
   * Common tests
   */

  it("does not allow to create a project with not allowed fields", async () => {
    await assertFails(
      authenticatedApp.collection(collectionName).add({
        name: "name",
        projectIds: [],
        notAllowedField: "test",
      })
    );
  });

  it("does not allow to create a project group without a name", async () => {
    await assertFails(authenticatedApp.collection(collectionName).add({}));
  });

  it("does not allow to create a project group with a name having other than a string value", async () => {
    let names = [false, 123, []];
    let projectIds = [];

    names.forEach(async (name) => {
      await assertFails(
        authenticatedApp.collection(collectionName).add({ name, projectIds })
      );
    });
  });

  it("does not allow to create a project group with a projectIds having other than a list value", () => {
    let name = "test";
    let projectIdsValues = [123, false, "test"];

    projectIdsValues.forEach(async (projectIds) => {
      await assertFails(
        authenticatedApp.collection(collectionName).add({ name, projectIds })
      );
    });
  });

  /**
   * The authenticated user specific tests
   */

  it("allows creating a project group by an authenticated user", async () => {
    await assertSucceeds(
      authenticatedApp.collection(collectionName).add(getProjectGroup())
    );
  });

  it("allows reading project groups by an authenticated user", async () => {
    await assertSucceeds(authenticatedApp.collection(collectionName).get());
  });

  it("allows updating a project group by an authenticated user", async () => {
    await assertSucceeds(
      authenticatedApp
        .collection(collectionName)
        .doc("2")
        .update(getProjectGroup())
    );
  });

  it("allows deleting a project group by an authenticated user", async () => {
    await assertSucceeds(
      authenticatedApp.collection(collectionName).doc("1").delete()
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
