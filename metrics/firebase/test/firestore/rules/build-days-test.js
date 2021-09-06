// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

const async = require('async');
const {
  setupTestDatabaseWith,
  userPermissionsTest,
  getApplicationWith,
  tearDown,
} = require("./test_utils/test-app-utils");
const { assertFails, assertSucceeds } = require("@firebase/rules-unit-testing");
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
          before("", async function (){
            await setupTestDatabaseWith(Object.assign({}, buildDays, allowedEmailDomains, config));
          });
          await userPermissionsTest(usersPermissions, config, collection, getBuildDay(), {projectId: "3"})
          // async.forEach(usersPermissions, (user, callback) => {
          //   describe(user.describe, () => {
          //     console.log('FEATURE CONFIG STATUS:' + config[featureConfigPath].isPublicDashboardEnabled);
          //     let publicDashboardState = config[featureConfigPath].isPublicDashboardEnabled
          //       ? 'on'
          //       : 'off';
          //     let canCreateDescription = user.public_dashboard[publicDashboardState].can.create ?
          //       "allows creating a build day" : "does not allow creating a build day";
          //     let canReadDescription = user.public_dashboard[publicDashboardState].can.read ?
          //       "allows reading build days" : "does not allow reading build days";
          //     let canUpdateDescription = user.public_dashboard[publicDashboardState].can.update ?
          //       "allows updating a build day" : "does not allow updating a build day";
          //     let canDeleteDescription = user.public_dashboard[publicDashboardState].can.delete ?
          //       "allows deleting a build day" : "does not allow deleting a build day";
          //
          //     it(canCreateDescription, async () => {
          //       const createPromise = user.app.collection(collection).add(getBuildDay());
          //
          //       if (user.public_dashboard[publicDashboardState].can.create) {
          //         await assertSucceeds(createPromise)
          //       } else {
          //         await assertFails(createPromise)
          //       }
          //     });
          //
          //     it(canReadDescription, async () => {
          //       const readPromise = user.app.collection(collection).get();
          //       console.log('FEATURE CONFIG STATUS:' + config[featureConfigPath].isPublicDashboardEnabled);
          //       console.log('CAN READ?' + user.public_dashboard[publicDashboardState].can.read);
          //
          //       if (user.public_dashboard[publicDashboardState].can.read) {
          //         await assertSucceeds(readPromise)
          //       } else {
          //         await assertFails(readPromise)
          //       }
          //     });
          //
          //     it(canUpdateDescription, async () => {
          //       const updatePromise =
          //         user.app.collection(collection).doc("1").update({projectId: "3"});
          //
          //       if (user.public_dashboard[publicDashboardState].can.update) {
          //         await assertSucceeds(updatePromise)
          //       } else {
          //         await assertFails(updatePromise)
          //       }
          //     });
          //
          //     it(canDeleteDescription, async () => {
          //       const deletePromise =
          //         user.app.collection(collection).doc("1").delete();
          //
          //       if (user.public_dashboard[publicDashboardState].can.delete) {
          //         await assertSucceeds(deletePromise)
          //       } else {
          //         await assertFails(deletePromise)
          //       }
          //     });
          //   });
          //   callback();
          // });
        });
      callback();
    });
  });

  after(async () => {
    await tearDown();
  });
});
