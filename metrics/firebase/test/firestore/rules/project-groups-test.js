const {
  setupTestDatabaseWith,
  getApplicationWith,
  tearDown,
} = require("./test_utils/test-app-utils");
const { assertFails, assertSucceeds } = require("@firebase/testing");
const {
  projectGroups,
  getAllowedEmailDomainUser,
  getNotAllowedDomainUser,
  googleSignInProviderId,
  passwordSignInProviderId,
  allowedEmailDomains,
  getProjectGroup,
} = require("./test_utils/test-data");

describe("Project groups collection rules", async function () {
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
  const collectionName = "project_groups";

  before(async () => {
    await setupTestDatabaseWith(
      Object.assign({}, projectGroups, allowedEmailDomains)
    );
  });

  /**
   * Common tests
   */

  it("does not allow to create a project group with not allowed fields", async () => {
    await assertFails(
      allowedDomainPasswordApp.collection(collectionName).add({
        name: "name",
        projectIds: [],
        notAllowedField: "test",
      })
    );
  });

  it("does not allow to create a project group without a name", async () => {
    await assertFails(
      allowedDomainPasswordApp.collection(collectionName).add({
        projectIds: [],
      })
    );
  });

  it("does not allow to create a project group with a name having other than a string value", async () => {
    let names = [false, 123, []];

    names.forEach(async (name) => {
      await assertFails(
        allowedDomainPasswordApp
          .collection(collectionName)
          .add({ name, projectIds: [] })
      );
    });
  });

  it("does not allow to create a project group with a projectIds having other than a list value", () => {
    let projectIdsValues = [123, false, "test"];

    projectIdsValues.forEach(async (projectIds) => {
      await assertFails(
        allowedDomainPasswordApp
          .collection(collectionName)
          .add({ name: "test", projectIds })
      );
    });
  });

  it("allows updating a project group with name size less or equal than 255", async () => {
    const testName = "testName";

    await assertSucceeds(
      allowedDomainPasswordApp.collection(collectionName).doc("2").update({
        name: testName,
        projectIds: [],
      })
    );
  });

  it("allows updating a project group with project ids length less or equal than 20", async () => {
    const testProjectIds = ["1", "2"];

    await assertSucceeds(
      allowedDomainPasswordApp.collection(collectionName).doc("2").update({
        name: "name",
        projectIds: testProjectIds,
      })
    );
  });

  it("allows creating a project group with name size less or equal than 255", async () => {
    const testName = "testName";

    await assertSucceeds(
      allowedDomainPasswordApp.collection(collectionName).add({
        name: testName,
        projectIds: [],
      })
    );
  });

  it("allows creating a project group with project ids length less or equal than 20", async () => {
    const testProjectIds = ["1", "2"];

    await assertSucceeds(
      allowedDomainPasswordApp.collection(collectionName).add({
        name: "name",
        projectIds: testProjectIds,
      })
    );
  });

  it("does not allow updating a project group with name size greater than 255", async () => {
    const testName = "a".repeat(256);

    await assertFails(
      allowedDomainPasswordApp.collection(collectionName).doc("2").update({
        name: testName,
        projectIds: [],
      })
    );
  });

  it("does not allow updating a project group with project ids length greater than 20", async () => {
    const testProjectIds = [...Array(21)].map((_, i) => `${i}`);

    await assertFails(
      allowedDomainPasswordApp.collection(collectionName).doc("2").update({
        name: "name",
        projectIds: testProjectIds,
      })
    );
  });

  it("does not allow creating a project group with name size greater than 255", async () => {
    const testName = "a".repeat(256);

    await assertFails(
      allowedDomainPasswordApp.collection(collectionName).add({
        name: testName,
        projectIds: [],
      })
    );
  });

  it("does not allow creating a project group with project ids length greater than 20", async () => {
    const testProjectIds = [...Array(21)].map((_, i) => `${i}`);

    await assertFails(
      allowedDomainPasswordApp.collection(collectionName).add({
        name: "name",
        projectIds: testProjectIds,
      })
    );
  });

  /**
   * The google auth provider user specific tests
   */

  it("does not allow to create a project group by an authenticated google user with not allowed email domain", async () => {
    await assertFails(
      notAllowedDomainGoogleApp
        .collection(collectionName)
        .add(getProjectGroup())
    );
  });

  it("allows creating a project group by an authenticated google user with allowed email domain", async () => {
    await assertSucceeds(
      allowedDomainGoogleApp.collection(collectionName).add(getProjectGroup())
    );
  });

  it("does not allow to read project groups by an authenticated google user with not allowed email domain", async () => {
    await assertFails(
      notAllowedDomainGoogleApp.collection(collectionName).get()
    );
  });

  it("allows reading a project group by an authenticated google user with allowed email domain", async () => {
    await assertSucceeds(
      allowedDomainGoogleApp.collection(collectionName).get()
    );
  });

  it("does not allow to update a project group by an authenticated google user with not allowed email domain", async () => {
    await assertFails(
      notAllowedDomainGoogleApp
        .collection(collectionName)
        .doc("2")
        .update(getProjectGroup())
    );
  });

  it("allows updating a project group by an authenticated google user with allowed email domain", async () => {
    await assertSucceeds(
      allowedDomainGoogleApp
        .collection(collectionName)
        .doc("2")
        .update(getProjectGroup())
    );
  });

  it("does not allow to delete a project group by an authenticated google user with not allowed email domain", async () => {
    await assertFails(
      notAllowedDomainGoogleApp.collection(collectionName).doc("1").delete()
    );
  });

  it("allows deleting a project group by an authenticated google user with allowed email domain", async () => {
    await assertSucceeds(
      allowedDomainGoogleApp.collection(collectionName).doc("1").delete()
    );
  });

  /**
   * The password auth provider user specific tests
   */

  it("allows creating a project group by an authenticated password user with allowed email domain", async () => {
    await assertSucceeds(
      allowedDomainPasswordApp.collection(collectionName).add(getProjectGroup())
    );
  });

  it("allows creating a project group by an authenticated password user with not allowed email domain", async () => {
    await assertSucceeds(
      notAllowedDomainPasswordApp
        .collection(collectionName)
        .add(getProjectGroup())
    );
  });

  it("allows reading project groups by an authenticated password user with allowed email domain", async () => {
    await assertSucceeds(
      allowedDomainPasswordApp.collection(collectionName).get()
    );
  });

  it("allows reading project groups by an authenticated password user with not allowed email domain", async () => {
    await assertSucceeds(
      notAllowedDomainPasswordApp.collection(collectionName).get()
    );
  });

  it("allows updating a project group by an authenticated password user with allowed email domain", async () => {
    await assertSucceeds(
      allowedDomainPasswordApp
        .collection(collectionName)
        .doc("2")
        .update(getProjectGroup())
    );
  });

  it("allows updating a project group by an authenticated password user with not allowed email domain", async () => {
    await assertSucceeds(
      notAllowedDomainPasswordApp
        .collection(collectionName)
        .doc("2")
        .update(getProjectGroup())
    );
  });

  it("allows deleting a project group by an authenticated password user with allowed email domain", async () => {
    await assertSucceeds(
      allowedDomainPasswordApp.collection(collectionName).doc("1").delete()
    );
  });

  it("allows deleting a project group by an authenticated password user with not allowed email domain", async () => {
    await assertSucceeds(
      notAllowedDomainPasswordApp.collection(collectionName).doc("1").delete()
    );
  });

  /**
   * The unauthenticated user specific tests
   */

  it("does not allow to create a project group by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(collectionName).add(getProjectGroup())
    );
  });

  it("does not allow to read project groups by an unauthenticated user", async () => {
    await assertFails(unauthenticatedApp.collection(collectionName).get());
  });

  it("does not allow to update a project group by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp
        .collection(collectionName)
        .doc("2")
        .update(getProjectGroup())
    );
  });

  it("does not allow to delete a project group by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(collectionName).doc("1").delete()
    );
  });

  after(async () => {
    await tearDown();
  });
});
