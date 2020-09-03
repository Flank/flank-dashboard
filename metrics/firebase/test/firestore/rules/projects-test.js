const {
  setupTestDatabaseWith,
  getApplicationWith,
  tearDown,
} = require("./test_utils/test-app-utils");
const { assertFails, assertSucceeds } = require("@firebase/testing");
const {
  project,
  projects,
  getAllowedEmailDomainUser,
  getNotAllowedDomainUser,
  passwordSignInProviderId,
  googleSignInProviderId,
  allowedEmailDomains,
} = require("./test_utils/test-data");

describe("Projects collection rules", async function () {
  const allowedDomainPasswordApp = await getApplicationWith(
    getAllowedEmailDomainUser(passwordSignInProviderId)
  );
  const notAllowedDomainPasswordApp = await getApplicationWith(
    getNotAllowedDomainUser(passwordSignInProviderId)
  );
  const allowedDomainGoogleApp = await getApplicationWith(
    getAllowedEmailDomainUser(googleSignInProviderId)
  );
  const notAllowedDomainGoogleApp = await getApplicationWith(
    getNotAllowedDomainUser(googleSignInProviderId)
  );
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
    await assertFails(allowedDomainPasswordApp.collection("projects").add({}));
  });

  /**
   * The google auth provider user specific tests
   */

  it("does not allow to create a project by an authenticated google user with not allowed email domain", async () => {
    await assertFails(
      notAllowedDomainGoogleApp.collection(projectsCollectionName).add(project)
    );
  });

  it("allows creating a project by an authenticated google user with allowed email domain", async () => {
    await assertSucceeds(
      allowedDomainGoogleApp.collection(projectsCollectionName).add(project)
    );
  });

  it("does not allow to read projects by an authenticated google user with not allowed email domain", async () => {
    await assertFails(
      notAllowedDomainGoogleApp.collection(projectsCollectionName).get()
    );
  });

  it("allows reading projects by an authenticated google user with allowed email domain", async () => {
    await assertSucceeds(
      allowedDomainGoogleApp.collection(projectsCollectionName).get()
    );
  });

  it("does not allow to update a project by an authenticated google user with not allowed email domain", async () => {
    await assertFails(
      notAllowedDomainGoogleApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  it("allows updating a project by an authenticated google user with allowed email domain", async () => {
    await assertSucceeds(
      allowedDomainGoogleApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  /**
   * The password auth provider user specific tests
   */

  it("allows creating a project by an authenticated password user with allowed email domain", async () => {
    await assertSucceeds(
      allowedDomainPasswordApp.collection(projectsCollectionName).add(project)
    );
  });

  it("allows creating a project by an authenticated password user with not allowed email domain", async () => {
    await assertSucceeds(
      notAllowedDomainPasswordApp
        .collection(projectsCollectionName)
        .add(project)
    );
  });

  it("allows reading projects by an authenticated password user with allowed email domain", async () => {
    await assertSucceeds(
      allowedDomainPasswordApp.collection(projectsCollectionName).get()
    );
  });

  it("allows reading projects by an authenticated password user with not allowed email domain", async () => {
    await assertSucceeds(
      notAllowedDomainPasswordApp.collection(projectsCollectionName).get()
    );
  });

  it("allows updating a project by an authenticated password user with allowed email domain", async () => {
    await assertSucceeds(
      allowedDomainPasswordApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  it("allows updating a project by an authenticated password user with not allowed email domain", async () => {
    await assertSucceeds(
      notAllowedDomainPasswordApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  it("does not allow to delete a project an authenticated password user with allowed email domain", async () => {
    await assertFails(
      allowedDomainPasswordApp
        .collection(projectsCollectionName)
        .doc("1")
        .delete()
    );
  });

  it("does not allow to delete a project an authenticated password user with not allowed email domain", async () => {
    await assertFails(
      notAllowedDomainPasswordApp
        .collection(projectsCollectionName)
        .doc("1")
        .delete()
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
