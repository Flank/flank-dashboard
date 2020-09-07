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
    await assertFails(passwordProviderAllowedDomainApp.collection("projects").add({}));
  });

  /**
   * The password auth provider user specific tests
   */

  it("allows creating a project by an authenticated password user with allowed email domain", async () => {
    await assertSucceeds(
      passwordProviderAllowedDomainApp.collection(projectsCollectionName).add(project)
    );
  });

  it("allows reading projects by an authenticated password user with allowed email domain", async () => {
    await assertSucceeds(
      passwordProviderAllowedDomainApp.collection(projectsCollectionName).get()
    );
  });

  it("allows updating a project by an authenticated password user with allowed email domain", async () => {
    await assertSucceeds(
      passwordProviderAllowedDomainApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  it("does not allow to delete a project an authenticated password user with allowed email domain", async () => {
    await assertFails(
      passwordProviderAllowedDomainApp
        .collection(projectsCollectionName)
        .doc("1")
        .delete()
    );
  });

  it("allows creating a project by an authenticated password user with not allowed email domain", async () => {
    await assertSucceeds(
      passwordProviderNotAllowedDomainApp
        .collection(projectsCollectionName)
        .add(project)
    );
  });

  it("allows reading projects by an authenticated password user with not allowed email domain", async () => {
    await assertSucceeds(
      passwordProviderNotAllowedDomainApp.collection(projectsCollectionName).get()
    );
  });

  it("allows updating a project by an authenticated password user with not allowed email domain", async () => {
    await assertSucceeds(
      passwordProviderNotAllowedDomainApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  it("does not allow to delete a project an authenticated password user with not allowed email domain", async () => {
    await assertFails(
      passwordProviderNotAllowedDomainApp
        .collection(projectsCollectionName)
        .doc("1")
        .delete()
    );
  });

  /**
   * The google auth provider user specific tests
   */

  it("allows creating a project by an authenticated google user with allowed email domain", async () => {
    await assertSucceeds(
      googleProviderAllowedDomainApp.collection(projectsCollectionName).add(project)
    );
  });

  it("allows reading projects by an authenticated google user with allowed email domain", async () => {
    await assertSucceeds(
      googleProviderAllowedDomainApp.collection(projectsCollectionName).get()
    );
  });

  it("allows updating a project by an authenticated google user with allowed email domain", async () => {
    await assertSucceeds(
      googleProviderAllowedDomainApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  it("does not allow to delete a project an authenticated google user with allowed email domain", async () => {
    await assertFails(
      googleProviderAllowedDomainApp
        .collection(projectsCollectionName)
        .doc("1")
        .delete()
    );
  });

  it("does not allow to create a project by an authenticated google user with not allowed email domain", async () => {
    await assertFails(
      googleProviderNotAllowedDomainApp.collection(projectsCollectionName).add(project)
    );
  });

  it("does not allow to read projects by an authenticated google user with not allowed email domain", async () => {
    await assertFails(
      googleProviderNotAllowedDomainApp.collection(projectsCollectionName).get()
    );
  });

  it("does not allow to update a project by an authenticated google user with not allowed email domain", async () => {
    await assertFails(
      googleProviderNotAllowedDomainApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  it("does not allow to delete a project an authenticated google user with not allowed email domain", async () => {
    await assertFails(
      googleProviderNotAllowedDomainApp
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
