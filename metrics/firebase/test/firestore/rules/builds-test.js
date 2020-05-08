const {
  setupTestDatabase,
  getApplication,
  tearDown,
} = require("./test_utils/helpers");
const { assertFails, assertSucceeds } = require("@firebase/testing");

const { getBuilds, getUser, getBuild } = require("./test_utils/mock-data");

const firestore = require("firebase").firestore;

describe("Database rules", async () => {
  const app = await getApplication(getUser());

  before(async () => {
    await setupTestDatabase(getBuilds());
  });

  describe("Build rules", async () => {
    it("does not allow to read builds by unauthenticated user", async () => {
      const app = await getApplication(null);

      await assertFails(app.collection("build").get());
    });

    it("allows to add builds by authenticated users", async () => {
      await assertSucceeds(app.collection("build").add(getBuild()));
    });

    it("does not allow to add builds with not existing project id", async () => {
      const build = Object.assign(getBuild(), {
        projectId: "non-existing-id",
      });

      await assertFails(app.collection("build").add(build));
    });

    it("does not allow to add builds if startedAt is null", async () => {
      const build = getBuild();
      delete build.startedAt;

      await assertFails(app.collection("build").add(build));
    });

    it("does not allow to add builds if the startedAt is not a timestamp", async () => {
      const build = Object.assign(getBuild(), {
        startedAt: Date(),
      });

      await assertFails(app.collection("build").add(build));
    });

    it("does not allow to add builds if the startedAt value is after the current timestamp", async () => {
      var dateInTheFuture = new Date();
      dateInTheFuture.setDate(dateInTheFuture.getDate() + 1);

      const build = Object.assign(getBuild(), {
        startedAt: firestore.Timestamp.fromDate(dateInTheFuture),
      });

      await assertFails(app.collection("build").add(build));
    });

    it("does not allow to add builds if the duration is null", async () => {
      const build = getBuild();
      delete build.duration;

      await assertFails(app.collection("build").add(build));
    });

    it("does not allow to add builds if the duration is not an integer", async () => {
      const build = Object.assign(getBuild(), {
        duration: "123",
      });

      await assertFails(app.collection("build").add(build));
    });

    it("does not allow to add builds if the url is null", async () => {
      const build = getBuild();
      delete build.url;

      await assertFails(app.collection("build").add(build));
    });
  });

  after(async () => {
    await tearDown();
  });
});
