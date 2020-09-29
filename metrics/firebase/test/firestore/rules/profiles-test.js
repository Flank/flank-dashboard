const async = require('async');
const {
  setupTestDatabaseWith,
  getApplicationWith,
  tearDown,
} = require("./test_utils/test-app-utils");
const { assertFails, assertSucceeds } = require("@firebase/testing");
const {
  passwordSignInProviderId,
  googleSignInProviderId,
  getAllowedEmailUser,
  getDeniedEmailUser,
  profiles,
  getProfile,
  allowedEmailDomains,
} = require("./test_utils/test-data");

describe("", async () => {
  const collection = "profiles";
  const superUserApp = await getApplicationWith(
    getAllowedEmailUser(passwordSignInProviderId, true, '1')
  )

  const signInProviders = [
    {
      'title': 'password',
      'description': 'Authenticated with a password and ',
      'users': [
        {
          'description': 'allowed email domain user who is not an owner of the profile with not a verified email',
          'app': await getApplicationWith(
            getAllowedEmailUser(passwordSignInProviderId, false)
          ),
          'can': {
            'create': true,
            'read': false,
            'readSingle': false,
            'update': false,
            'delete': false,
          }
        },
        {
          'description': 'allowed email domain user who is an owner of the profile with not a verified email',
          'app': await getApplicationWith(
            getAllowedEmailUser(passwordSignInProviderId, false, '1')
          ),
          'can': {
            'create': true,
            'read': false,
            'readSingle': true,
            'update': true,
            'delete': false,
          }
        },
        {
          'description': 'allowed email domain user who is not an owner of the profile with a verified email',
          'app': await getApplicationWith(
            getAllowedEmailUser(passwordSignInProviderId, true)
          ),
          'can': {
            'create': true,
            'read': false,
            'readSingle': false,
            'update': false,
            'delete': false,
          }
        },
        {
          'description': 'not allowed email domain user who is an owner of the profile with not verified email',
          'app': await getApplicationWith(
            getDeniedEmailUser(passwordSignInProviderId, false, '1')
          ),
          'can': {
            'create': true,
            'read': false,
            'readSingle': true,
            'update': true,
            'delete': false,
          }
        },
        {
          'description': 'not allowed email domain user who is not an owner of the profile with a verified email',
          'app': await getApplicationWith(
            getDeniedEmailUser(passwordSignInProviderId, true)
          ),
          'can': {
            'create': true,
            'read': false,
            'readSingle': false,
            'update': false,
            'delete': false,
          }
        },
        {
          'description': 'not allowed email domain user who is not an owner of the profile with not a verified email',
          'app': await getApplicationWith(
            getDeniedEmailUser(passwordSignInProviderId, false)
          ),
          'can': {
            'create': true,
            'read': false,
            'readSingle': false,
            'update': false,
            'delete': false,
          }
        },
        {
          'description': 'allowed email domain user who is an owner of the profile with a verified email',
          'app': await getApplicationWith(
            getAllowedEmailUser(passwordSignInProviderId, true, '1')
          ),
          'can': {
            'create': true,
            'read': false,
            'readSingle': true,
            'update': true,
            'delete': false,
          }
        },
        {
          'description': 'not allowed email domain user who is an owner of the profile with a verified email',
          'app': await getApplicationWith(
            getDeniedEmailUser(passwordSignInProviderId, true, '1')
          ),
          'can': {
            'create': true,
            'read': false,
            'readSingle': true,
            'update': true,
            'delete': false,
          }
        },
      ]
    },
    {
      'title': 'google',
      'description': 'Authenticated with a google and ',
      'users': [
        {
          'description': 'not allowed email domain user who is an owner of the profile with a verified email',
          'app': await getApplicationWith(
            getAllowedEmailUser(googleSignInProviderId, false)
          ),
          'can': {
            'create': false,
            'read': false,
            'readSingle': false,
            'update': false,
            'delete': false,
          }
        },
        {
          'description': 'allowed email domain user who is not an owner of the profile with not a verified email',
          'app': await getApplicationWith(
            getAllowedEmailUser(googleSignInProviderId, false)
          ),
          'can': {
            'create': false,
            'read': false,
            'readSingle': false,
            'update': false,
            'delete': false,
          }
        },
        {
          'description': 'allowed email domain user who is an owner of the profile with not a verified email',
          'app': await getApplicationWith(
            getAllowedEmailUser(googleSignInProviderId, false, '1')
          ),
          'can': {
            'create': false,
            'read': false,
            'readSingle': false,
            'update': false,
            'delete': false,
          }
        },
        {
          'description': 'allowed email domain user who is not an owner of the profile with a verified email',
          'app': await getApplicationWith(
            getAllowedEmailUser(googleSignInProviderId, true)
          ),
          'can': {
            'create': true,
            'read': false,
            'readSingle': false,
            'update': false,
            'delete': false,
          }
        },
        {
          'description': 'not allowed email domain user who is an owner of the profile with not verified email',
          'app': await getApplicationWith(
            getDeniedEmailUser(googleSignInProviderId, false, '1')
          ),
          'can': {
            'create': false,
            'read': false,
            'readSingle': false,
            'update': false,
            'delete': false,
          }
        },
        {
          'description': 'not allowed email domain user who is not an owner of the profile with a verified email',
          'app': await getApplicationWith(
            getDeniedEmailUser(googleSignInProviderId, true)
          ),
          'can': {
            'create': false,
            'read': false,
            'readSingle': false,
            'update': false,
            'delete': false,
          }
        },
        {
          'description': 'not allowed email domain user who is not an owner of the profile with not a verified email',
          'app': await getApplicationWith(
            getDeniedEmailUser(googleSignInProviderId, false)
          ),
          'can': {
            'create': false,
            'read': false,
            'readSingle': false,
            'update': false,
            'delete': false,
          }
        },
        {
          'description': 'allowed email domain user who is an owner of the profile with a verified email',
          'app': await getApplicationWith(
            getAllowedEmailUser(googleSignInProviderId, true, '1')
          ),
          'can': {
            'create': true,
            'read': false,
            'readSingle': true,
            'update': true,
            'delete': false,
          }
        },
        {
          'description': 'not allowed email domain user who is an owner of the profile with a verified email',
          'app': await getApplicationWith(
            getDeniedEmailUser(googleSignInProviderId, true, '1')
          ),
          'can': {
            'create': false,
            'read': false,
            'readSingle': false,
            'update': false,
            'delete': false,
          }
        },
      ]
    },
    {
      'title': '',
      'description': 'Unauthenticated ',
      'users': [
        {
          'description': 'user',
          'app': await getApplicationWith(null),
          'can': {
            'create': false,
            'read': false,
            'readSingle': false,
            'update': false,
            'delete': false,
          }
        }
      ]
    }
  ];

  before(async () => {
    await setupTestDatabaseWith(Object.assign({}, profiles, allowedEmailDomains));
  });

  describe("Profile collection rules", () => {
    it("does not allow creating a profile with not allowed fields", async () => {
      let profile = getProfile();
      profile.test = "test";

      await assertFails(
        superUserApp.collection(collection).add(profile)
      );
    });

    it("does not allow creating a profile with not valid theme value", async () => {
      let profile = getProfile();
      profile.theme = "test";

      await assertFails(
        superUserApp.collection(collection).add(profile)
      );
    });

    it("allows to create a profile with null theme value", async () => {
      let profile = getProfile();
      profile.theme = null;

      await assertSucceeds(
        superUserApp.collection(collection).add(profile)
      );
    });
  });

  async.forEach(signInProviders, (provider, callback) => {

    provider.users.forEach(user => {
      let description = provider.description + user.description;

      describe(description, () => {
        let canCreateDescription = user.can.create ?
          "allows to create a profile" : "does not allow creating a profile";
        let canReadDescription = user.can.read ?
          "allows reading profiles" : "does not allow reading profiles";
        let canReadSingleDescription = user.can.readSingle ?
          "allows reading own profile" : "does not allow reading own profile";
        let canUpdateDescription = user.can.update ?
          "allows to update a profile" : "does not allow updating a profile";
        let canDeleteDescription = user.can.delete ?
          "allows to delete a profile" : "does not allow deleting a profile";

        it(canCreateDescription, async () => {
          const createPromise = user.app.collection(collection).add(getProfile());

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

        it(canReadSingleDescription, async () => {
          const readSinglePromise = user.app.collection(collection).doc("1").get();

          if (user.can.readSingle) {
            await assertSucceeds(readSinglePromise)
          } else {
            await assertFails(readSinglePromise)
          }
        });

        it(canUpdateDescription, async () => {
          const updatePromise =
            user.app.collection(collection).doc("1").update({ theme: "ThemeType.light" });

          if (user.can.update) {
            await assertSucceeds(updatePromise)
          } else {
            await assertFails(updatePromise)
          }
        });

        it(canDeleteDescription, async () => {
          const deletePromise =
            user.app.collection(collection).doc("1").delete();

          if (user.can.delete) {
            await assertSucceeds(deletePromise)
          } else {
            await assertFails(deletePromise)
          }
        });
      });
    });

    callback();
  });

  after(async () => {
    await tearDown();
  });
});
