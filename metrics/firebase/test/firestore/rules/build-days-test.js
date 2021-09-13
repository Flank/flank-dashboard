// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

const async = require('async');
const {
  setupTestDatabaseWith,
  userPermissionsTest,
  getApplicationWith,
  tearDown,
} = require("./test_utils/test-app-utils");
const {
  passwordSignInProviderId,
  googleSignInProviderId,
  getAllowedEmailUser,
  getDeniedEmailUser,
  buildDays,
  getBuildDay,
  allowedEmailDomains,
  getAnonymousUser,
  featureConfigEnabled,
  featureConfigDisabled
} = require("./test_utils/test-data");

// Tests build days security rules with public dashboard feature.
describe("", async () => {
  const collection = "build_days";

  const usersPermissions = [
    {
      'describe': 'Authenticated as an anonymous user',
      'app': await getApplicationWith(
        getAnonymousUser()
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'read': true,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'read': false,
            'update': false,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with a password and allowed email domain user with a verified email',
      'app': await getApplicationWith(
        getAllowedEmailUser(passwordSignInProviderId, true)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'read': true,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'read': true,
            'update': false,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with a password and not allowed email domain user with a verified email',
      'app': await getApplicationWith(
        getDeniedEmailUser(passwordSignInProviderId, true)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'read': true,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'read': true,
            'update': false,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with a password and allowed email domain user with not verified email',
      'app': await getApplicationWith(
        getAllowedEmailUser(passwordSignInProviderId, false)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'read': true,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'read': true,
            'update': false,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with a password and not allowed email domain user with not verified email',
      'app': await getApplicationWith(
        getDeniedEmailUser(passwordSignInProviderId, false)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'read': true,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'read': true,
            'update': false,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with google and allowed email domain user with a verified email',
      'app': await getApplicationWith(
        getAllowedEmailUser(googleSignInProviderId, true)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'read': true,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'read': true,
            'update': false,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with google and not allowed email domain user with a verified email',
      'app': await getApplicationWith(
        getDeniedEmailUser(googleSignInProviderId, true)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'read': false,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'read': false,
            'update': false,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with google and allowed email domain user with not verified email',
      'app': await getApplicationWith(
        getAllowedEmailUser(googleSignInProviderId, false)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'read': false,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'read': false,
            'update': false,
            'delete': false,
          }
        }
      }
    },
    {
      'describe': 'Authenticated with google and not allowed email domain user with not verified email',
      'app': await getApplicationWith(
        getDeniedEmailUser(googleSignInProviderId, false)
      ),
      'public_dashboard': {
        'on': {
          'can': {
            'create': false,
            'read': false,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'read': false,
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
            'read': false,
            'update': false,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': false,
            'read': false,
            'update': false,
            'delete': false,
          }
        }
      }
    },
  ];

  describe("Build days collection rules", async function () {
    async.forEach([featureConfigEnabled, featureConfigDisabled], (config, callback) => {
      const featureConfigPath = "feature_config/feature_config";
      describe(
        "Build days collection rules, isPublicDashboardEnabled = " + config[featureConfigPath].isPublicDashboardEnabled,
        async function () {
          before("", async function () {
            await setupTestDatabaseWith(Object.assign({}, buildDays, allowedEmailDomains, config));
          });

          await userPermissionsTest(usersPermissions, config, collection, getBuildDay(), { projectId: "3" })
        });
      callback();
    });
  });

  after(async () => {
    await tearDown();
  });
});
