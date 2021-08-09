// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

const async = require('async');
const {
  setupTestDatabaseWith,
  getApplicationWith,
  tearDown,
} = require("./test_utils/test-app-utils");
const { assertFails, assertSucceeds } = require("@firebase/rules-unit-testing");
const {
  passwordSignInProviderId,
  googleSignInProviderId,
  getAllowedEmailUser,
  getDeniedEmailUser,
  userProfiles,
  getUserProfile,
  allowedEmailDomains,
  getAnonymousUser,
} = require("./test_utils/test-data");

describe("", async () => {
  const uid = "1";
  const collection = "user_profiles";
  const passwordProviderAllowedEmailApp = await getApplicationWith(
    getAllowedEmailUser(passwordSignInProviderId, true, uid)
  );

  const users = [
    {
      'describe': 'Authenticated as an anonymous user who is not an owner of the user profile',
      'app':  await getApplicationWith(getAnonymousUser()),
      'can': {
        'create': false,
        'list': false,
        'read': false,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated as an anonymous user who is an owner of the user profile',
      'app':  await getApplicationWith(getAnonymousUser(uid)),
      'can': {
        'create': true,
        'list': false,
        'get': true,
        'update': true,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a password, allowed email domain, and not a verified email user who is not an owner of the user profile',
      'app': await getApplicationWith(
        getAllowedEmailUser(passwordSignInProviderId, false)
      ),
      'can': {
        'create': false,
        'list': false,
        'get': false,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a password, allowed email domain, and not a verified email user who is an owner of the user profile',
      'app': await getApplicationWith(
        getAllowedEmailUser(passwordSignInProviderId, false, uid)
      ),
      'can': {
        'create': true,
        'list': false,
        'get': true,
        'update': true,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a password, allowed email domain, and a verified email user who is not an owner of the user profile',
      'app': await getApplicationWith(
        getAllowedEmailUser(passwordSignInProviderId, true)
      ),
      'can': {
        'create': false,
        'list': false,
        'get': false,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a password, not allowed email domain, and not verified email user who is an owner of the user profile',
      'app': await getApplicationWith(
        getDeniedEmailUser(passwordSignInProviderId, false, uid)
      ),
      'can': {
        'create': true,
        'list': false,
        'get': true,
        'update': true,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a password, not allowed email domain, and a verified email user who is not an owner of the user profile',
      'app': await getApplicationWith(
        getDeniedEmailUser(passwordSignInProviderId, true)
      ),
      'can': {
        'create': false,
        'list': false,
        'get': false,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a password, not allowed email domain, and not a verified email user who is not an owner of the user profile',
      'app': await getApplicationWith(
        getDeniedEmailUser(passwordSignInProviderId, false)
      ),
      'can': {
        'create': false,
        'list': false,
        'get': false,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a password, allowed email domain, and a verified email user who is an owner of the user profile',
      'app': await getApplicationWith(
        getAllowedEmailUser(passwordSignInProviderId, true, uid)
      ),
      'can': {
        'create': true,
        'list': false,
        'get': true,
        'update': true,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a password, not allowed email domain, and a verified email user who is an owner of the user profile',
      'app': await getApplicationWith(
        getDeniedEmailUser(passwordSignInProviderId, true, uid)
      ),
      'can': {
        'create': true,
        'list': false,
        'get': true,
        'update': true,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a google, allowed email domain, and not a verified email user who is not an owner of the profile',
      'app': await getApplicationWith(
        getAllowedEmailUser(googleSignInProviderId, false)
      ),
      'can': {
        'create': false,
        'list': false,
        'get': false,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a google, allowed email domain, and not a verified email user who is an owner of the profile',
      'app': await getApplicationWith(
        getAllowedEmailUser(googleSignInProviderId, false, uid)
      ),
      'can': {
        'create': false,
        'list': false,
        'get': false,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a google, allowed email domain, and a verified email user who is not an owner of the profile',
      'app': await getApplicationWith(
        getAllowedEmailUser(googleSignInProviderId, true)
      ),
      'can': {
        'create': false,
        'list': false,
        'get': false,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a google, not allowed email domain, and not verified email user who is an owner of the profile',
      'app': await getApplicationWith(
        getDeniedEmailUser(googleSignInProviderId, false, uid)
      ),
      'can': {
        'create': false,
        'list': false,
        'get': false,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a google, not allowed email domain, and a verified email user who is not an owner of the profile',
      'app': await getApplicationWith(
        getDeniedEmailUser(googleSignInProviderId, true)
      ),
      'can': {
        'create': false,
        'list': false,
        'get': false,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a google, not allowed email domain, and not a verified email user who is not an owner of the profile',
      'app': await getApplicationWith(
        getDeniedEmailUser(googleSignInProviderId, false)
      ),
      'can': {
        'create': false,
        'list': false,
        'get': false,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a google, allowed email domain, and a verified email user who is an owner of the profile',
      'app': await getApplicationWith(
        getAllowedEmailUser(googleSignInProviderId, true, uid)
      ),
      'can': {
        'create': true,
        'list': false,
        'get': true,
        'update': true,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a google, not allowed email domain, and a verified email user who is an owner of the profile',
      'app': await getApplicationWith(
        getDeniedEmailUser(googleSignInProviderId, true, uid)
      ),
      'can': {
        'create': false,
        'list': false,
        'get': false,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Unauthenticated user',
      'app': await getApplicationWith(null),
      'can': {
        'create': false,
        'list': false,
        'get': false,
        'update': false,
        'delete': false,
      }
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
        passwordProviderAllowedEmailApp.collection(collection).add(userProfile)
      );
    });

    it("does not allow creating a user profile with not valid selected theme value", async () => {
      let userProfile = getUserProfile();
      userProfile.selectedTheme = "test";

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(userProfile)
      );
    });

    it("does not allow to create a user profile with null selected theme value", async () => {
      let userProfile = getUserProfile();
      userProfile.selectedTheme = null;

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(userProfile)
      );
    });
  });

  async.forEach(users, (user, callback) => {
    describe(user.describe, () => {
      let canCreateDescription = user.can.create ?
        "allows to create a user profile" : "does not allow creating a user profile";
      let canListDescription = user.can.list ?
        "allows reading user profiles" : "does not allow reading user profiles";
      let canGetDescription = user.can.get ?
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

      it(canListDescription, async () => {
        const readPromise = user.app.collection(collection).get();

        if (user.can.list) {
          await assertSucceeds(readPromise)
        } else {
          await assertFails(readPromise)
        }
      });

      it(canGetDescription, async () => {
        const readOwnPromise = user.app.collection(collection).doc(uid).get();

        if (user.can.get) {
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
    callback();
  });

  after(async () => {
    await tearDown();
  });
});
