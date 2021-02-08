// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

/**
 * A class representing a configuration that is used within the application.
 */
class MetricsConfig {
    /**
     * A unique ID of the client that is used to initialize Google Sign-In for the application.
     *
     * @type {string}
     */
    googleSignInClientId;

    /**
     * A Data Source Name value that is used to configure Sentry.
     *
     * @type {string}
     */
    sentryDsn;

    /**
     * An environment property value that is used for Sentry initialization.
     *
     * @type {string}
     */
    sentryEnvironment;

    /**
     * A release property value that is used for Sentry initialization.
     *
     * @type {string}
     */
    sentryRelease;

    /**
     * Creates a new instance of the MetricsConfig with default value for each configuration item.
     */
    constructor() {
        this.googleSignInClientId = "$GOOGLE_SIGN_IN_CLIENT_ID";
        this.sentryDsn = "$SENTRY_DSN";
        this.sentryEnvironment = "$SENTRY_ENVIRONMENT";
        this.sentryRelease = "$SENTRY_RELEASE";
    }
}
