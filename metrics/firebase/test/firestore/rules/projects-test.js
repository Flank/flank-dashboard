const {
  setupTestDatabaseWith,
  getApplicationWith,
  tearDown,
} = require("./test_utils/helpers");
const { assertFails, assertSucceeds } = require("@firebase/testing");
const { projects, user } = require("./test_utils/test-data");

describe("Project collection rules", async function () {
  const app = await getApplicationWith(user);

  before(async () => {
    await setupTestDatabaseWith(projects);
  });

  it("allows reading projects by an authenticated user", async () => {
    await assertSucceeds(app.collection("projects").get());
  });

  it("allows adding projects by an authenticated user", async () => {
    await assertSucceeds(
      app.collection("projects").add({ name: "test_project" })
    );
  });

  it("does not allow to read projects by an unauthenticated user", async () => {
    const app = await getApplicationWith(null);

    await assertFails(app.collection("projects").get());
  });

  it("does not allow to add projects without a name", async () => {
    await assertFails(app.collection("projects").add({}));
  });

  after(async () => {
    await tearDown();
  });
});
