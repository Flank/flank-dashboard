/**
 * A class representing a configuration that is used within the application.
 */
class MetricsConfig {
    /**
     * Creates a new instance of the MetricsConfig with default value for each configuration item.
     */
    constructor() {
        this.sentryDsn = "$SENTRY_DSN";
        this.sentryRelease = "$SENTRY_RELEASE";
        this.sentryEnvironment = "$SENTRY_ENVIRONMENT";
        this.googleSignInClientId = "$GOOGLE_SIGN_IN_CLIENT_ID";
    }
}
