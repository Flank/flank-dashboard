const async = require("async");
const { assertFails, assertSucceeds } = require("@firebase/testing");
const {
  setupTestDatabaseWith,
  getApplicationWith,
  tearDown,
} = require("./test_utils/test-app-utils");

const {
  instantConfig,
  allowedEmailDomains,
  passwordSignInProviderId,
  googleSignInProviderId,
  getAllowedEmailUser,
  getDeniedEmailUser,
} = require("./test_utils/test-data");

describe("", async () => {
  const unauthenticatedApp = await getApplicationWith(null);
  const collection = "instant_config";
  const config = { config: {} };

  const users = [
    {
      'describe': 'Authenticated with a password and allowed email domain user with a verified email',
      'app': await getApplicationWith(
          getAllowedEmailUser(passwordSignInProviderId, true)
      ),
      'can': {
        'create': false,
        'read': true,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a password and not allowed email domain user with a verified email',
      'app': await getApplicationWith(
        getDeniedEmailUser(passwordSignInProviderId, true)
      ),
      'can': {
        'create': false,
        'read': true,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a password and allowed email domain user with not verified email',
      'app': await getApplicationWith(
        getAllowedEmailUser(passwordSignInProviderId, false)
      ),
      'can': {
        'create': false,
        'read': true,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a password and not allowed email domain user with not verified email',
      'app': await getApplicationWith(
        getDeniedEmailUser(passwordSignInProviderId, false)
      ),
      'can': {
        'create': false,
        'read': true,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with google and allowed email domain user with a verified email',
      'app': await getApplicationWith(
        getAllowedEmailUser(googleSignInProviderId, true)
      ),
      'can': {
        'create': false,
        'read': true,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with google and not allowed email domain user with a verified email',
      'app': await getApplicationWith(
        getDeniedEmailUser(googleSignInProviderId, true)
      ),
      'can': {
        'create': false,
        'read': true,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with google and allowed email domain user with not verified email',
      'app': await getApplicationWith(
        getAllowedEmailUser(googleSignInProviderId, false)
      ),
      'can': {
        'create': false,
        'read': true,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with google and not allowed email domain user with not verified email',
      'app': await getApplicationWith(
        getDeniedEmailUser(googleSignInProviderId, false)
      ),
      'can': {
        'create': false,
        'read': true,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Unauthenticated user',
      'app': unauthenticatedApp,
      'can': {
        'create': false,
        'read': true,
        'update': false,
        'delete': false,
      }
    },
  ];

  before(async () => {
    await setupTestDatabaseWith(
      Object.assign({}, instantConfig, allowedEmailDomains)
    );
  });

  describe("Instant config collection rules", () => {
    async.forEach(users, (user, callback) => {
      describe(user.describe, function () {
        let canCreateDescription = user.can.create
          ? "allows to create an instant config"
          : "does not allow creating an instant config";
        let canReadDescription = user.can.read
          ? "allows reading an instant config"
          : "does not allow reading an instant configs";
        let canUpdateDescription = user.can.update
          ? "allows to update an instant config"
          : "does not allow updating an instant config";
        let canDeleteDescription = user.can.delete
          ? "allows to delete an instant config"
          : "does not allow deleting an instant config";

        it(canCreateDescription, async () => {
          const createPromise = user.app.collection(collection).add(config);

          if (user.can.create) {
            await assertSucceeds(createPromise);
          } else {
            await assertFails(createPromise);
          }
        });

        it(canReadDescription, async () => {
          const getPromise = user.app
            .collection(collection)
            .doc(collection)
            .get();

          if (user.can.read) {
            await assertSucceeds(getPromise);
          } else {
            await assertFails(getPromise);
          }
        });

        it(canUpdateDescription, async () => {
          const updatePromise = user.app
            .collection(collection)
            .doc(collection)
            .update(config);

          if (user.can.update) {
            await assertSucceeds(updatePromise);
          } else {
            await assertFails(updatePromise);
          }
        });

        it(canDeleteDescription, async () => {
          const deletePromise = user.app
            .collection(collection)
            .doc(collection)
            .delete();

          if (user.can.delete) {
            await assertSucceeds(deletePromise);
          } else {
            await assertFails(deletePromise);
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
