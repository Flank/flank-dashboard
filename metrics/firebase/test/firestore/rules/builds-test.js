const {
  setupTestDatabaseWith,
  getApplication,
  tearDown,
} = require("./test_utils/helpers");
const { assertFails, assertSucceeds } = require("@firebase/testing");
const { getUser, getBuilds, getBuild } = require("./test_utils/mock-data");
const firestore = require("firebase").firestore;

describe("Database rules", async () => {
  const app = await getApplication(getUser());

  before(async () => {
    await setupTestDatabaseWith(getBuilds());
  });

  describe("Build rules", async () => {
    it("allows adding build by an authenticated user", async () => {
      await assertSucceeds(app.collection("build").add(getBuild()));
    });

    it("does not allow to read a build by an unauthenticated user", async () => {
      const app = await getApplication(null);

      await assertFails(app.collection("build").get());
    });

    it("does not allow to add a build with not existing project id", async () => {
      const build = Object.assign(getBuild(), {
        projectId: "non-existing-id",
      });

      await assertFails(app.collection("build").add(build));
    });

    it("does not allow to add a build if the startedAt is null", async () => {
      const build = Object.assign(getBuild(), {
        startedAt: null,
      });

      await assertFails(app.collection("build").add(build));
    });

    it("does not allow to add a build if the startedAt is not a timestamp", async () => {
      const build = Object.assign(getBuild(), {
        startedAt: Date(),
      });

      await assertFails(app.collection("build").add(build));
    });

    it("does not allow to add builds if the startedAt value is after the current timestamp", async () => {
      let date = new Date();
      date.setDate(date.getDate() + 1);

      const build = Object.assign(getBuild(), {
        startedAt: firestore.Timestamp.fromDate(date),
      });

      await assertFails(app.collection("build").add(build));
    });

    it("does not allow to add builds if the duration is null", async () => {
      const build = Object.assign(getBuild(), {
        duration: null,
      });

      await assertFails(app.collection("build").add(build));
    });

    it("does not allow to add builds if the duration is not an integer", async () => {
      const build = Object.assign(getBuild(), {
        duration: "123",
      });

      await assertFails(app.collection("build").add(build));
    });

    it("does not allow to add builds if the url is null", async () => {
      const build = Object.assign(getBuild(), {
        url: null,
      });

      await assertFails(app.collection("build").add(build));
    });
  });

  after(async () => {
    await tearDown();
  });
});
