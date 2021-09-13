// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

const async = require('async');
const {
  setupTestDatabaseWith,
  getApplicationWith,
  tearDown,
  userPermissionsTest,
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
const uid = "2";

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

  describe("Profile collection rules", () => {
    async.forEach([featureConfigEnabled, featureConfigDisabled], function (config, callback) {
      const featureConfigPath = "feature_config/feature_config";
      describe(
        "User profiles collection rules, isPublicDashboardEnabled = " + config[featureConfigPath].isPublicDashboardEnabled,
        async function () {
          before(async () => {
            await setupTestDatabaseWith(Object.assign({}, userProfiles, allowedEmailDomains, config));
          });

          await userPermissionsTest(usersPermissions, config, collection, undefined, { selectedTheme: "ThemeType.light" }, getUserProfile(), uid)
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

  after(async () => {
    await tearDown();
  });
});
