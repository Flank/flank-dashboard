const { assertFails } = require("@firebase/testing");
const {
  setupTestDatabaseWith,
  getApplicationWith,
  tearDown,
} = require("./test_utils/test-app-utils");
const {
  allowedEmailDomains, getAllowedEmailUser, passwordSignInProviderId
} = require("./test_utils/test-data");

describe("Allowed email domains collection rules", async () => {
  const authenticatedApp = await getApplicationWith(
    getAllowedEmailUser(passwordSignInProviderId)
  );
  const unauthenticatedApp = await getApplicationWith(null);
  const collectionName = "allowed_email_domains";
  const domain = { "test.com": {} };

  before(async () => {
    await setupTestDatabaseWith(allowedEmailDomains);
  });

  /**
   * The authenticated user specific tests
   */

  it("does not allow creating an allowed email domain by an authenticated user", async () => {
    await assertFails(
      authenticatedApp.collection(collectionName).add(domain)
    );
  });

  it("does not allow reading an allowed email domain by an authenticated user", async () => {
    await assertFails(
      authenticatedApp.collection(collectionName).get()
    );
  });

  it("does not allow updating an allowed email domain by an authenticated user", async () => {
    await assertFails(
      authenticatedApp
        .collection(collectionName)
        .doc("gmail.com")
        .update({ test: "updated" })
    );
  });

  it("does not allow deleting an allowed email domain by an authenticated user", async () => {
    await assertFails(
      authenticatedApp.collection(collectionName).doc("gmail.com").delete()
    );
  });

  /**
   * The unauthenticated user specific tests
   */

  it("does not allow creating an allowed email domain by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(collectionName).add(domain)
    );
  });

  it("does not allow reading allowed email domains by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(collectionName).get()
    );
  });

  it("does not allow updating an allowed email domain by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp
        .collection(collectionName)
        .doc("gmail.com")
        .update({ test: "updated" })
    );
  });

  it("does not allow deleting an allowed email domain by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(collectionName).doc("gmail.com").delete()
    );
  });

  after(async () => {
    await tearDown();
  });
});
