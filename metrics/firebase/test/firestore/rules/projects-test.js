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
  project,
  projects,
  getAllowedEmailUser,
  getDeniedEmailUser,
  passwordSignInProviderId,
  googleSignInProviderId,
  allowedEmailDomains,
  getAnonymousUser,
  featureConfigEnabled,
  featureConfigDisabled
} = require("./test_utils/test-data");

// Tests projects security rules with public dashboard feature.
describe("", async function () {
  const collection = "projects";

  const usersPermissions = [
    {
      'describe': 'Authenticated as an anonymous user',
      'app': await getApplicationWith(getAnonymousUser()),
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
            'create': true,
            'read': true,
            'update': true,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': true,
            'read': true,
            'update': true,
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
            'create': true,
            'read': true,
            'update': true,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': true,
            'read': true,
            'update': true,
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
            'create': true,
            'read': true,
            'update': true,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': true,
            'read': true,
            'update': true,
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
            'create': true,
            'read': true,
            'update': true,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': true,
            'read': true,
            'update': true,
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
            'create': true,
            'read': true,
            'update': true,
            'delete': false,
          }
        },
        'off': {
          'can': {
            'create': true,
            'read': true,
            'update': true,
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

  before(async () => {
    await setupTestDatabaseWith(
      Object.assign({}, projects, allowedEmailDomains)
    );
  });

  describe("Projects collection rules", () => {
    async.forEach([featureConfigEnabled, featureConfigDisabled], function (config, callback) {
      const featureConfigPath = "feature_config/feature_config";

      describe(
        "Projects collection rules, isPublicDashboardEnabled = " + config[featureConfigPath].isPublicDashboardEnabled,
        function () {
          async.forEach(usersPermissions, (user, callback) => {
            before(
              "",
              async function () {
                await setupTestDatabaseWith(
                  Object.assign({}, projects, allowedEmailDomains, config)
                );
              });

            let publicDashboardState = config[featureConfigPath].isPublicDashboardEnabled
              ? 'on'
              : 'off';
            describe(user.describe, () => {
              let canCreateDescription = user.public_dashboard[publicDashboardState].can.create ?
                "allows to create a project" : "does not allow creating a project";
              let canReadDescription = user.public_dashboard[publicDashboardState].can.read ?
                "allows reading projects" : "does not allow reading projects";
              let canUpdateDescription = user.public_dashboard[publicDashboardState].can.update ?
                "allows to update a project" : "does not allow updating a project";
              let canDeleteDescription = user.public_dashboard[publicDashboardState].can.delete ?
                "allows to delete a project" : "does not allow deleting a project";

              it(canCreateDescription, async () => {
                const createPromise = user.app.collection(collection).add(project);

                if (user.public_dashboard[publicDashboardState].can.create) {
                  await assertSucceeds(createPromise)
                } else {
                  await assertFails(createPromise)
                }
              });

              it(canReadDescription, async () => {
                const readPromise = user.app.collection(collection).get();

                if (user.public_dashboard[publicDashboardState].can.read) {
                  await assertSucceeds(readPromise)
                } else {
                  await assertFails(readPromise)
                }
              });

              it(canUpdateDescription, async () => {
                const updatePromise = user.app.collection(collection).doc("1").update(project);

                if (user.public_dashboard[publicDashboardState].can.update) {
                  await assertSucceeds(updatePromise)
                } else {
                  await assertFails(updatePromise)
                }
              });

              it(canDeleteDescription, async () => {
                const deletePromise = user.app.collection(collection).doc("1").delete();

                if (user.public_dashboard[publicDashboardState].can.delete) {
                  await assertSucceeds(deletePromise)
                } else {
                  await assertFails(deletePromise)
                }
              });
            });
            callback();
          });
        }
      );
      callback();
    });
  });

  after(async () => {
    await tearDown();
  });
});

describe("", async function () {
  const unauthenticatedApp = await getApplicationWith(null);
  const passwordProviderAllowedEmailApp = await getApplicationWith(
    getAllowedEmailUser(passwordSignInProviderId, true)
  );
  const collection = "projects";

  before(async () => {
    await setupTestDatabaseWith(
      Object.assign({}, projects, allowedEmailDomains)
    );
  });

  describe("General projects collection rules", () => {
    it("does not allow creating a project with not allowed fields", async () => {
      await assertFails(
        unauthenticatedApp.collection(collection).add({
          name: "name",
          test: "test",
        })
      );
    });

    it("does not allow creating a project without a name", async () => {
      await assertFails(passwordProviderAllowedEmailApp.collection(collection).add({}));
    });
  });

  after(async () => {
    await tearDown();
  });
});
