const {
  setupTestDatabaseWith,
  getApplicationWith,
  tearDown,
} = require("./test_utils/test-app-utils");
const { assertFails, assertSucceeds } = require("@firebase/testing");
const {
  passwordSignInProviderId,
  googleSignInProviderId,
  getAllowedEmailUser,
  getDeniedEmailUser,
  builds,
  getBuild,
  allowedEmailDomains,
} = require("./test_utils/test-data");
const firestore = require("firebase").firestore;

describe("Build collection rules", async () => {
  const passwordProviderAllowedDomainApp = await getApplicationWith(
    getAllowedEmailUser(passwordSignInProviderId)
  );
  const passwordProviderNotAllowedDomainApp = await getApplicationWith(
    getDeniedEmailUser(passwordSignInProviderId)
  );
  const googleProviderAllowedDomainApp = await getApplicationWith(
    getAllowedEmailUser(googleSignInProviderId)
  );
  const googleProviderNotAllowedDomainApp = await getApplicationWith(
    getDeniedEmailUser(googleSignInProviderId)
  );

  const unauthenticatedApp = await getApplicationWith(null);
  const buildsCollectionName = "build";

  before(async () => {
    await setupTestDatabaseWith(Object.assign({}, builds, allowedEmailDomains));
  });

  /**
   * Common tests
   */

  it("does not allow creating a build with not allowed fields", async () => {
    let build = getBuild();
    build.test = "test";

    await assertFails(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow creating a build with not existing project id", async () => {
    let build = getBuild();
    build.projectId = "non-existing-id";

    await assertFails(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow creating a build with null projectId", async () => {
    let build = getBuild();
    build.projectId = null;

    await assertFails(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow creating a build when projectId is not a string", async () => {
    let build = getBuild();
    build.projectId = 2;

    await assertFails(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow creating a build if the startedAt is null", async () => {
    let build = getBuild();
    build.startedAt = null;

    await assertFails(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow creating a build if the startedAt is not a timestamp", async () => {
    const build = getBuild();
    build.startedAt = Date();

    await assertFails(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow creating builds if the startedAt value is after the current timestamp", async () => {
    let date = new Date();
    date.setDate(date.getDate() + 1);

    let build = getBuild();
    build.startedAt = firestore.Timestamp.fromDate(date);

    await assertFails(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow creating builds if the duration is null", async () => {
    let build = getBuild();
    build.duration = null;

    await assertFails(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow creating a build if the duration is not an integer", async () => {
    let build = getBuild();
    build.duration = "123";

    await assertFails(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow creating a build if the url is null", async () => {
    let build = getBuild();
    build.url = null;

    await assertFails(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow creating a build if the url is not a string", async () => {
    let build = getBuild();
    build.url = 2;

    await assertFails(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow creating a build if the build number is not an int", async () => {
    let build = getBuild();
    build.buildNumber = "2";

    await assertFails(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow creating a build if the build number is null", async () => {
    let build = getBuild();
    build.buildNumber = null;

    await assertFails(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow creating a build with not valid build status value", async () => {
    let build = getBuild();
    build.buildStatus = "test";

    await assertFails(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).add(build)
    );
  });

  it("allows to create a build with null build status", async () => {
    let build = getBuild();
    build.buildStatus = null;

    await assertSucceeds(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow creating a build when workflow name is not a string", async () => {
    let build = getBuild();
    build.workflowName = 2;

    await assertFails(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).add(build)
    );
  });

  it("allows to create a build when workflow name is null", async () => {
    let build = getBuild();
    build.workflowName = null;

    await assertSucceeds(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow creating a build when the coverage is grater then 1.0", async () => {
    let build = getBuild();
    build.coverage = 1.1;

    await assertFails(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow creating a build when the coverage is less then 0.0", async () => {
    let build = getBuild();
    build.coverage = -1.0;

    await assertFails(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).add(build)
    );
  });

  it("allows to create a build when the coverage is null", async () => {
    let build = getBuild();
    build.coverage = null;

    await assertSucceeds(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).add(build)
    );
  });

  /**
   * The password auth provider user specific tests
   */

  it("allows to create a build by an authenticated with a password and allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).add(getBuild())
    );
  });

  it("allows reading builds by an authenticated with a password and allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderAllowedDomainApp.collection(buildsCollectionName).get()
    );
  });

  it("allows updating a build by an authenticated with a password and allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderAllowedDomainApp
        .collection(buildsCollectionName)
        .doc("1")
        .update({ url: "updated" })
    );
  });

  it("does not allow deleting a build by an authenticated with a password and allowed email domain user", async () => {
    await assertFails(
      passwordProviderAllowedDomainApp
        .collection(buildsCollectionName)
        .doc("1")
        .delete()
    );
  });

  it("allows to create a build by an authenticated with a password and not allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderNotAllowedDomainApp
        .collection(buildsCollectionName)
        .add(getBuild())
    );
  });

  it("allows reading builds by an authenticated with a password and not allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderNotAllowedDomainApp.collection(buildsCollectionName).get()
    );
  });

  it("allows to update a build by an authenticated with a password and not allowed email domain user", async () => {
    await assertSucceeds(
      passwordProviderNotAllowedDomainApp
        .collection(buildsCollectionName)
        .doc("1")
        .update({ url: "updated" })
    );
  });

  it("does not allow deleting a build by an authenticated with a password and not allowed email domain user", async () => {
    await assertFails(
      passwordProviderNotAllowedDomainApp
        .collection(buildsCollectionName)
        .doc("1")
        .delete()
    );
  });

  /**
   * The google auth provider user specific tests
   */

  it("allows to create a build by an authenticated with google and an allowed email domain user", async () => {
    await assertSucceeds(
      googleProviderAllowedDomainApp.collection(buildsCollectionName).add(getBuild())
    );
  });

  it("allows reading builds by an authenticated with google and an allowed email domain user", async () => {
    await assertSucceeds(
      googleProviderAllowedDomainApp.collection(buildsCollectionName).get()
    );
  });

  it("allows to update a build by an authenticated with google and an allowed email domain user", async () => {
    await assertSucceeds(
      googleProviderAllowedDomainApp
        .collection(buildsCollectionName)
        .doc("1")
        .update({ url: "updated" })
    );
  });

  it("does not allow deleting a build by an authenticated with google and an allowed email domain user", async () => {
    await assertFails(
      googleProviderAllowedDomainApp.collection(buildsCollectionName).doc("1").delete()
    );
  });

  it("does not allow creating a build by an authenticated with google and not allowed email domain user", async () => {
    await assertFails(
      googleProviderNotAllowedDomainApp.collection(buildsCollectionName).add(getBuild())
    );
  });

  it("does not allow reading builds by an authenticated with google and not allowed email domain user", async () => {
    await assertFails(
      googleProviderNotAllowedDomainApp.collection(buildsCollectionName).get()
    );
  });

  it("does not allow updating a build by an authenticated with google and with not allowed email domain user", async () => {
    await assertFails(
      googleProviderNotAllowedDomainApp
        .collection(buildsCollectionName)
        .doc("1")
        .update({ url: "updated" })
    );
  });

  it("does not allow deleting a build by an authenticated with google and not allowed email domain user", async () => {
    await assertFails(
      googleProviderNotAllowedDomainApp
        .collection(buildsCollectionName)
        .doc("1")
        .delete()
    );
  });

  /**
   * The unauthenticated user specific tests
   */

  it("does not allow creating a build by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(buildsCollectionName).add(getBuild())
    );
  });

  it("does not allow reading builds by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(buildsCollectionName).get()
    );
  });

  it("does not allow updating a build by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp
        .collection(buildsCollectionName)
        .doc("1")
        .update({ url: "updated" })
    );
  });

  it("does not allow deleting a build by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(buildsCollectionName).doc("1").delete()
    );
  });

  after(async () => {
    await tearDown();
  });
});
