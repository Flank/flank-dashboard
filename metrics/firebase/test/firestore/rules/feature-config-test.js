// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

const {
  setupTestDatabaseWith,
  getApplicationWith,
  tearDown, userPermissionsTest,
} = require("./test_utils/test-app-utils");

const {
  featureConfig,
  allowedEmailDomains,
  passwordSignInProviderId,
  googleSignInProviderId,
  getAllowedEmailUser,
  getDeniedEmailUser,
} = require("./test_utils/test-data");

describe("", async () => {
  const unauthenticatedApp = await getApplicationWith(null);
  const collection = "feature_config";
  const config = { config: {} };

  const usersPermissions = [
    {
      'describe': 'Authenticated with a password and allowed email domain user with a verified email',
      'app': await getApplicationWith(
          getAllowedEmailUser(passwordSignInProviderId, true)
      ),
      'can': {
        'create': false,
        'read': true,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a password and not allowed email domain user with a verified email',
      'app': await getApplicationWith(
        getDeniedEmailUser(passwordSignInProviderId, true)
      ),
      'can': {
        'create': false,
        'read': true,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a password and allowed email domain user with not verified email',
      'app': await getApplicationWith(
        getAllowedEmailUser(passwordSignInProviderId, false)
      ),
      'can': {
        'create': false,
        'read': true,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with a password and not allowed email domain user with not verified email',
      'app': await getApplicationWith(
        getDeniedEmailUser(passwordSignInProviderId, false)
      ),
      'can': {
        'create': false,
        'read': true,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Authenticated with google and allowed email domain user with a verified email',
      'app': await getApplicationWith(
        getAllowedEmailUser(googleSignInProviderId, true)
      ),
      'can': {
        'create': false,
        'read': true,
        'update': false,
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
        'read': true,
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
        'read': true,
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
        'read': true,
        'update': false,
        'delete': false,
      }
    },
    {
      'describe': 'Unauthenticated user',
      'app': unauthenticatedApp,
      'can': {
        'create': false,
        'read': true,
        'update': false,
        'delete': false,
      }
    },
  ];

  before(async () => {
    await setupTestDatabaseWith(
      Object.assign({}, featureConfig, allowedEmailDomains)
    );
  });

  await userPermissionsTest(usersPermissions, featureConfig, collection, config, config);

  after(async () => {
    await tearDown();
  });
});
