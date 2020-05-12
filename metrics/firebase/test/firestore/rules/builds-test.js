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

  it("allows reading builds by an authenticated user", async () => {
    await assertSucceeds(
      authenticatedApp.collection(buildsCollectionName).get()
    );
  });

  it("does not allow to read builds by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(buildsCollectionName).get()
    );
  });

  it("allows creating a build by an authenticated user", async () => {
    await assertSucceeds(
      authenticatedApp.collection(buildsCollectionName).add(getBuild())
    );
  });

  it("does not allow to create a build by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(buildsCollectionName).add(getBuild())
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

  it("does not allow to update a build by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp
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

  it("does not allow to delete a build by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(buildsCollectionName).doc("1").delete()
    );
  });

  it("does not allow to add a build with not existing project id", async () => {
    let build = getBuild();
    build.projectId = "non-existing-id";

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

  after(async () => {
    await tearDown();
  });
});
