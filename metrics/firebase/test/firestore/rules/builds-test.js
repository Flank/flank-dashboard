const {
  setupTestDatabaseWith,
  getApplicationWith,
  tearDown,
} = require("./test_utils/test-app-utils");
const { assertFails, assertSucceeds } = require("@firebase/testing");
const { user, builds, getBuild } = require("./test_utils/test-data");
const firestore = require("firebase").firestore;

describe("Build collection rules", async () => {
  const authenticatedApp = await getApplicationWith(user);
  const unauthenticatedApp = await getApplicationWith(null);
  const buildsCollectionName = "build";

  before(async () => {
    await setupTestDatabaseWith(builds);
  });

  /**
   * Common tests
   */

  it("does not allow to create a build with not allowed fields", async () => {
    let build = getBuild();
    build.test = "test";

    await assertFails(
      authenticatedApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build with not existing project id", async () => {
    let build = getBuild();
    build.projectId = "non-existing-id";

    await assertFails(
      authenticatedApp.collection(buildsCollectionName).add(build)
    );
  });
  
  it("does not allow to create a build with null projectId", async () => {
    let build = getBuild();
    build.projectId = null;

    await assertFails(
      authenticatedApp.collection(buildsCollectionName).add(build)
    );
  });
  
  it("does not allow to create a build when projectId is not a string", async () => {
    let build = getBuild();
    build.projectId = 2;

    await assertFails(
      authenticatedApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build if the startedAt is null", async () => {
    let build = getBuild();
    build.startedAt = null;

    await assertFails(
      authenticatedApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build if the startedAt is not a timestamp", async () => {
    const build = getBuild();
    build.startedAt = Date();

    await assertFails(
      authenticatedApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create builds if the startedAt value is after the current timestamp", async () => {
    let date = new Date();
    date.setDate(date.getDate() + 1);

    let build = getBuild();
    build.startedAt = firestore.Timestamp.fromDate(date);

    await assertFails(
      authenticatedApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create builds if the duration is null", async () => {
    let build = getBuild();
    build.duration = null;

    await assertFails(
      authenticatedApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build if the duration is not an integer", async () => {
    let build = getBuild();
    build.duration = "123";

    await assertFails(
      authenticatedApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build if the url is null", async () => {
    let build = getBuild();
    build.url = null;

    await assertFails(
      authenticatedApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build if the url is not a string", async () => {
    let build = getBuild();
    build.url = 2;

    await assertFails(
      authenticatedApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build if the build number is not an int", async () => {
    let build = getBuild();
    build.buildNumber = "2";

    await assertFails(
      authenticatedApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build if the build number is null", async () => {
    let build = getBuild();
    build.buildNumber = null;

    await assertFails(
      authenticatedApp.collection(buildsCollectionName).add(build)
    );
  });

  it("does not allow to create a build with not valid build status value", async () => {
    let build = getBuild();
    build.buildStatus = "test";

    await assertFails(
      authenticatedApp.collection(buildsCollectionName).add(build)
    );
  });

  it("allows to create a build with null build status", async () => {
    let build = getBuild();
    build.buildStatus = null;

    await assertSucceeds(
      authenticatedApp.collection(buildsCollectionName).add(build)
    );
  });
  
  it("does not allow to create a build when workflow name is not a string", async () => {
    let build = getBuild();
    build.workflowName = 2;

    await assertFails(
      authenticatedApp.collection(buildsCollectionName).add(build)
    );
  });
  
  it("allows to create a build when workflow name is null", async () => {
    let build = getBuild();
    build.workflowName = null;

    await assertSucceeds(
      authenticatedApp.collection(buildsCollectionName).add(build)
    );
  });
  
  it("does not allow to create a build when the coverage is grater then 1.0", async () => {
    let build = getBuild();
    build.coverage = 1.1;

    await assertFails(
      authenticatedApp.collection(buildsCollectionName).add(build)
    );
  });
  
  it("does not allow to create a build when the coverage is less then 0.0", async () => {
    let build = getBuild();
    build.coverage = -1.0;

    await assertFails(
      authenticatedApp.collection(buildsCollectionName).add(build)
    );
  });
  
  it("allows to create a build when the coverage is null", async () => {
    let build = getBuild();
    build.coverage = null;

    await assertSucceeds(
      authenticatedApp.collection(buildsCollectionName).add(build)
    );
  });

  /**
   * The authenticated user specific tests
   */

  it("allows creating a build by an authenticated user", async () => {
    await assertSucceeds(
      authenticatedApp.collection(buildsCollectionName).add(getBuild())
    );
  });

  it("allows reading builds by an authenticated user", async () => {
    await assertSucceeds(
      authenticatedApp.collection(buildsCollectionName).get()
    );
  });

  it("allows updating a build by an authenticated user", async () => {
    await assertSucceeds(
      authenticatedApp
        .collection(buildsCollectionName)
        .doc("1")
        .update({ url: "updated" })
    );
  });

  it("does not allow to delete a build by an authenticated user", async () => {
    await assertFails(
      authenticatedApp.collection(buildsCollectionName).doc("1").delete()
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
