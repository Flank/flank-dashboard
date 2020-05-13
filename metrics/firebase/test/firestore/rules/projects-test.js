const {
  setupTestDatabaseWith,
  getApplicationWith,
  tearDown,
} = require("./test_utils/test-app-utils");
const { assertFails, assertSucceeds } = require("@firebase/testing");
const { project, projects, user } = require("./test_utils/test-data");

describe("Project collection rules", async function () {
  const authenticatedApp = await getApplicationWith(user);
  const unauthenticatedApp = await getApplicationWith(null);
  const projectsCollectionName = "projects";

  before(async () => {
    await setupTestDatabaseWith(projects);
  });

  it("allows reading projects by an authenticated user", async () => {
    await assertSucceeds(
      authenticatedApp.collection(projectsCollectionName).get()
    );
  });

  it("allows adding a project by an authenticated user", async () => {
    await assertSucceeds(
      authenticatedApp.collection(projectsCollectionName).add(project)
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

  it("does not allow to create a project with not allowed fields", async () => {
    await assertFails(
      unauthenticatedApp.collection(projectsCollectionName).add({
        name: "name",
        test: "test",
      })
    );
  });

  it("does not allow to read projects by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(projectsCollectionName).get()
    );
  });

  it("does not allow to create a project by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(projectsCollectionName).add(project)
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

  it("does not allow to delete a project by authenticated user", async () => {
    await assertFails(
      authenticatedApp.collection(projectsCollectionName).doc("1").delete()
    );
  });

  it("does not allow to create a project without a name", async () => {
    await assertFails(authenticatedApp.collection("projects").add({}));
  });

  after(async () => {
    await tearDown();
  });
});
