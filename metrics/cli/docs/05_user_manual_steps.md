# The user’s manual steps

## Motivation
> What problem is this project solving?

The motivation for this document is to describe all user's manual steps to implement them easily using prompt in the Metrics CLI and to be able to automate them in the future.

## Goals
> Identify success metrics and measurable goals.

This document meets the following goal:
 - Provide an overview of all user's manual steps required during the Metrics deployment process using the Metrics CLI.

## Steps

### Sentry Configuration

Since the Metrics project using Sentry, we should provide a detailed instruction, which helps a user to configure Sentry during the Metrics deployment process using the Metrics CLI.

Here is a prompt instruction, which helps the user to configure the Sentry:

```text
Sentry configuration instruction:

To enable Sentry for the current deploying project, you should copy & paste a DSN from your Sentry account.

The following steps help to find a DSN for the Sentry account:
1. Visit the following link and authorize: https://sentry.io
2. Navigate to Settings -> Projects -> Client Keys (DSN)

Copy & paste your DSN here:
```

### Firebase auth configuration

Since the Metrics Project using Firebase Auth and the auth is disabled by default, we should provide a detailed instruction, 
which helps the user to configure a Firebase Auth with the [Email/Password](https://github.com/platform-platform/monorepo/blob/master/docs/09_firebase_deployment.md#firebase-email-and-password-sign-in-configuration) and [Google](https://github.com/platform-platform/monorepo/blob/master/docs/09_firebase_deployment.md#firebase-google-sign-in-configuration) auth providers during the Metrics deployment process using the Metrics CLI.

Here is a prompt instruction, which helps the user to configure Firebase auth:

```text
Firebase auth configuration instruction:

To enable Firebase auth for the current deploying project, consider the following steps:
1. Follow the link and click a "Get started" button: https://console.firebase.google.com/project/project_id/authentication
2. Navigate to the Sign-in method's tab on the Firebase auth page or use the following link: https://console.firebase.google.com/project/project_id/authentication/providers
3. Enable an Email/Password provider.
4. Enable a Google provider.
5. On the Google provider page, open the Web SDK configuration tab, copy the Web client ID and paste it to the console

Paste your Web client Id here:
```
### Firebase Analytics configuration

Since the Metrics Project using Firebase Analytics and the analytics is disabled by default, we should provide a detailed instruction,
which helps the user to configure the Firebase analytics during the Metrics deployment process using the Metrics CLI.

Here is a prompt instruction, which helps the user to configure Firebase analytics easily:

```text
Firebase analytics configuration instruction:

To enable Firebase analytics for the current deploying project, consider the following steps:

1. Follow the link and click an "Enable Google Analytics" button: https://console.firebase.google.com/project/project_id/settings/integrations/analytics

Press any key to continue:
```
### Default region configuration

Since the deployment of the Metrics project requires a GCloud project's region, we should provide a detailed instruction, 
which helps the user to select the [region/zone](https://cloud.google.com/compute/docs/regions-zones) during the Metrics deployment process using the Metrics CLI.

Here is a prompt instruction, which helps the user to select a GCloud project's region:

```text
Here is a list of available regions for gcloud project:

REGION                   SUPPORTS STANDARD  SUPPORTS FLEXIBLE
asia-east2               YES                YES
asia-northeast1          YES                YES
asia-northeast2          YES                YES
asia-northeast3          YES                YES
asia-south1              YES                YES
asia-southeast2          YES                YES
...............          ...                ...

Please enter the region name that suits you best:
```
### Initial Firestore Data configuration

Since the Metrics project controls the allowed email domains and features config using the Firestore database appropriate collections, 
we should provide a detailed instruction, which helps the user to initialize the Firestore database with the mentioned collections' data during the Metrics deployment process using the Metrics CLI.

Here is a prompt instruction, which helps the user to initialize the Firestore database:

```text
Initialize Firestore data instruction:

To initialize Firestore data for the current deploying project, consider the following steps:

1. Follow the link to open the Firestore database: https://console.firebase.google.com/project/project_id/firestore
2. Create a collection with the "allowed_email_domains" id.
3. Create document(s) with the "domain" id without any fields.
4. Create a collection with the "feature_config" id.
5. Create a document with the "feature_config" id.
6. Add the following boolean fields to the feature_config document:
   - "isDebugMenuEnabled" - Indicates whether the Debug Menu feature is enabled.
   - "isPasswordSignInOptionEnabled" - Indicates whether the Email and Password sign in option is enabled.

Press any key to continue:
```
### Blaze account configuration

Since some Firebase features, such as Firebase functions, are not available without a Blaze billing plan, we should provide a detailed instruction, which helps the user to configure the Blaze billing plan during the Metrics CLI deployment process.

Here is a prompt instruction, which helps the user to configure the Blaze billing plan:

```text
To configure Blaze billing plan for the current deploying project, consider the following steps:

1. Follow the link and press continue in the open modal window: https://console.firebase.google.com/project/project_id/overview?purchaseBillingPlan=metered&billingContext=pricingBuyFlow
2. Select your country and press "Confirm"
3. Enter your customer info, choose payment method and press "Confirm Purchase"

Press any key to continue:
```
