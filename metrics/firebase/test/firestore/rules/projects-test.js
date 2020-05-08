const {
  setupTestDatabase,
  getApplication,
  tearDown,
} = require("./test_utils/helpers");
const { assertFails, assertSucceeds } = require("@firebase/testing");

const { getProjects, getUser } = require("./test_utils/mock-data");

describe("Database rules", async () => {
  const authenticatedApp = await getApplication(getUser());

  before(async () => {
    await setupTestDatabase(getProjects());
  });

  describe("Project rules", function () {
    it("does not allow to read the projects by unauthenticated user", async () => {
      const app = await getApplication(null);

      await assertFails(app.collection("projects").get());
    });

    it("allows to read projects by an authenticated user", async () => {
      await assertSucceeds(authenticatedApp.collection("projects").get());
    });

    it("does not allow to add projects without name", async () => {
      await assertFails(authenticatedApp.collection("projects").add({}));
    });
  });

  after(async () => {
    await tearDown();
  });
});
