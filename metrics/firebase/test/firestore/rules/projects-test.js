const {
  setupTestDatabaseWith,
  getApplicationWith,
  tearDown,
} = require("./test_utils/test-app-utils");
const { assertFails, assertSucceeds } = require("@firebase/testing");
const {
  project,
  projects,
  user,
  invalidUser,
  allowedEmailDomains,
} = require("./test_utils/test-data");

describe("Projects collection rules", async function () {
  const authenticatedApp = await getApplicationWith(user);
  const invalidAuthenticatedApp = await getApplicationWith(invalidUser);
  const unauthenticatedApp = await getApplicationWith(null);
  const projectsCollectionName = "projects";

  before(async () => {
    await setupTestDatabaseWith(
      Object.assign({}, projects, allowedEmailDomains)
    );
  });

  /**
   * Common tests
   */

  it("does not allow to create a project with not allowed fields", async () => {
    await assertFails(
      unauthenticatedApp.collection(projectsCollectionName).add({
        name: "name",
        test: "test",
      })
    );
  });

  it("does not allow to create a project without a name", async () => {
    await assertFails(authenticatedApp.collection("projects").add({}));
  });

  /**
   * The authenticated user specific tests
   */

  it("allows creating a project by an authenticated user", async () => {
    await assertSucceeds(
      authenticatedApp.collection(projectsCollectionName).add(project)
    );
  });

  it("does not allow to create a project by an authenticated user with an invalid email domain", async () => {
    await assertFails(
      invalidAuthenticatedApp.collection(projectsCollectionName).add(project)
    );
  });

  it("allows reading projects by an authenticated user", async () => {
    await assertSucceeds(
      authenticatedApp.collection(projectsCollectionName).get()
    );
  });

  it("does not allow to read projects by an authenticated user with an invalid email domain", async () => {
    await assertFails(
      invalidAuthenticatedApp.collection(projectsCollectionName).get()
    );
  });

  it("does not allow to read projects by an authenticated user with an invalid email domain", async () => {
    await assertFails(
      invalidAuthenticatedApp.collection(projectsCollectionName).get()
    );
  });

  it("allows updating a project by an authenticated user", async () => {
    await assertSucceeds(
      authenticatedApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  it("does not allow to update a project by an authenticated user with invalid email", async () => {
    await assertFails(
      invalidAuthenticatedApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  it("does not allow to delete a project by authenticated user", async () => {
    await assertFails(
      authenticatedApp.collection(projectsCollectionName).doc("1").delete()
    );
  });

  /**
   * The unauthenticated user specific tests
   */

  it("does not allow to create a project by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(projectsCollectionName).add(project)
    );
  });

  it("does not allow to read projects by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(projectsCollectionName).get()
    );
  });

  it("does not allow to update a project by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  it("does not allow to delete a project by unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(projectsCollectionName).doc("1").delete()
    );
  });

  after(async () => {
    await tearDown();
  });
});
