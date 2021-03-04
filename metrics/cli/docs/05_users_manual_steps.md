# The user’s manual steps

## Motivation
> What problem is this project solving?

The motivation for this document is to have descriptions of all manual steps to be able to automate them in the future.

## Goals
> Identify success metrics and measurable goals.

This document meets the following goal:
 - Provide an overview of all user manual steps required during the Metrics deployment process.

## User's Manual Steps
### Sentry Configuration
Since the Sentry configuration requires `DSN`, which a user should retrieve from the [Sentry page](https://sentry.io) and visit the following `Settings -> Projects -> Client Keys (DSN)`. Here is a prompt instruction, which helps the user to configure the Sentry:
```text
Sentry configuration:
To enable Sentry for the current deploying project, you should copy & paste a DSN for your Sentry account.
Here is instructions, where you can find your DSN:
1. Visit the following link and authorize: https://sentry.io
2. Navigate to Settings -> Projects -> Client Keys (DSN)
Enter your DSN here:
```
### Firebase auth configuration
The user should configure [Email/Password](https://github.com/platform-platform/monorepo/blob/master/docs/09_firebase_deployment.md#firebase-email-and-password-sign-in-configuration) and [Google](https://github.com/platform-platform/monorepo/blob/master/docs/09_firebase_deployment.md#firebase-google-sign-in-configuration) auth providers to have the opportunity to login into the app. The prompt below helps the user to configure Firebase auth:
```text
Firebase auth configuration:
To enable Firebase auth for the current deploying project, consider the following steps:
1. Follow the link and click a "Get started" button: https://console.firebase.google.com/project/project_id/authentication
2. Navigate to the Sign-in method's tab on the Firebase auth page or use the following link: https://console.firebase.google.com/project/project_id/authentication/providers
3. Enable an Email/Password provider.
4. Enable a Google provider.
5. On the Google provider page, open the Web SDK configuration tab, copy the Web client ID and paste it to the console
Enter your Web client Id here:
```
### Firebase Analytics
The Metrics project has build-in integration with Firebase analytics, so the user only needs to enable it in the Firebase. The following prompt helps the user to configure Firebase analytics:
```text
Firebase analytics configuration:
To enable Firebase analytics for the current deploying project, consider the following steps:
1. Follow the link and click a "Enable Google Analytics" button: https://console.firebase.google.com/project/project_id/settings/integrations/analytics
Press an enter key to continue:
```
### Default region configuration
The user should indicate in which [region/zone](https://cloud.google.com/compute/docs/regions-zones) to deploy the current project. The next prompt helps the user to select a default GCloud project's region:
```text
Here is a list of available regions for gcloud project:
REGION                   SUPPORTS STANDARD  SUPPORTS FLEXIBLE
asia-east2               YES                YES
asia-northeast1          YES                YES
asia-northeast2          YES                YES
asia-northeast3          YES                YES
asia-south1              YES                YES
asia-southeast2          YES                YES
Please enter the region name that suits you best:
```
### Initial Firestore Data
The user should create configuration files in the repository for the Metrics application to work properly. Here is a prompt, which helps the user to configure a default Firestore Data:
```text
Initial Firestore Data:
To seed initial Firestore data for the current deploying project, consider the following steps:
1. Create a collections with the "allowed_email_domains" id.
2. Create document(s) with the "domain" id without fields.
3. Create a collections with the "feature_config" id.
4. Create document with the "feature_config".
5. Add following boolean fields to the feature_config document:
"isDebugMenuEnabled" - Indicates whether the Debug Menu feature is enabled.
"isPasswordSignInOptionEnabled" - Indicates whether the Email and Password sign in option is enabled.
```
### Blaze account configuration
Since some Firebase features, such as Firebase functions, are not available without a Blaze billing plan, the user should configure it. The prompt below helps the user to configure Blaze billing plan:
```text
To configure Blaze billing plan for the current deploying project, consider the following steps:
1. Follow the link and press continue in the open modal window: https://console.firebase.google.com/project/project_id/overview?purchaseBillingPlan=metered&billingContext=pricingBuyFlow
2. Select your country and press "Confirm"
3. Enter your customer info, choose payment method and press "Confirm Purchase"
```
