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
  getAnonymousUser,
  userProfiles,
  getUserProfile,
  allowedEmailDomains,
  featureConfigEnabled,
  featureConfigDisabled
} = require("./test_utils/test-data");
const collection = "user_profiles";
const uid = "1";

// Tests user profiles security rules with public dashboard feature.
describe("", async () => {
  const usersPermissions = [
    {
      'describe': 'Authenticated as an anonymous user who is an owner of the user profile',
      'app': await getApplicationWith(getAnonymousUser(uid)),
      'public_dashboard': {
        'on': {
          'can': {
            'create': true,
            'list': false,
            'get': true,
            'update': true,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated as an anonymous user who is not an owner of the user profile',
      'app': await getApplicationWith(getAnonymousUser()),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with a password, allowed email domain, and not a verified email user who is not an owner of the user profile',
      'app': await getApplicationWith(
        getAllowedEmailUser(passwordSignInProviderId, false)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with a password, allowed email domain, and not a verified email user who is an owner of the user profile',
      'app': await getApplicationWith(
        getAllowedEmailUser(passwordSignInProviderId, false, uid)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': true,
            'list': false,
            'get': true,
            'update': true,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': true,
            'list': false,
            'get': true,
            'update': true,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with a password, allowed email domain, and a verified email user who is not an owner of the user profile',
      'app': await getApplicationWith(
        getAllowedEmailUser(passwordSignInProviderId, true)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with a password, not allowed email domain, and not verified email user who is an owner of the user profile',
      'app': await getApplicationWith(
        getDeniedEmailUser(passwordSignInProviderId, false, uid)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': true,
            'list': false,
            'get': true,
            'update': true,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': true,
            'list': false,
            'get': true,
            'update': true,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with a password, not allowed email domain, and a verified email user who is not an owner of the user profile',
      'app': await getApplicationWith(
        getDeniedEmailUser(passwordSignInProviderId, true)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with a password, not allowed email domain, and not a verified email user who is not an owner of the user profile',
      'app': await getApplicationWith(
        getDeniedEmailUser(passwordSignInProviderId, false)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with a password, allowed email domain, and a verified email user who is an owner of the user profile',
      'app': await getApplicationWith(
        getAllowedEmailUser(passwordSignInProviderId, true, uid)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': true,
            'list': false,
            'get': true,
            'update': true,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': true,
            'list': false,
            'get': true,
            'update': true,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with a password, not allowed email domain, and a verified email user who is an owner of the user profile',
      'app': await getApplicationWith(
        getDeniedEmailUser(passwordSignInProviderId, true, uid)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': true,
            'list': false,
            'get': true,
            'update': true,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': true,
            'list': false,
            'get': true,
            'update': true,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with a google, allowed email domain, and not a verified email user who is not an owner of the profile',
      'app': await getApplicationWith(
        getAllowedEmailUser(googleSignInProviderId, false)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with a google, allowed email domain, and not a verified email user who is an owner of the profile',
      'app': await getApplicationWith(
        getAllowedEmailUser(googleSignInProviderId, false, uid)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with a google, allowed email domain, and a verified email user who is not an owner of the profile',
      'app': await getApplicationWith(
        getAllowedEmailUser(googleSignInProviderId, true)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with a google, not allowed email domain, and not verified email user who is an owner of the profile',
      'app': await getApplicationWith(
        getDeniedEmailUser(googleSignInProviderId, false, uid)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with a google, not allowed email domain, and a verified email user who is not an owner of the profile',
      'app': await getApplicationWith(
        getDeniedEmailUser(googleSignInProviderId, true)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with a google, not allowed email domain, and not a verified email user who is not an owner of the profile',
      'app': await getApplicationWith(
        getDeniedEmailUser(googleSignInProviderId, false)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with a google, allowed email domain, and a verified email user who is an owner of the profile',
      'app': await getApplicationWith(
        getAllowedEmailUser(googleSignInProviderId, true, uid)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': true,
            'list': false,
            'get': true,
            'update': true,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': true,
            'list': false,
            'get': true,
            'update': true,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with a google, not allowed email domain, and a verified email user who is an owner of the profile',
      'app': await getApplicationWith(
        getDeniedEmailUser(googleSignInProviderId, true, uid)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Unauthenticated user',
      'app': await getApplicationWith(null),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'list': false,
            'get': false,
            'update': false,
            'delete': false,
          }
        }
      }
    }
  ];

  before(async () => {
    await setupTestDatabaseWith(Object.assign({}, userProfiles, allowedEmailDomains));
  });

  describe("Profile collection rules", () => {
    async.forEach([featureConfigEnabled, featureConfigDisabled], function (config, callback) {
      const featureConfigPath = "feature_config/feature_config";
      describe(
        "User profiles collection rules, isPublicDashboardEnabled = " + config[featureConfigPath].isPublicDashboardEnabled,
        function () {
          async.forEach(usersPermissions, (user, callback) => {
            before(async () => {
              await setupTestDatabaseWith(Object.assign({}, userProfiles, allowedEmailDomains, config));
            });

            describe(user.describe, () => {
              let publicDashboardState = config[featureConfigPath].isPublicDashboardEnabled
                ? 'on'
                : 'off';
              let canCreateDescription = user.public_dashboard[publicDashboardState].can.create ?
                "allows to create a user profile" : "does not allow creating a user profile";
              let canListDescription = user.public_dashboard[publicDashboardState].can.list ?
                "allows reading user profiles" : "does not allow reading user profiles";
              let canGetDescription = user.public_dashboard[publicDashboardState].can.get ?
                "allows reading own user profile" : "does not allow reading own user profile";
              let canUpdateDescription = user.public_dashboard[publicDashboardState].can.update ?
                "allows to update a user profile" : "does not allow updating a user profile";
              let canDeleteDescription = user.public_dashboard[publicDashboardState].can.delete ?
                "allows to delete a user profile" : "does not allow deleting a user profile";

              it(canCreateDescription, async () => {
                const createPromise = user.app.collection(collection).doc(uid).set(getUserProfile());

                if (user.public_dashboard[publicDashboardState].can.create) {
                  await assertSucceeds(createPromise)
                } else {
                  await assertFails(createPromise)
                }
              });

              it(canListDescription, async () => {
                const readPromise = user.app.collection(collection).get();

                if (user.public_dashboard[publicDashboardState].can.list) {
                  await assertSucceeds(readPromise)
                } else {
                  await assertFails(readPromise)
                }
              });

              it(canGetDescription, async () => {
                const readOwnPromise = user.app.collection(collection).doc(uid).get();

                if (user.public_dashboard[publicDashboardState].can.get) {
                  await assertSucceeds(readOwnPromise)
                } else {
                  await assertFails(readOwnPromise)
                }
              });

              it(canUpdateDescription, async () => {
                const updatePromise =
                  user.app.collection(collection).doc(uid).update({selectedTheme: "ThemeType.light"});

                if (user.public_dashboard[publicDashboardState].can.update) {
                  await assertSucceeds(updatePromise)
                } else {
                  await assertFails(updatePromise)
                }
              });

              it(canDeleteDescription, async () => {
                const deletePromise =
                  user.app.collection(collection).doc(uid).delete();

                if (user.public_dashboard[publicDashboardState].can.delete) {
                  await assertSucceeds(deletePromise)
                } else {
                  await assertFails(deletePromise)
                }
              });
            });
            callback();
          });
        });
      callback();
    });
  });

  after(async () => {
    await tearDown();
  });
});

// Runs general security rules tests.
describe("", async function () {
  const passwordProviderAllowedEmailApp = await getApplicationWith(
    getAllowedEmailUser(passwordSignInProviderId, true, uid)
  )

  before(async () => {
    await setupTestDatabaseWith(Object.assign({}, userProfiles, allowedEmailDomains, featureConfigDisabled));
  });

  describe("General project groups collection rules", async function () {
    let userProfile = getUserProfile();

    it("does not allow creating a user profile with not allowed fields", async () => {
      userProfile.test = "test";

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(userProfile)
      );
    });

    it("does not allow creating a user profile with not valid selected theme value", async () => {
      userProfile.selectedTheme = "test";

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(userProfile)
      );
    });

    it("does not allow to create a user profile with null selected theme value", async () => {
      userProfile.selectedTheme = null;

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(userProfile)
      );
    });
  });

  after(async () => {
    await tearDown();
  });
});
