const {
  setupTestDatabaseWith,
  getApplication,
  tearDown,
} = require("./test_utils/helpers");
const { assertFails, assertSucceeds } = require("@firebase/testing");
const { getProjects, getUser } = require("./test_utils/mock-data");

describe("Database rules", async () => {
  const app = await getApplication(getUser());

  before(async () => {
    await setupTestDatabaseWith(getProjects());
  });

  describe("Project rules", function () {
    it("allows reading projects by an authenticated user", async () => {
      await assertSucceeds(app.collection("projects").get());
    });

    it("does not allow to read projects by an unauthenticated user", async () => {
      const app = await getApplication(null);

      await assertFails(app.collection("projects").get());
    });

    it("does not allow to add projects without a name", async () => {
      await assertFails(app.collection("projects").add({}));
    });
  });

  after(async () => {
    await tearDown();
  });
});
