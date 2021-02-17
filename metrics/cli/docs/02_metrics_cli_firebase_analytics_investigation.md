# Motivation
> What problem is this project solving?

First of all, the Metrics project using Firebase Analytics to track useful information such as a user's login, a page's using, etc.

Secondly, the Metrics CLI tool's goal is to deploy a Metrics project to Firebase from scratch, but for the newly created Firebase project, the Firebase Analytics is disabled. 

Therefore, the document's goal is to investigate solutions of enabling Firebase analytics for a newly created Firebase project.

## References
> Link to supporting documentation, GitHub tickets, etc.

- [Firebase Management API](https://firebase.google.com/docs/projects/api/reference/rest)
- [Google Analytics Management API](https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference)
- [Compute engine API](https://cloud.google.com/compute/docs/reference/rest/v1)
- [Google OAuth 2.0](https://developers.google.com/identity/protocols/oauth2)
- [gcloud CLI auth](https://cloud.google.com/sdk/gcloud/reference/auth)

# Analyze

## Process

The analysis begins with the selection of the best solution to enable Firebase Analytics, which we investigated.

The research concludes with a short description of the solutions, and a list of pros and cons of each.

### Manual

The first solution is to show a warning prompt to a user before the deploying hosting, which told him to enable Firebase Analytics in the Firebase console to make it work for the current project. Also, the warning prompt should contain a link to the Firebase Analytics page in the Firebase console.

Let's describe the pros and cons of the manual solution.

Pros:

- easy to implement;

- easy to do from the user side (visit the printed link and click the `Enable Google Analytics` button).

Cons:

- not an automatic solution.

### Using an API

The second solution is to use a [Firebase Management API](https://firebase.google.com/docs/projects/api/reference/rest) and a [Google Analytics Management API](https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference).

The APIs contain the following required endpoints:
- [`Google analytics summaries`](https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/accountSummaries/list) to retrieve a Google analytics' account id;
- [`Add google analytics`](https://firebase.google.com/docs/projects/api/reference/rest/v1beta1/projects/addGoogleAnalytics) to link the Google analytics with Firebase Analytics.
    
To enable Firebase analytics using the API described above, consider the following steps:

1. Enable Google analytics API in GCloud, which create Google analytics account for the newly created GCloud project.
2. Call the `Google analytics summaries` endpoint.
3. Call the `Add google analytics` endpoint with the Google analytics' account id retrieved from the previous step.

Unfortunately, the `Google analytics summaries` endpoint require a token with an `analytics.edit` scope. 

Here is a table, which describes how to get the token with a specific scope:

| Solution | **Description** | **Problems** |
| --- | --- | --- |
| **[Configure OAuth 2.0](https://support.google.com/cloud/answer/6158849) for the current GCloud project** | Allows us to get the token with required scope using OAuth 2.0 | The user should manually configure an [OAuth consent screen](https://support.google.com/cloud/answer/10311615) |
| **Enable [compute engine API](https://cloud.google.com/compute/docs/reference/rest/v1) in GCloud account** | Allow us to give a required scope for Gcloud project service accounts using the command described [here](https://cloud.google.com/compute/docs/access/create-enable-service-accounts-for-instances). Then we can [authenticate](https://cloud.google.com/sdk/gcloud/reference/auth/activate-service-account) using the service account with the required scope and [print the service account token](https://cloud.google.com/sdk/gcloud/reference/auth/print-access-token). | The compute engine API requires enabling the Gcloud billing account, which a manually step only |

Let's describe the pros and cons of the API solution.

Pros:

- perhaps in the future, it will be possible to enable the OAuth consent screen or billing account programmatically.

Cons: 

- complicated implementation;
- requires complicated steps from the user side (configure OAuth consent screen, configure billing account);
- for now, it is not an automatic solution.

## Decision

As we've analyzed above, the [API solution](#using-an-api) is too complicated for now. We should choose a described [manual solution](#manual) to enable Firebase Analytics.
