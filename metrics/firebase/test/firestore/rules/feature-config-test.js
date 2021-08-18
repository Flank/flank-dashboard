// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

const async = require("async");

const {assertFails, assertSucceeds} = require("@firebase/rules-unit-testing");

const {
    setupTestDatabaseWith,
    getApplicationWith,
    tearDown,
} = require("./test_utils/test-app-utils");

const {
    featureConfigEnabled,
    allowedEmailDomains,
    passwordSignInProviderId,
    googleSignInProviderId,
    getAllowedEmailUser,
    getDeniedEmailUser,
} = require("./test_utils/test-data");

describe("", async () => {
    const unauthenticatedApp = await getApplicationWith(null);
    const collection = "feature_config";
    const config = {config: {}};

    const users = [
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
            Object.assign({}, featureConfigEnabled, allowedEmailDomains)
        );
    });

    describe("Feature config collection rules", () => {
        async.forEach(users, (user, callback) => {
            describe(user.describe, function () {
                let canCreateDescription = user.can.create
                    ? "allows creating a feature config"
                    : "does not allow creating a feature config";
                let canReadDescription = user.can.read
                    ? "allows reading a feature config"
                    : "does not allow reading a feature configs";
                let canUpdateDescription = user.can.update
                    ? "allows updating a feature config"
                    : "does not allow updating a feature config";
                let canDeleteDescription = user.can.delete
                    ? "allows deleting a feature config"
                    : "does not allow deleting a feature config";

                it(canCreateDescription, async () => {
                    const createPromise = user.app.collection(collection).add(config);

                    if (user.can.create) {
                        await assertSucceeds(createPromise);
                    } else {
                        await assertFails(createPromise);
                    }
                });

                it(canReadDescription, async () => {
                    const getPromise = user.app
                        .collection(collection)
                        .doc(collection)
                        .get();

                    if (user.can.read) {
                        await assertSucceeds(getPromise);
                    } else {
                        await assertFails(getPromise);
                    }
                });

                it(canUpdateDescription, async () => {
                    const updatePromise = user.app
                        .collection(collection)
                        .doc(collection)
                        .update(config);

                    if (user.can.update) {
                        await assertSucceeds(updatePromise);
                    } else {
                        await assertFails(updatePromise);
                    }
                });

                it(canDeleteDescription, async () => {
                    const deletePromise = user.app
                        .collection(collection)
                        .doc(collection)
                        .delete();

                    if (user.can.delete) {
                        await assertSucceeds(deletePromise);
                    } else {
                        await assertFails(deletePromise);
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
