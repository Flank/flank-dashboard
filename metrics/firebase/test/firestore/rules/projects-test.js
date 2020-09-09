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

  it("does not allow creating a project with not allowed fields", async () => {
    await assertFails(
      unauthenticatedApp.collection(projectsCollectionName).add({
        name: "name",
        test: "test",
      })
    );
  });

  it("does not allow creating a project without a name", async () => {
    await assertFails(passwordProviderAllowedDomainApp.collection("projects").add({}));
  });

  /**
   * The password auth provider user specific tests
   */

  it("allows to create a project by an authenticated with a password and allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderAllowedDomainApp.collection(projectsCollectionName).add(project)
    );
  });

  it("allows reading projects by an authenticated with a password and allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderAllowedDomainApp.collection(projectsCollectionName).get()
    );
  });

  it("allows to update a project by an authenticated with a password and allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderAllowedDomainApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  it("does not allow deleting a project an authenticated with a password and allowed email domain user", async () => {
    await assertFails(
      passwordProviderAllowedDomainApp
        .collection(projectsCollectionName)
        .doc("1")
        .delete()
    );
  });

  it("allows to create a project by an authenticated with a password and not allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderNotAllowedDomainApp
        .collection(projectsCollectionName)
        .add(project)
    );
  });

  it("allows reading projects by an authenticated with a password and not allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderNotAllowedDomainApp.collection(projectsCollectionName).get()
    );
  });

  it("allows to update a project by an authenticated with a password and not allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderNotAllowedDomainApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  it("does not allow deleting a project an authenticated with a password and not allowed email domain user", async () => {
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

  it("allows to create a project by an authenticated with google and allowed email domain user", async () => {
    await assertSucceeds(
      googleProviderAllowedDomainApp.collection(projectsCollectionName).add(project)
    );
  });

  it("allows reading projects by an authenticated with google and allowed email domain user", async () => {
    await assertSucceeds(
      googleProviderAllowedDomainApp.collection(projectsCollectionName).get()
    );
  });

  it("allows updating a project by an authenticated with google and allowed email domain user", async () => {
    await assertSucceeds(
      googleProviderAllowedDomainApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  it("does not allow deleting a project an authenticated with google and allowed email domain user", async () => {
    await assertFails(
      googleProviderAllowedDomainApp
        .collection(projectsCollectionName)
        .doc("1")
        .delete()
    );
  });

  it("does not allow creating a project by an authenticated with google and not allowed email domain user", async () => {
    await assertFails(
      googleProviderNotAllowedDomainApp.collection(projectsCollectionName).add(project)
    );
  });

  it("does not allow reading projects by an authenticated with google and not allowed email domain user", async () => {
    await assertFails(
      googleProviderNotAllowedDomainApp.collection(projectsCollectionName).get()
    );
  });

  it("does not allow updating a project by an authenticated with google and not allowed email domain user", async () => {
    await assertFails(
      googleProviderNotAllowedDomainApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  it("does not allow deleting a project by an authenticated with google and not allowed email domain user", async () => {
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

  it("does not allow creating a project by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(projectsCollectionName).add(project)
    );
  });

  it("does not allow reading projects by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(projectsCollectionName).get()
    );
  });

  it("does not allow updating a project by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  it("does not allow deleting a project by unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(projectsCollectionName).doc("1").delete()
    );
  });

  after(async () => {
    await tearDown();
  });
});
