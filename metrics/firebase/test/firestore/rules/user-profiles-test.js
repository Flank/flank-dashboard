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
  userProfiles,
  getUserProfile,
  allowedEmailDomains,
} = require("./test_utils/test-data");

describe("", async () => {
  const uid = "1";
  const collection = "user_profiles";
  const superUserApp = await getApplicationWith(
    getAllowedEmailUser(passwordSignInProviderId, true, uid)
  )

  const signInProviders = [
    {
      'title': 'password',
      'description': 'Authenticated with a password and ',
      'users': [
        {
          'description': 'allowed email domain user who is not an owner of the user profile with not a verified email',
          'app': await getApplicationWith(
            getAllowedEmailUser(passwordSignInProviderId, false)
          ),
          'can': {
            'create': false,
            'read': false,
            'readOwn': false,
            'update': false,
            'delete': false,
          }
        },
        {
          'description': 'allowed email domain user who is an owner of the user profile with not a verified email',
          'app': await getApplicationWith(
            getAllowedEmailUser(passwordSignInProviderId, false, uid)
          ),
          'can': {
            'create': true,
            'read': false,
            'readOwn': true,
            'update': true,
            'delete': false,
          }
        },
        {
          'description': 'allowed email domain user who is not an owner of the user profile with a verified email',
          'app': await getApplicationWith(
            getAllowedEmailUser(passwordSignInProviderId, true)
          ),
          'can': {
            'create': false,
            'read': false,
            'readOwn': false,
            'update': false,
            'delete': false,
          }
        },
        {
          'description': 'not allowed email domain user who is an owner of the user profile with not verified email',
          'app': await getApplicationWith(
            getDeniedEmailUser(passwordSignInProviderId, false, uid)
          ),
          'can': {
            'create': true,
            'read': false,
            'readOwn': true,
            'update': true,
            'delete': false,
          }
        },
        {
          'description': 'not allowed email domain user who is not an owner of the user profile with a verified email',
          'app': await getApplicationWith(
            getDeniedEmailUser(passwordSignInProviderId, true)
          ),
          'can': {
            'create': false,
            'read': false,
            'readOwn': false,
            'update': false,
            'delete': false,
          }
        },
        {
          'description': 'not allowed email domain user who is not an owner of the user profile with not a verified email',
          'app': await getApplicationWith(
            getDeniedEmailUser(passwordSignInProviderId, false)
          ),
          'can': {
            'create': false,
            'read': false,
            'readOwn': false,
            'update': false,
            'delete': false,
          }
        },
        {
          'description': 'allowed email domain user who is an owner of the user profile with a verified email',
          'app': await getApplicationWith(
            getAllowedEmailUser(passwordSignInProviderId, true, uid)
          ),
          'can': {
            'create': true,
            'read': false,
            'readOwn': true,
            'update': true,
            'delete': false,
          }
        },
        {
          'description': 'not allowed email domain user who is an owner of the user profile with a verified email',
          'app': await getApplicationWith(
            getDeniedEmailUser(passwordSignInProviderId, true, uid)
          ),
          'can': {
            'create': true,
            'read': false,
            'readOwn': true,
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
            'readOwn': false,
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
            'readOwn': false,
            'update': false,
            'delete': false,
          }
        },
        {
          'description': 'allowed email domain user who is an owner of the profile with not a verified email',
          'app': await getApplicationWith(
            getAllowedEmailUser(googleSignInProviderId, false, uid)
          ),
          'can': {
            'create': false,
            'read': false,
            'readOwn': false,
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
            'create': false,
            'read': false,
            'readOwn': false,
            'update': false,
            'delete': false,
          }
        },
        {
          'description': 'not allowed email domain user who is an owner of the profile with not verified email',
          'app': await getApplicationWith(
            getDeniedEmailUser(googleSignInProviderId, false, uid)
          ),
          'can': {
            'create': false,
            'read': false,
            'readOwn': false,
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
            'readOwn': false,
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
            'readOwn': false,
            'update': false,
            'delete': false,
          }
        },
        {
          'description': 'allowed email domain user who is an owner of the profile with a verified email',
          'app': await getApplicationWith(
            getAllowedEmailUser(googleSignInProviderId, true, uid)
          ),
          'can': {
            'create': true,
            'read': false,
            'readOwn': true,
            'update': true,
            'delete': false,
          }
        },
        {
          'description': 'not allowed email domain user who is an owner of the profile with a verified email',
          'app': await getApplicationWith(
            getDeniedEmailUser(googleSignInProviderId, true, uid)
          ),
          'can': {
            'create': false,
            'read': false,
            'readOwn': false,
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
            'readOwn': false,
            'update': false,
            'delete': false,
          }
        }
      ]
    }
  ];

  before(async () => {
    await setupTestDatabaseWith(Object.assign({}, userProfiles, allowedEmailDomains));
  });

  describe("Profile collection rules", () => {
    it("does not allow creating a user profile with not allowed fields", async () => {
      let userProfile = getUserProfile();
      userProfile.test = "test";

      await assertFails(
        superUserApp.collection(collection).add(userProfile)
      );
    });

    it("does not allow creating a user profile with not valid selected theme value", async () => {
      let userProfile = getUserProfile();
      userProfile.selectedTheme = "test";

      await assertFails(
        superUserApp.collection(collection).add(userProfile)
      );
    });

    it("does not allow to create a user profile with null selected theme value", async () => {
      let userProfile = getUserProfile();
      userProfile.selectedTheme = null;

      await assertFails(
        superUserApp.collection(collection).add(userProfile)
      );
    });
  });

  async.forEach(signInProviders, (provider, callback) => {

    provider.users.forEach(user => {
      let description = provider.description + user.description;

      describe(description, () => {
        let canCreateDescription = user.can.create ?
          "allows to create a user profile" : "does not allow creating a user profile";
        let canReadDescription = user.can.read ?
          "allows reading user profiles" : "does not allow reading user profiles";
        let canReadOwnDescription = user.can.readOwn ?
          "allows reading own user profile" : "does not allow reading own user profile";
        let canUpdateDescription = user.can.update ?
          "allows to update a user profile" : "does not allow updating a user profile";
        let canDeleteDescription = user.can.delete ?
          "allows to delete a user profile" : "does not allow deleting a user profile";

        it(canCreateDescription, async () => {
          const createPromise = user.app.collection(collection).doc(uid).set(getUserProfile());

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

        it(canReadOwnDescription, async () => {
          const readOwnPromise = user.app.collection(collection).doc(uid).get();

          if (user.can.readOwn) {
            await assertSucceeds(readOwnPromise)
          } else {
            await assertFails(readOwnPromise)
          }
        });

        it(canUpdateDescription, async () => {
          const updatePromise =
            user.app.collection(collection).doc(uid).update({ selectedTheme: "ThemeType.light" });

          if (user.can.update) {
            await assertSucceeds(updatePromise)
          } else {
            await assertFails(updatePromise)
          }
        });

        it(canDeleteDescription, async () => {
          const deletePromise =
            user.app.collection(collection).doc(uid).delete();

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
