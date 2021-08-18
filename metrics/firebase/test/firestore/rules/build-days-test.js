// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

const async = require('async');

const {
    setupTestDatabaseWith,
    getApplicationWith,
    tearDown,
} = require("./test_utils/test-app-utils");

const {assertFails, assertSucceeds} = require("@firebase/rules-unit-testing");

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

describe("", async () => {
    const collection = "build_days";
    const anonymousSignIn = await getApplicationWith(getAnonymousUser());

    const usersEnabled = [
        {
            'describe': 'Authenticated as an anonymous user, public dashboard is enabled',
            'app': anonymousSignIn,
            'can': {
                'create': false,
                'read': true,
                'update': false,
                'delete': false,
            }
        },
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
            'app': await getApplicationWith(null),
            'can': {
                'create': false,
                'read': false,
                'update': false,
                'delete': false,
            }
        },
    ];

    describe("Build days collection rules, public dashboard is enabled", () => {
        before(async () => {
            await setupTestDatabaseWith(Object.assign({}, buildDays, allowedEmailDomains, featureConfigEnabled));
        });

        async.forEach(usersEnabled, (user, callback) => {
            describe(user.describe, () => {
                let canCreateDescription = user.can.create ?
                    "allows creating a build day" : "does not allow creating a build day";
                let canReadDescription = user.can.read ?
                    "allows reading build days" : "does not allow reading build days";
                let canUpdateDescription = user.can.update ?
                    "allows updating a build day" : "does not allow updating a build day";
                let canDeleteDescription = user.can.delete ?
                    "allows deleting a build day" : "does not allow deleting a build day";

                it(canCreateDescription, async () => {
                    const createPromise = user.app.collection(collection).add(getBuildDay());

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
                        user.app.collection(collection).doc("1").update({projectId: "3"});

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

describe("", async () => {
    const collection = "build_days";
    const anonymousSignIn = await getApplicationWith(getAnonymousUser());

    const usersDisabled = [
        {
            'describe': 'Authenticated as an anonymous user, public dashboard is disabled',
            'app': anonymousSignIn,
            'can': {
                'create': false,
                'read': false,
                'update': false,
                'delete': false,
            }
        },
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
            'app': await getApplicationWith(null),
            'can': {
                'create': false,
                'read': false,
                'update': false,
                'delete': false,
            }
        },
    ];

    describe("Build days collection rules, public dashboard is disabled", () => {
        before(async () => {
            await setupTestDatabaseWith(Object.assign({}, buildDays, allowedEmailDomains, featureConfigDisabled));
        });

        async.forEach(usersDisabled, (user, callback) => {
            describe(user.describe, () => {
                let canCreateDescription = user.can.create ?
                    "allows creating a build day" : "does not allow creating a build day";
                let canReadDescription = user.can.read ?
                    "allows reading build days" : "does not allow reading build days";
                let canUpdateDescription = user.can.update ?
                    "allows updating a build day" : "does not allow updating a build day";
                let canDeleteDescription = user.can.delete ?
                    "allows deleting a build day" : "does not allow deleting a build day";

                it(canCreateDescription, async () => {
                    const createPromise = user.app.collection(collection).add(getBuildDay());

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
                        user.app.collection(collection).doc("1").update({projectId: "3"});

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
