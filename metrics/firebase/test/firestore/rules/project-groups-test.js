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
  projectGroups,
  getAllowedEmailUser,
  getDeniedEmailUser,
  googleSignInProviderId,
  passwordSignInProviderId,
  allowedEmailDomains,
  getProjectGroup,
  getAnonymousUser,
  featureConfigEnabled,
  featureConfigDisabled
} = require("./test_utils/test-data");
const collection = "project_groups";

// Tests project groups security rules with public dashboard feature.
describe("", async function () {

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
            'delete': true,
          }
        },
        'off': {
          'can': {
            'create': true,
            'read': true,
            'update': true,
            'delete': true,
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
            'delete': true,
          }
        },
        'off': {
          'can': {
            'create': true,
            'read': true,
            'update': true,
            'delete': true,
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
            'delete': true,
          }
        },
        'off': {
          'can': {
            'create': true,
            'read': true,
            'update': true,
            'delete': true,
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
            'delete': true,
          }
        },
        'off': {
          'can': {
            'create': true,
            'read': true,
            'update': true,
            'delete': true,
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
            'delete': true,
          }
        },
        'off': {
          'can': {
            'create': true,
            'read': true,
            'update': true,
            'delete': true,
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
      Object.assign({}, projectGroups, allowedEmailDomains)
    );
  });

  describe("Project groups collection rules", () => {
    async.forEach([featureConfigEnabled, featureConfigDisabled], function (config, callback) {
      const featureConfigPath = "feature_config/feature_config";

      describe(
        "Project groups collection rules, isPublicDashboardEnabled = " + config[featureConfigPath].isPublicDashboardEnabled,
        function () {
          async.forEach(usersPermissions, (user, callback) => {
            describe(user.describe, () => {
              before(
                "",
                async function () {
                  await setupTestDatabaseWith(
                    Object.assign({}, projectGroups, allowedEmailDomains, config)
                  );
                });

              let publicDashboardState = config[featureConfigPath].isPublicDashboardEnabled
                ? 'on'
                : 'off';
              let canCreateDescription = user.public_dashboard[publicDashboardState].can.create ?
                "allows to create a project group" : "does not allow creating a project group";
              let canReadDescription = user.public_dashboard[publicDashboardState].can.read ?
                "allows reading project groups" : "does not allow reading project groups";
              let canUpdateDescription = user.public_dashboard[publicDashboardState].can.update ?
                "allows to update a project group" : "does not allow updating a project group";
              let canDeleteDescription = user.public_dashboard[publicDashboardState].can.delete ?
                "allows to delete a project group" : "does not allow deleting a project group";

              it(canCreateDescription, async () => {
                const createPromise = user.app.collection(collection).add(getProjectGroup());

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
                const updatePromise = user.app.collection(collection)
                  .doc("2")
                  .update(getProjectGroup());

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

// Runs general security rules tests.
describe("", async function () {
  const passwordProviderAllowedEmailApp = await getApplicationWith(
    getAllowedEmailUser(passwordSignInProviderId, true)
  );

  before("", async function () {
    await setupTestDatabaseWith(
      Object.assign({}, projectGroups, allowedEmailDomains, featureConfigDisabled))
  });

  describe("General project groups collection rules", async function () {
    it("does not allow creating a project group with not allowed fields", async () => {
      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add({
          name: "name",
          projectIds: [],
          notAllowedField: "test",
        })
      );
    });

    it("does not allow creating a project group without a name", async () => {
      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add({
          projectIds: [],
        })
      );
    });

    it("does not allow creating a project group with a name having other than a string value", async () => {
      let names = [false, 123, []];

      names.forEach(async (name) => {
        await assertFails(
          passwordProviderAllowedEmailApp
            .collection(collection)
            .add({ name, projectIds: [] })
        );
      });
    });

    it("does not allow creating a project group with a projectIds having other than a list value", () => {
      let projectIdsValues = [123, false, "test"];

      projectIdsValues.forEach(async (projectIds) => {
        await assertFails(
          passwordProviderAllowedEmailApp
            .collection(collection)
            .add({ name: "test", projectIds })
        );
      });
    });

    it("allows to update a project group with name size less or equal than 255", async () => {
      const testName = "testName";

      await assertSucceeds(
        passwordProviderAllowedEmailApp.collection(collection).doc("2").update({
          name: testName,
          projectIds: [],
        })
      );
    });

    it("allows to update a project group with project ids length less or equal than 20", async () => {
      const testProjectIds = ["1", "2"];

      await assertSucceeds(
        passwordProviderAllowedEmailApp.collection(collection).doc("2").update({
          name: "name",
          projectIds: testProjectIds,
        })
      );
    });

    it("allows to create a project group with name size less or equal than 255", async () => {
      const testName = "testName";

      await assertSucceeds(
        passwordProviderAllowedEmailApp.collection(collection).add({
          name: testName,
          projectIds: [],
        })
      );
    });

    it("allows to create a project group with project ids length less or equal than 20", async () => {
      const testProjectIds = ["1", "2"];

      await assertSucceeds(
        passwordProviderAllowedEmailApp.collection(collection).add({
          name: "name",
          projectIds: testProjectIds,
        })
      );
    });

    it("does not allow updating a project group with name size greater than 255", async () => {
      const testName = "a".repeat(256);

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).doc("2").update({
          name: testName,
          projectIds: [],
        })
      );
    });

    it("does not allow updating a project group with project ids length greater than 20", async () => {
      const testProjectIds = [...Array(21)].map((_, i) => `${i}`);

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).doc("2").update({
          name: "name",
          projectIds: testProjectIds,
        })
      );
    });

    it("does not allow creating a project group with name size greater than 255", async () => {
      const testName = "a".repeat(256);

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add({
          name: testName,
          projectIds: [],
        })
      );
    });

    it("does not allow creating a project group with project ids length greater than 20", async () => {
      const testProjectIds = [...Array(21)].map((_, i) => `${i}`);

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add({
          name: "name",
          projectIds: testProjectIds,
        })
      );
    });
  });

  after(async () => {
    await tearDown();
  });
});
