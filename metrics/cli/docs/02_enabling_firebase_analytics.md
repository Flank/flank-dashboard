# Enabling Firebase Analytics

## Motivation
> What problem is this project solving?

The Metrics CLI tool's goal is to deploy a Metrics project to Firebase from scratch. Since the Metrics Web application uses Firebase Analytics, and the Firebase Analytics is disabled by default, we should find an approach to enabling it.

Therefore, the document's goal is to investigate all approaches of enabling Firebase analytics for a newly created Firebase project, to make the Metrics CLI the most usable.

### References
> Link to supporting documentation, GitHub tickets, etc.

- [Firebase Management API](https://firebase.google.com/docs/projects/api/reference/rest)
- [Google Analytics Management API](https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference)
- [Compute engine API](https://cloud.google.com/compute/docs/reference/rest/v1)
- [Google OAuth 2.0](https://developers.google.com/identity/protocols/oauth2)
- [gcloud CLI auth](https://cloud.google.com/sdk/gcloud/reference/auth)

## Analyze

### Process

The analysis begins with an overview of enabling Firebase Analytics approaches during Metrics Web application deployment.
It provides the main pros and cons and a short description of each approach we've investigated.

The research should conclude with a chosen approach and a short description of why did we choose such approach.

#### Manual

The first option is to show a warning prompt to a user before deploying the application to the hosting, which told him to enable Firebase Analytics in the Firebase console to make it available for the current project. Also, the warning prompt should contain a link to the Firebase Analytics page in the Firebase console.

Let's review the pros and cons of this option.

Pros:

- easy to implement;

- provides simple and understandable steps for users (visit the printed link and click the `Enable Google Analytics` button).

Cons:

- does not allow us to deploy the application from the CIs since it requires user interaction.

#### Using an API

The second approach is to call an [endpoint](https://firebase.google.com/docs/projects/api/reference/rest/v1beta1/projects/addGoogleAnalytics) from the [Firebase Management API](https://firebase.google.com/docs/projects/api/reference/rest), which enables Firebase Analytics for the current Firebase project.

The endpoint's request body described above requires an `analytics account id`, which we can get from the [`Google analytics summaries endpoint`](https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/accountSummaries/list).

The `Google analytics summaries enpoint` requires a token with an `analytics.edit` scope. 

Here is a table, which describes how to get the token with a specific scope:

| Solution | **Description** | **Problems** |
| --- | --- | --- |
| **[Configure OAuth 2.0](https://support.google.com/cloud/answer/6158849) for the current GCloud project** | Allows us to get the token with required scope using OAuth 2.0 | The user should manually configure an [OAuth consent screen](https://support.google.com/cloud/answer/10311615) |
| **Enable [compute engine API](https://cloud.google.com/compute/docs/reference/rest/v1) in GCloud account** | Allow us to give a required scope for Gcloud project service accounts using the command described [here](https://cloud.google.com/compute/docs/access/create-enable-service-accounts-for-instances). Then we can [authenticate](https://cloud.google.com/sdk/gcloud/reference/auth/activate-service-account) using the service account with the required scope and [print the service account token](https://cloud.google.com/sdk/gcloud/reference/auth/print-access-token). | The compute engine API requires enabling the Gcloud billing account, which a manually step only |

Pros:

- provides an ability to ensure the Firebase Analytics is enabled, and we can proceed with the deployment process.

Cons: 

- complicated implementation;
- requires complicated steps from the user side (configure OAuth consent screen, configure billing account);
- does not allow automating the Firebase Analytics enabling process.

### Decision

As we've analyzed above, the [API method](#using-an-api) does not allow us to automate the Firebase Analytics enabling process for now, so
we have to choose the described [manual method](#manual) to enable Firebase Analytics because the manual steps is easier and faster for the user.
