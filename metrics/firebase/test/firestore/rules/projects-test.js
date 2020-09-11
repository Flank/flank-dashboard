const {
  setupTestDatabaseWith,
  getApplicationWith,
  tearDown,
} = require("./test_utils/test-app-utils");
const { assertFails, assertSucceeds } = require("@firebase/testing");
const {
  project,
  projects,
  getAllowedEmailUser,
  getDeniedEmailUser,
  passwordSignInProviderId,
  googleSignInProviderId,
  allowedEmailDomains,
} = require("./test_utils/test-data");

describe("Projects collection rules", async function () {
  const passwordProviderAllowedEmailApp = await getApplicationWith(
    getAllowedEmailUser(passwordSignInProviderId)
  );
  const passwordProviderNotAllowedEmailApp = await getApplicationWith(
    getDeniedEmailUser(passwordSignInProviderId)
  );
  const passwordProviderNotVerifiedEmailApp = await getApplicationWith(
    getAllowedEmailUser(passwordSignInProviderId, false)
  );
  const googleProviderAllowedEmailApp = await getApplicationWith(
    getAllowedEmailUser(googleSignInProviderId)
  );
  const googleProviderNotAllowedEmailApp = await getApplicationWith(
    getDeniedEmailUser(googleSignInProviderId)
  );
  const googleProviderNotVerifiedEmailApp = await getApplicationWith(
    getAllowedEmailUser(googleSignInProviderId, false)
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
    await assertFails(passwordProviderAllowedEmailApp.collection("projects").add({}));
  });

  /**
   * The password auth provider user specific tests
   */

  it("allows to create a project by an authenticated with a password and allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderAllowedEmailApp.collection(projectsCollectionName).add(project)
    );
  });

  it("allows to create a project by an authenticated with a password and allowed email domain user with not verified email", async () => {
    await assertSucceeds(
      passwordProviderNotVerifiedEmailApp.collection(projectsCollectionName).add(project)
    );
  });

  it("allows reading projects by an authenticated with a password and allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderAllowedEmailApp.collection(projectsCollectionName).get()
    );
  });

  it("allows reading projects by an authenticated with a password and allowed email domain user with not verified email", async () => {
    await assertSucceeds(
      passwordProviderNotVerifiedEmailApp.collection(projectsCollectionName).get()
    );
  });

  it("allows to update a project by an authenticated with a password and allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderAllowedEmailApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  it("allows to update a project by an authenticated with a password and allowed email domain user with not verified email", async () => {
    await assertSucceeds(
      passwordProviderNotVerifiedEmailApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  it("does not allow deleting a project an authenticated with a password and allowed email domain user", async () => {
    await assertFails(
      passwordProviderAllowedEmailApp
        .collection(projectsCollectionName)
        .doc("1")
        .delete()
    );
  });

  it("allows to create a project by an authenticated with a password and not allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderNotAllowedEmailApp
        .collection(projectsCollectionName)
        .add(project)
    );
  });

  it("allows reading projects by an authenticated with a password and not allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderNotAllowedEmailApp.collection(projectsCollectionName).get()
    );
  });

  it("allows to update a project by an authenticated with a password and not allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderNotAllowedEmailApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  it("does not allow deleting a project an authenticated with a password and not allowed email domain user", async () => {
    await assertFails(
      passwordProviderNotAllowedEmailApp
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
      googleProviderAllowedEmailApp.collection(projectsCollectionName).add(project)
    );
  });

  it("does not allow creating a project by an authenticated with google and allowed email domain user with not verified email", async () => {
    await assertFails(
      googleProviderNotVerifiedEmailApp.collection(projectsCollectionName).add(project)
    );
  });

  it("allows reading projects by an authenticated with google and allowed email domain user", async () => {
    await assertSucceeds(
      googleProviderAllowedEmailApp.collection(projectsCollectionName).get()
    );
  });

  it("does not allow reading projects by an authenticated with google and allowed email domain user with not verified email", async () => {
    await assertFails(
      googleProviderNotVerifiedEmailApp.collection(projectsCollectionName).get()
    );
  });

  it("allows updating a project by an authenticated with google and allowed email domain user", async () => {
    await assertSucceeds(
      googleProviderAllowedEmailApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  it("does not allow updating a project by an authenticated with google and allowed email domain user with not verified email", async () => {
    await assertFails(
      googleProviderNotVerifiedEmailApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  it("does not allow deleting a project an authenticated with google and allowed email domain user", async () => {
    await assertFails(
      googleProviderAllowedEmailApp
        .collection(projectsCollectionName)
        .doc("1")
        .delete()
    );
  });

  it("does not allow deleting a project an authenticated with google and allowed email domain user with not verified email", async () => {
    await assertFails(
      googleProviderNotVerifiedEmailApp
        .collection(projectsCollectionName)
        .doc("1")
        .delete()
    );
  });

  it("does not allow creating a project by an authenticated with google and not allowed email domain user", async () => {
    await assertFails(
      googleProviderNotAllowedEmailApp.collection(projectsCollectionName).add(project)
    );
  });


  it("does not allow reading projects by an authenticated with google and not allowed email domain user", async () => {
    await assertFails(
      googleProviderNotAllowedEmailApp.collection(projectsCollectionName).get()
    );
  });

  it("does not allow updating a project by an authenticated with google and not allowed email domain user", async () => {
    await assertFails(
      googleProviderNotAllowedEmailApp
        .collection(projectsCollectionName)
        .doc("1")
        .update(project)
    );
  });

  it("does not allow deleting a project by an authenticated with google and not allowed email domain user", async () => {
    await assertFails(
      googleProviderNotAllowedEmailApp
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
