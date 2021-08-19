// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

const async = require('async');

const {assertFails, assertSucceeds} = require("@firebase/rules-unit-testing");

const {
    setupTestDatabaseWith,
    getApplicationWith,
    tearDown,
} = require("./test_utils/test-app-utils");

const {
    allowedEmailDomains, getAllowedEmailUser, passwordSignInProviderId,
    getDeniedEmailUser, googleSignInProviderId, featureConfigEnabled,
    featureConfigDisabled, getAnonymousUser
} = require("./test_utils/test-data");

const collection = "allowed_email_domains";
const domain = {"test.com": {}};

function test(users) {
    async.forEach(users, (user, callback) => {
        describe(user.describe, function () {
            let canCreateDescription = user.can.create ?
                "allows to create an allowed email domain" :
                "does not allow creating an allowed email domain";
            let canReadDescription = user.can.read ?
                "allows reading allowed email domains" :
                "does not allow reading an allowed email domains";
            let canUpdateDescription = user.can.update ?
                "allows to update an allowed email domain" :
                "does not allow updating an allowed email domain";
            let canDeleteDescription = user.can.delete ?
                "allows to delete an allowed email domain" :
                "does not allow deleting an allowed email domain";

            it(canCreateDescription, async () => {
                const createPromise = user.app.collection(collection).add(domain);

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
                const updatePromise = user.app
                    .collection(collection)
                    .doc("gmail.com")
                    .update({test: "updated"});

                if (user.can.update) {
                    await assertSucceeds(updatePromise)
                } else {
                    await assertFails(updatePromise)
                }
            });

            it(canDeleteDescription, async () => {
                const deletePromise =
                    user.app.collection(collection).doc("gmail.com").delete();

                if (user.can.delete) {
                    await assertSucceeds(deletePromise)
                } else {
                    await assertFails(deletePromise)
                }
            });
        });
        callback();
    });
}

describe("", async () => {
    const anonymousSignIn = await getApplicationWith(getAnonymousUser());

    const users = [
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
                'read': false,
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
                'read': false,
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
                'read': false,
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
                'read': false,
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
                'read': false,
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

    describe("Allowed email domains collection rules, public dashboard is enabled",
        () => {
            before(async () => {
                await setupTestDatabaseWith(
                    Object.assign({}, allowedEmailDomains, featureConfigEnabled));

                test(users);
            });

            after(async () => {
                await tearDown();
            });
        });
});

describe("", async () => {
    const anonymousSignIn = await getApplicationWith(getAnonymousUser());

    const users = [
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
                'read': false,
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
                'read': false,
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
                'read': false,
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
                'read': false,
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
                'read': false,
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

    describe("Allowed email domains collection rules, public dashboard is disabled", () => {
        before(async () => {
            await setupTestDatabaseWith(Object.assign({}, allowedEmailDomains, featureConfigDisabled));
        });

        test(users);
    });

    after(async () => {
        await tearDown();
    });

});

