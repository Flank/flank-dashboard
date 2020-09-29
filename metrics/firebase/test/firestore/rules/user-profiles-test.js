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
  const collection = "user_profiles";
  const superUserApp = await getApplicationWith(
    getAllowedEmailUser(passwordSignInProviderId, true, '1')
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
            'create': true,
            'read': false,
            'readSelf': false,
            'update': false,
            'delete': false,
          }
        },
        {
          'description': 'allowed email domain user who is an owner of the user profile with not a verified email',
          'app': await getApplicationWith(
            getAllowedEmailUser(passwordSignInProviderId, false, '1')
          ),
          'can': {
            'create': true,
            'read': false,
            'readSelf': true,
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
            'create': true,
            'read': false,
            'readSelf': false,
            'update': false,
            'delete': false,
          }
        },
        {
          'description': 'not allowed email domain user who is an owner of the user profile with not verified email',
          'app': await getApplicationWith(
            getDeniedEmailUser(passwordSignInProviderId, false, '1')
          ),
          'can': {
            'create': true,
            'read': false,
            'readSelf': true,
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
            'create': true,
            'read': false,
            'readSelf': false,
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
            'create': true,
            'read': false,
            'readSelf': false,
            'update': false,
            'delete': false,
          }
        },
        {
          'description': 'allowed email domain user who is an owner of the user profile with a verified email',
          'app': await getApplicationWith(
            getAllowedEmailUser(passwordSignInProviderId, true, '1')
          ),
          'can': {
            'create': true,
            'read': false,
            'readSelf': true,
            'update': true,
            'delete': false,
          }
        },
        {
          'description': 'not allowed email domain user who is an owner of the user profile with a verified email',
          'app': await getApplicationWith(
            getDeniedEmailUser(passwordSignInProviderId, true, '1')
          ),
          'can': {
            'create': true,
            'read': false,
            'readSelf': true,
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
            'readSelf': false,
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
            'readSelf': false,
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
            'readSelf': false,
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
            'readSelf': false,
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
            'readSelf': false,
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
            'readSelf': false,
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
            'readSelf': false,
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
            'readSelf': true,
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
            'readSelf': false,
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
            'readSelf': false,
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
        let canReadSelfDescription = user.can.readSelf ?
          "allows reading own user profile" : "does not allow reading own user profile";
        let canUpdateDescription = user.can.update ?
          "allows to update a user profile" : "does not allow updating a user profile";
        let canDeleteDescription = user.can.delete ?
          "allows to delete a user profile" : "does not allow deleting a user profile";

        it(canCreateDescription, async () => {
          const createPromise = user.app.collection(collection).add(getUserProfile());

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

        it(canReadSelfDescription, async () => {
          const readSelfPromise = user.app.collection(collection).doc("1").get();

          if (user.can.readSelf) {
            await assertSucceeds(readSelfPromise)
          } else {
            await assertFails(readSelfPromise)
          }
        });

        it(canUpdateDescription, async () => {
          const updatePromise =
            user.app.collection(collection).doc("1").update({ selectedTheme: "ThemeType.light" });

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
