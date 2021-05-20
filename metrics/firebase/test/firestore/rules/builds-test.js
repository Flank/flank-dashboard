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
  builds,
  getBuild,
  allowedEmailDomains,
  projects,
} = require("./test_utils/test-data");
const firestore = require("firebase").firestore;

describe("", async () => {
  const passwordProviderAllowedEmailApp = await getApplicationWith(
    getAllowedEmailUser(passwordSignInProviderId, true)
  );
  const unauthenticatedApp = await getApplicationWith(null);
  const collection = "build";

  const users = [
    {
      'describe': 'Authenticated with a password and allowed email domain user with a verified email',
      'app': await getApplicationWith(
        getAllowedEmailUser(passwordSignInProviderId, true)
      ),
      'can': {
        'create': true,
        'read': true,
        'update': true,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a password and not allowed email domain user with a verified email',
      'app': await getApplicationWith(
        getDeniedEmailUser(passwordSignInProviderId, true)
      ),
      'can': {
        'create': true,
        'read': true,
        'update': true,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a password and allowed email domain user with not verified email',
      'app': await getApplicationWith(
        getAllowedEmailUser(passwordSignInProviderId, false)
      ),
      'can': {
        'create': true,
        'read': true,
        'update': true,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a password and not allowed email domain user with not verified email',
      'app': await getApplicationWith(
        getDeniedEmailUser(passwordSignInProviderId, false)
      ),
      'can': {
        'create': true,
        'read': true,
        'update': true,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with google and allowed email domain user with a verified email',
      'app': await getApplicationWith(
        getAllowedEmailUser(googleSignInProviderId, true)
      ),
      'can': {
        'create': true,
        'read': true,
        'update': true,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with google and not allowed email domain user with a verified email',
      'app': await getApplicationWith(
        getDeniedEmailUser(googleSignInProviderId, true)
      ),
      'can': {
        'create': false,
        'read': false,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with google and allowed email domain user with not verified email',
      'app': await getApplicationWith(
        getAllowedEmailUser(googleSignInProviderId, false)
      ),
      'can': {
        'create': false,
        'read': false,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with google and not allowed email domain user with not verified email',
      'app': await getApplicationWith(
        getDeniedEmailUser(googleSignInProviderId, false)
      ),
      'can': {
        'create': false,
        'read': false,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Unauthenticated user',
      'app': unauthenticatedApp,
      'can': {
        'create': false,
        'read': false,
        'update': false,
        'delete': false,
      }
    },
  ];

  before(async () => {
    await setupTestDatabaseWith(Object.assign({}, builds, allowedEmailDomains, projects));
  });

  describe("Build collection rules", () => {
    it("does not allow creating a build with not allowed fields", async () => {
      let build = getBuild();
      build.test = "test";

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating a build with not existing project id", async () => {
      let build = getBuild();
      build.projectId = "non-existing-id";

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating a build with null projectId", async () => {
      let build = getBuild();
      build.projectId = null;

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating a build when projectId is not a string", async () => {
      let build = getBuild();
      build.projectId = 2;

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating a build if the startedAt is null", async () => {
      let build = getBuild();
      build.startedAt = null;

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating a build if the startedAt is not a timestamp", async () => {
      const build = getBuild();
      build.startedAt = Date();

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating builds if the startedAt value is after the current timestamp", async () => {
      let date = new Date();
      date.setDate(date.getDate() + 1);

      let build = getBuild();
      build.startedAt = firestore.Timestamp.fromDate(date);

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("allows creating builds with a successful build status and non-null integer duration", async () => {
      let build = getBuild();
      build.buildStatus = "BuildStatus.successful";
      build.duration = 10;

      await assertSucceeds(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("allows creating builds with a failed build status and non-null integer duration", async () => {
      let build = getBuild();
      build.buildStatus = "BuildStatus.failed";
      build.duration = 10;

      await assertSucceeds(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("allows creating builds with an unknown build status and non-null integer duration", async () => {
      let build = getBuild();
      build.buildStatus = "BuildStatus.unknown";
      build.duration = 10;

      await assertSucceeds(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("allows creating builds with a null build status and an integer duration", async () => {
      let build = getBuild();
      build.buildStatus = null;
      build.duration = 10;

      await assertSucceeds(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating builds with a successful build status and a null duration", async () => {
      let build = getBuild();
      build.buildStatus = "BuildStatus.successful";
      build.duration = null;

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating builds with a failed build status and a null duration", async () => {
      let build = getBuild();
      build.buildStatus = "BuildStatus.failed";
      build.duration = null;

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating builds with an unknown build status and a null duration", async () => {
      let build = getBuild();
      build.buildStatus = "BuildStatus.unknown";
      build.duration = null;

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating builds with a null build status and a null duration", async () => {
      let build = getBuild();
      build.buildStatus = null;
      build.duration = null;

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating builds with a successful build status and a non integer duration", async () => {
      let build = getBuild();
      build.buildStatus = "BuildStatus.successful";
      build.duration = "123";

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating builds with a failed build status and a non integer duration", async () => {
      let build = getBuild();
      build.buildStatus = "BuildStatus.failed";
      build.duration = "123";

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating builds with an unknown build status and a non integer duration", async () => {
      let build = getBuild();
      build.buildStatus = "BuildStatus.unknown";
      build.duration = "123";

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating builds with a null build status and a non-integer duration", async () => {
      let build = getBuild();
      build.buildStatus = null;
      build.duration = "123";

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("allows creating builds with an in-progress build status and a null duration", async () => {
      let build = getBuild();
      build.buildStatus = "BuildStatus.inProgress";
      build.duration = null;

      await assertSucceeds(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating builds with an in-progress build status and an integer duration", async () => {
      let build = getBuild();
      build.buildStatus = "BuildStatus.inProgress";
      build.duration = 10;

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating builds with an in-progress build status and a non-integer duration", async () => {
      let build = getBuild();
      build.buildStatus = "BuildStatus.inProgress";
      build.duration = "test";

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating a build if the url is null", async () => {
      let build = getBuild();
      build.url = null;

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating a build if the url is not a string", async () => {
      let build = getBuild();
      build.url = 2;

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("allows creating a build if the api url is null", async () => {
      let build = getBuild();
      build.apiUrl = null;

      await assertSucceeds(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating a build if the api url is not a string", async () => {
      let build = getBuild();
      build.apiUrl = 2;

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating a build if the build number is not an int", async () => {
      let build = getBuild();
      build.buildNumber = "2";

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating a build if the build number is null", async () => {
      let build = getBuild();
      build.buildNumber = null;

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating a build with not valid build status value", async () => {
      let build = getBuild();
      build.buildStatus = "test";

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("allows creating a build with null build status", async () => {
      let build = getBuild();
      build.buildStatus = null;

      await assertSucceeds(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating a build when workflow name is not a string", async () => {
      let build = getBuild();
      build.workflowName = 2;

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("allows creating a build when workflow name is null", async () => {
      let build = getBuild();
      build.workflowName = null;

      await assertSucceeds(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating a build when the coverage is grater then 1.0", async () => {
      let build = getBuild();
      build.coverage = 1.1;

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("does not allow creating a build when the coverage is less then 0.0", async () => {
      let build = getBuild();
      build.coverage = -1.0;

      await assertFails(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    it("allows creating a build when the coverage is null", async () => {
      let build = getBuild();
      build.coverage = null;

      await assertSucceeds(
        passwordProviderAllowedEmailApp.collection(collection).add(build)
      );
    });

    async.forEach(users, (user, callback) => {
      describe(user.describe, () => {
        let canCreateDescription = user.can.create ?
          "allows creating a build" : "does not allow creating a build";
        let canReadDescription = user.can.read ?
          "allows reading builds" : "does not allow reading builds";
        let canUpdateDescription = user.can.update ?
          "allows updating a build" : "does not allow updating a build";
        let canDeleteDescription = user.can.delete ?
          "allows deleting a build" : "does not allow deleting a build";

        it(canCreateDescription, async () => {
          const createPromise = user.app.collection(collection).add(getBuild());

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

        it(canUpdateDescription, async () => {
          const updatePromise =
            user.app.collection(collection).doc("1").update({ url: "updated" });

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
      callback();
    });
  });

  after(async () => {
    await tearDown();
  });
});
