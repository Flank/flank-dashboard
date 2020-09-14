const async = require('async');
const { assertFails } = require("@firebase/testing");
const {
  setupTestDatabaseWith,
  getApplicationWith,
  tearDown,
} = require("./test_utils/test-app-utils");
const {
  allowedEmailDomains, getAllowedEmailUser, passwordSignInProviderId
} = require("./test_utils/test-data");

describe("", async () => {
  const collection = "allowed_email_domains";
  const domain = { "test.com": {} };

  const users = [
    {
      'describe': 'Authenticated user',
      'app': await getApplicationWith(
        getAllowedEmailUser(passwordSignInProviderId)
      ),
      'can': {
        'create': false,
        'read': false,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Unauthenticated user',
      'app': await getApplicationWith(null),
      'can': {
        'create': false,
        'read': false,
        'update': false,
        'delete': false,
      }
    },
  ];

  before(async () => {
    await setupTestDatabaseWith(allowedEmailDomains);
  });

  describe("Allowed email domains collection rules", () => {
    async.forEach(users, (user, callback) => {
      describe(user.describe, function () {
        let canCreateDescription = user.can.create ?
          "allows to create an allowed email domain" :
          "does not allow creating an allowed email domain";
        let canReadDescription = user.can.read ?
          "allows reading allowed email domains" :
          "does not allow reading an allowed email domains";
        let canUpdateDescription = user.can.update ?
          "allows to update an allowed email domain" :
          "does not allow updating an allowed email domain";
        let canDeleteDescription = user.can.delete ?
          "allows to delete an allowed email domain" :
          "does not allow deleting an allowed email domain";

        it(canCreateDescription, async () => {
          const createPromise = user.app.collection(collection).add(domain);

          if (user.can.create) {
            await assertSucceeds(createPromise)
          } else {
            await assertFails(createPromise)
          }
        });

        it(canReadDescription, async () => {
          const readPromise = user.app.collection(collection).get();

          if (user.can.read) {
            await assertSucceeds(readPromise)
          } else {
            await assertFails(readPromise)
          }
        });

        it(canUpdateDescription, async () => {
          const updatePromise = user.app
            .collection(collection)
            .doc("gmail.com")
            .update({ test: "updated" });

          if (user.can.update) {
            await assertSucceeds(updatePromise)
          } else {
            await assertFails(updatePromise)
          }
        });

        it(canDeleteDescription, async () => {
          const deletePromise =
            user.app.collection(collection).doc("gmail.com").delete();

          if (user.can.delete) {
            await assertSucceeds(deletePromise)
          } else {
            await assertFails(deletePromise)
          }
        });
      });
      callback();
    });
  });

  after(async () => {
    await tearDown();
  });
});
