const { assertFails } = require("@firebase/testing");
const {
  setupTestDatabaseWith,
  getApplicationWith,
  tearDown,
} = require("./test_utils/test-app-utils");
const {
  allowedEmailDomains, getAllowedEmailDomainUser, passwordSignInProviderId
} = require("./test_utils/test-data");

describe("Allowed email domains collection rules", async () => {
  const authenticatedApp = await getApplicationWith(
    getAllowedEmailDomainUser(passwordSignInProviderId)
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

  it("does not allow to create an allowed email domain by an authenticated user", async () => {
    await assertFails(
      authenticatedApp.collection(collectionName).add(domain)
    );
  });

  it("does not allow to read an allowed email domain by an authenticated user", async () => {
    await assertFails(
      authenticatedApp.collection(collectionName).get()
    );
  });

  it("does not allow to update an allowed email domain by an authenticated user", async () => {
    await assertFails(
      authenticatedApp
        .collection(collectionName)
        .doc("gmail.com")
        .update({ test: "updated" })
    );
  });

  it("does not allow to delete an allowed email domain by an authenticated user", async () => {
    await assertFails(
      authenticatedApp.collection(collectionName).doc("gmail.com").delete()
    );
  });

  /**
   * The unauthenticated user specific tests
   */

  it("does not allow to create an allowed email domain by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(collectionName).add(domain)
    );
  });

  it("does not allow to read allowed email domains by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(collectionName).get()
    );
  });

  it("does not allow to update an allowed email domain by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp
        .collection(collectionName)
        .doc("gmail.com")
        .update({ test: "updated" })
    );
  });

  it("does not allow to delete an allowed email domain by an unauthenticated user", async () => {
    await assertFails(
      unauthenticatedApp.collection(collectionName).doc("gmail.com").delete()
    );
  });

  after(async () => {
    await tearDown();
  });
});
