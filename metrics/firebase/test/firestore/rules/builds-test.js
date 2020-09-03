const {
  setupTestDatabaseWith,
  getApplicationWith,
  tearDown,
} = require("./test_utils/test-app-utils");
const { assertFails, assertSucceeds } = require("@firebase/testing");
const {
  passwordSignInProviderId,
  googleSignInProviderId,
  getAllowedEmailDomainUser,
  getNotAllowedDomainUser,
  builds,
  getBuild,
  allowedEmailDomains,
} = require("./test_utils/test-data");
const firestore = require("firebase").firestore;

describe("Build collection rules", async () => {
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
  const buildsCollectionName = "build";

  before(async () => {
    await setupTestDatabaseWith(Object.assign({}, builds, allowedEmailDomains));
  });

  /**
   * Common tests
   */

  it("does not allow to create a build with not allowed fields", async () => {
    let build = getBuild();
    build.test = "test";

    await assertFails(
      allowedDomainPasswordApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build with not existing project id", async () => {
    let build = getBuild();
    build.projectId = "non-existing-id";

    await assertFails(
      allowedDomainPasswordApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build with null projectId", async () => {
    let build = getBuild();
    build.projectId = null;

    await assertFails(
      allowedDomainPasswordApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build when projectId is not a string", async () => {
    let build = getBuild();
    build.projectId = 2;

    await assertFails(
      allowedDomainPasswordApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build if the startedAt is null", async () => {
    let build = getBuild();
    build.startedAt = null;

    await assertFails(
      allowedDomainPasswordApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build if the startedAt is not a timestamp", async () => {
    const build = getBuild();
    build.startedAt = Date();

    await assertFails(
      allowedDomainPasswordApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create builds if the startedAt value is after the current timestamp", async () => {
    let date = new Date();
    date.setDate(date.getDate() + 1);

    let build = getBuild();
    build.startedAt = firestore.Timestamp.fromDate(date);

    await assertFails(
      allowedDomainPasswordApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create builds if the duration is null", async () => {
    let build = getBuild();
    build.duration = null;

    await assertFails(
      allowedDomainPasswordApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build if the duration is not an integer", async () => {
    let build = getBuild();
    build.duration = "123";

    await assertFails(
      allowedDomainPasswordApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build if the url is null", async () => {
    let build = getBuild();
    build.url = null;

    await assertFails(
      allowedDomainPasswordApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build if the url is not a string", async () => {
    let build = getBuild();
    build.url = 2;

    await assertFails(
      allowedDomainPasswordApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build if the build number is not an int", async () => {
    let build = getBuild();
    build.buildNumber = "2";

    await assertFails(
      allowedDomainPasswordApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build if the build number is null", async () => {
    let build = getBuild();
    build.buildNumber = null;

    await assertFails(
      allowedDomainPasswordApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build with not valid build status value", async () => {
    let build = getBuild();
    build.buildStatus = "test";

    await assertFails(
      allowedDomainPasswordApp.collection(buildsCollectionName).add(build)
    );
  });

  it("allows to create a build with null build status", async () => {
    let build = getBuild();
    build.buildStatus = null;

    await assertSucceeds(
      allowedDomainPasswordApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build when workflow name is not a string", async () => {
    let build = getBuild();
    build.workflowName = 2;

    await assertFails(
      allowedDomainPasswordApp.collection(buildsCollectionName).add(build)
    );
  });

  it("allows to create a build when workflow name is null", async () => {
    let build = getBuild();
    build.workflowName = null;

    await assertSucceeds(
      allowedDomainPasswordApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build when the coverage is grater then 1.0", async () => {
    let build = getBuild();
    build.coverage = 1.1;

    await assertFails(
      allowedDomainPasswordApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build when the coverage is less then 0.0", async () => {
    let build = getBuild();
    build.coverage = -1.0;

    await assertFails(
      allowedDomainPasswordApp.collection(buildsCollectionName).add(build)
    );
  });

  it("allows to create a build when the coverage is null", async () => {
    let build = getBuild();
    build.coverage = null;

    await assertSucceeds(
      allowedDomainPasswordApp.collection(buildsCollectionName).add(build)
    );
  });

  /**
   * The password auth provider user specific tests
   */

  it("allows to create a build by an authenticated password user with an allowed email domain", async () => {
    await assertSucceeds(
      allowedDomainPasswordApp.collection(buildsCollectionName).add(getBuild())
    );
  });

  it("allows to read builds by an authenticated password user with an allowed email domain", async () => {
    await assertSucceeds(
      allowedDomainPasswordApp.collection(buildsCollectionName).get()
    );
  });

  it("allows to update a build by an authenticated password user with an allowed email domain", async () => {
    await assertSucceeds(
      allowedDomainPasswordApp
        .collection(buildsCollectionName)
        .doc("1")
        .update({ url: "updated" })
    );
  });

  it("does not allow to delete a build by an authenticated password user with an allowed email domain", async () => {
    await assertFails(
      allowedDomainPasswordApp
        .collection(buildsCollectionName)
        .doc("1")
        .delete()
    );
  });

  it("allows to create a build by an authenticated password user with not allowed email domain", async () => {
    await assertSucceeds(
      notAllowedDomainPasswordApp
        .collection(buildsCollectionName)
        .add(getBuild())
    );
  });

  it("allows to read builds by an authenticated password user with not allowed email domain", async () => {
    await assertSucceeds(
      notAllowedDomainPasswordApp.collection(buildsCollectionName).get()
    );
  });

  it("allows to update a build by an authenticated password user with not allowed email domain", async () => {
    await assertSucceeds(
      notAllowedDomainPasswordApp
        .collection(buildsCollectionName)
        .doc("1")
        .update({ url: "updated" })
    );
  });

  it("does not allow to delete a by an authenticated password user build with not allowed email domain", async () => {
    await assertFails(
      notAllowedDomainPasswordApp
        .collection(buildsCollectionName)
        .doc("1")
        .delete()
    );
  });

  /**
   * The google auth provider user specific tests
   */

  it("allows to create a build by an authenticated google user with an allowed email domain", async () => {
    await assertSucceeds(
      allowedDomainGoogleApp.collection(buildsCollectionName).add(getBuild())
    );
  });

  it("allows to read builds by an authenticated google user with an allowed email domain", async () => {
    await assertSucceeds(
      allowedDomainGoogleApp.collection(buildsCollectionName).get()
    );
  });

  it("allows to update a build by an authenticated google user with an allowed email domain", async () => {
    await assertSucceeds(
      allowedDomainGoogleApp
        .collection(buildsCollectionName)
        .doc("1")
        .update({ url: "updated" })
    );
  });

  it("does not allow to delete a build by an authenticated google user with an allowed email domain", async () => {
    await assertFails(
      allowedDomainGoogleApp.collection(buildsCollectionName).doc("1").delete()
    );
  });

  it("does not allowed to create a build by an authenticated google user with not allowed email domain", async () => {
    await assertFails(
      notAllowedDomainGoogleApp.collection(buildsCollectionName).add(getBuild())
    );
  });

  it("does not allowed to read builds by an authenticated google user with not allowed email domain", async () => {
    await assertFails(
      notAllowedDomainGoogleApp.collection(buildsCollectionName).get()
    );
  });

  it("does not allowed to update a build by an authenticated google user with not allowed email domain", async () => {
    await assertFails(
      notAllowedDomainGoogleApp
        .collection(buildsCollectionName)
        .doc("1")
        .update({ url: "updated" })
    );
  });

  it("does not allowed to delete a build by an authenticated google user with not allowed email domain", async () => {
    await assertFails(
      notAllowedDomainGoogleApp
        .collection(buildsCollectionName)
        .doc("1")
        .delete()
    );
  });

  /**
   * The unauthenticated user specific tests
   */

  it("does not allow to create a build by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(buildsCollectionName).add(getBuild())
    );
  });

  it("does not allow to read builds by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(buildsCollectionName).get()
    );
  });

  it("does not allow to update a build by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp
        .collection(buildsCollectionName)
        .doc("1")
        .update({ url: "updated" })
    );
  });

  it("does not allow to delete a build by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(buildsCollectionName).doc("1").delete()
    );
  });

  after(async () => {
    await tearDown();
  });
});
