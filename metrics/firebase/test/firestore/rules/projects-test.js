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
    project,
    projects,
    getAllowedEmailUser,
    getDeniedEmailUser,
    passwordSignInProviderId,
    googleSignInProviderId,
    allowedEmailDomains,
    getAnonymousUser,
    featureConfigEnabled,
    featureConfigDisabled,
} = require("./test_utils/test-data");

const collection = "projects";

function test(users, unauthenticatedApp, passwordProviderAllowedEmailApp) {
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

    async.forEach(users, (user, callback) => {
        describe(user.describe, () => {
            let canCreateDescription = user.can.create ?
                "allows to create a project" : "does not allow creating a project";
            let canReadDescription = user.can.read ?
                "allows reading projects" : "does not allow reading projects";
            let canUpdateDescription = user.can.update ?
                "allows to update a project" : "does not allow updating a project";
            let canDeleteDescription = user.can.delete ?
                "allows to delete a project" : "does not allow deleting a project";

            it(canCreateDescription, async () => {
                const createPromise = user.app.collection(collection).add(project);

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
                const updatePromise = user.app.collection(collection).doc("1").update(project);

                if (user.can.update) {
                    await assertSucceeds(updatePromise)
                } else {
                    await assertFails(updatePromise)
                }
            });

            it(canDeleteDescription, async () => {
                const deletePromise = user.app.collection(collection).doc("1").delete();

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

describe("", async function () {
    const unauthenticatedApp = await getApplicationWith(null);
    const passwordProviderAllowedEmailApp = await getApplicationWith(
        getAllowedEmailUser(passwordSignInProviderId, true)
    );
    const anonymousSignIn = await getApplicationWith(getAnonymousUser());

    const users = [
        {
            'describe': 'Authenticated as an anonymous user',
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
            'app': passwordProviderAllowedEmailApp,
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

    describe("Projects collection rules", () => {
        before(async () => {
            await setupTestDatabaseWith(
                Object.assign({}, projects, allowedEmailDomains, featureConfigEnabled)
            );
        });

        test(users, unauthenticatedApp, passwordProviderAllowedEmailApp);
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
    const anonymousSignIn = await getApplicationWith(getAnonymousUser());

    const users = [
        {
            'describe': 'Authenticated as an anonymous user',
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
            'app': passwordProviderAllowedEmailApp,
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

    describe("Projects collection rules, public dashboard is disabled", () => {
        before(async () => {
            await setupTestDatabaseWith(
                Object.assign({}, projects, allowedEmailDomains, featureConfigDisabled)
            );
        });

        test(users, unauthenticatedApp, passwordProviderAllowedEmailApp);
    });

    after(async () => {
        await tearDown();
    });
});
