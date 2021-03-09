# The user’s manual steps

## Motivation
> What problem is this project solving?

The motivation for this document is to describe all user's manual steps to implement them easily using prompt in the Metrics CLI and to be able to automate them in the future.

## Goals
> Identify success metrics and measurable goals.

This document meets the following goal:
 - Provide an overview of all user's manual steps required during the Metrics deployment process using the Metrics CLI.

## Steps

### Default region configuration

During the deployment process, the user should select the region the `GCloud services` will locate. Review the following prompt explaining the process of choosing the `GCloud` project region:

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

### Blaze account configuration

The Metrics Web application uses the Firebase functions that are not available in the Free Firebase plan, so the user should enable the Blaze billing plan. 
To simplify this process, we should add the following prompt containing detailed instructions on how to enable the Blaze plan: 

```text
To configure the Blaze billing plan for the Firebase project, consider the following steps:

1. Follow the link and press continue in the open modal window: https://console.firebase.google.com/project/${project_id}/overview?purchaseBillingPlan=metered&billingContext=pricingBuyFlow
2. Select your country and press "Confirm"
3. Enter your customer info, choose payment method and press "Confirm Purchase"

Press any key to continue once the billing plan configured: 
```

### Adding initial Firestore data

Since the Metrics project controls the allowed email domains and features config using the Firestore database appropriate collections, 
we should provide a detailed instruction describing the initialization of the Firestore database with the initial data during the deployment process using the following prompt:

```text
To initialize Firestore data for the currently deploying project, consider the following steps:

1. Follow the link to open the Firestore database: https://console.firebase.google.com/project/${project_id}/firestore
2. Create a collection with the "allowed_email_domains" identifier.
3. Create document(s) with the "domain" identifier without any fields.
4. Create a collection with the "feature_config" identifier.
5. Create a document with the "feature_config" identifier.
6. Add the following boolean fields to the feature_config document:
   - "isDebugMenuEnabled" - Indicates whether the Debug Menu feature is enabled.
   - "isPasswordSignInOptionEnabled" - Indicates whether the Email and Password sign in option is enabled.

Consider the following link for a more detailed guide of creating "allowed_email_domains" collection: 
https://github.com/platform-platform/monorepo/blob/master/docs/09_firebase_deployment.md#google-sign-in-allowed-domains-configuration

Consider the following link for a detailed structure of the "feature_config" collection:
https://github.com/platform-platform/monorepo/blob/master/docs/19_security_audit_document.md#the-feature_config-collection

Press any key to continue when you finish with the Firestore database initialization:
```

### Firebase Analytics configuration

To make the Metrics Web application send the analytics data to the Firestore, the user should enable the Firestore Analytics service in the Firestore console. 

During the deployment process, we should display the following prompt explaining how to enable the Firestore analytics:

```text
To enable Firebase analytics for the currently deploying project, follow the next steps:

1. Follow the link and click an "Enable Google Analytics" button: https://console.firebase.google.com/project/${project_id}/settings/integrations/analytics

Once you are done, press any key to continue:
```

### Firebase auth configuration

To simplify the Firebase auth configuration, we are going to provide instructions on how to configure it for the Metrics application during the deployment process. 

These instructions will contain information on how to configure the following auth providers: 
- [Google](https://github.com/platform-platform/monorepo/blob/master/docs/09_firebase_deployment.md#firebase-google-sign-in-configuration)
- [Email and Password](https://github.com/platform-platform/monorepo/blob/master/docs/09_firebase_deployment.md#firebase-email-and-password-sign-in-configuration)

Consider the following prompt instructions helping to configure the Firebase Auth:

```text
To enable the Firebase Auth for the Metrics Web application, consider the following steps:

1. Follow the link and click a "Get started" button: https://console.firebase.google.com/project/${project_id}/authentication
2. Navigate to the 'Sign-in method' tab on the Firebase auth page or use the following link: https://console.firebase.google.com/project/${project_id}/authentication/providers
3. Enable an Email/Password provider by clicking on provider name and toggling the `Enable` switch.
4. Enable a Google provider by clicking on provider name and toggling the `Enable` switch.
5. On the 'Google' provider popup, open the 'Web SDK configuration' tab, copy the Web client ID and paste it to the console

Paste your Web client Id here:
```

### Sentry Configuration

Since the Metrics Web application uses Sentry, we should provide detailed instruction to help a user configure a Sentry release during the Metrics application deployment process.
Let's review prompts instructions that will help configure a new Sentry release.

The first required thing for the Sentry release is an `Organization Slug`. The `Organization Slug` is a unique identifier of the user's organization and is required for the Sentry CLI commands. 

Here is a prompt for authorizing to the Sentry and retrieving the `Organization Slug`:
```text
The following steps help to find an `Organization Slug` for the Sentry account:

1. Visit the following link and authorize: https://sentry.io
2. Navigate to the Sentry's `Settings` tab
3. Navigate to the `General Settings` tab and copy an `Organization Slug`

Paste the `Organization Slug` here:
```

The second required thing is a `Project Slug`. The `Project Slug` is a unique identifier of the user's project and is required for the Sentry CLI commands. 

Here is a prompt for retrieving the `Project Slug`:
```text
The following steps help to find a `Project Slug` for the Sentry account:

1. Visit the following link: https://sentry.io/settings/${organization_slug}/projects/
2. Select a required project and copy a `Project Name` field

Paste the `Project Name` here:
```

The third required thing is a [DSN](https://docs.sentry.io/product/sentry-basics/dsn-explainer/). The `DSN` is a public client key, which tells the SDK where to send the events and is required for the Sentry SDK initialization.

Here is a prompt for retrieving the `DSN`:
```text
The following steps help to find a `DSN` for the Sentry account:

1. Visit the following link: https://sentry.io/settings/${organization_slug}/projects/${project_slug}/keys/
2. Copy your DSN

Paste the DSN here:
```
The final required thing is a `Sentry release name`. The release name is used as a parameter in the Sentry CLI commands for updating source maps. Also, it's required for the Sentry SDK initialization.

Here is a final prompt for retrieving the `Sentry release name`:
```text
The last thing required for the Sentry configuration is a release name. The Sentry web page will display the entered release name in the issues tags.

While creating a release name, consider it cannot:  
- contain newlines, tabulator characters, forward slashes(/), or back slashes()
- be (in their entirety) period (.), double period (..), or space ( )
- exceed 200 characters

Please enter your Sentry release name:
```

