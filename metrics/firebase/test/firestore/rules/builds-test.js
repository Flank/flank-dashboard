const {
  setupTestDatabaseWith,
  getApplicationWith,
  tearDown,
} = require("./test_utils/helpers");
const { assertFails, assertSucceeds } = require("@firebase/testing");
const { user, builds, getBuild } = require("./test_utils/test-data");
const firestore = require("firebase").firestore;

describe("Build collection rules", async () => {
  const app = await getApplicationWith(user);

  before(async () => {
    await setupTestDatabaseWith(builds);
  });

  it("allows adding build by an authenticated user", async () => {
    await assertSucceeds(app.collection("build").add(getBuild()));
  });

  it("does not allow to read a build by an unauthenticated user", async () => {
    const app = await getApplicationWith(null);

    await assertFails(app.collection("build").get());
  });

  it("does not allow to add a build with not existing project id", async () => {
    let build = getBuild();
    build.projectId = "non-existing-id";

    await assertFails(app.collection("build").add(build));
  });

  it("does not allow to add a build if the startedAt is null", async () => {
    let build = getBuild();
    build.startedAt = null;

    await assertFails(app.collection("build").add(build));
  });

  it("does not allow to add a build if the startedAt is not a timestamp", async () => {
    const build = getBuild();
    build.startedAt = Date();

    await assertFails(app.collection("build").add(build));
  });

  it("does not allow to add builds if the startedAt value is after the current timestamp", async () => {
    let date = new Date();
    date.setDate(date.getDate() + 1);

    let build = getBuild();
    build.startedAt = firestore.Timestamp.fromDate(date);

    await assertFails(app.collection("build").add(build));
  });

  it("does not allow to add builds if the duration is null", async () => {
    let build = getBuild();
    build.duration = null;

    await assertFails(app.collection("build").add(build));
  });

  it("does not allow to add builds if the duration is not an integer", async () => {
    let build = getBuild();
    build.duration = "123";

    await assertFails(app.collection("build").add(build));
  });

  it("does not allow to add builds if the url is null", async () => {
    let build = getBuild();
    build.url = null;

    await assertFails(app.collection("build").add(build));
  });

  it("does not allow to add builds if the url is not a string", async () => {
    let build = getBuild();
    build.url = 2;

    await assertFails(app.collection("build").add(build));
  });

  after(async () => {
    await tearDown();
  });
});
