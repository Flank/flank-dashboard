# Enabling Firebase Authentication
> Feature description / User story.

The Metrics CLI tool's goal is to deploy a Metrics project to Firebase from scratch. Since the Metrics Web application uses Firebase Authentication, and the Firebase Authentication is disabled by default, we should find an approach to enabling Firebase Authentication with necessary providers.

Therefore, the document's goal is to investigate all approaches of enabling Firebase Authentication for a newly created Firebase project to make the Metrics CLI the most usable.

## References

> Link to supporting documentation, GitHub tickets, etc.

- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [Identity Toolkit API](https://cloud.google.com/identity-platform/docs/reference/rest)
- [Google OAuth 2.0](https://developers.google.com/identity/protocols/oauth2)
- [gcloud CLI auth](https://cloud.google.com/sdk/gcloud/reference/auth)

## Contents

- [**Analysis**](#analysis)    
    - [Landscape](#landscape)
        - [Manual](#manual)
        - [Using an API](#using-an-api)
          - [Enable Email & Password provider](#enable-email--password-provider)
          - [Enable Google sign-in provider](#enable-google-sign-in-provider)
        - [Decision](#decision)

# Analysis
> Describe a general analysis approach.

The analysis begins with an overview of enabling Firebase Authentication with necessary providers approaches during Metrics Web application deployment.
It provides the main pros and cons and a short description of each approach we've investigated.

This research should conclude with a chosen approach and a short explanation of why did we choose such an approach.

### Landscape
> Look for existing solutions in the area.

#### Manual

The first approach is to show a warning prompt after the firebase app creation, which told the user to enable Firebase Authentication and choose necessary providers in the Firebase console. The warning prompt should contain a link to the Firebase Authentication page in the Firebase console.

After enabling the Google sign-in provider, we should show a prompt, which asks the user to copy the provider's client id and paste it into the console. This allows us to pass it into the Metrics config, which makes the Google sign-in work on the deployed web app.

Let's review the pros and cons of the manual approach.

Pros:

- easy to implement;
  
Cons:

- complex configuration process for users (enable Firebase auth, enable sign-in providers, find & copy & paste the sign-in client id);
- not amenable to automation.

#### Using an API

The second approach is to use an [Identity Toolkit API](https://cloud.google.com/identity-platform/docs/reference/rest).

The first thing that we should do is enable the Firebase Authentication.
Unfortunately, the only way to do it, for now, is manually by visiting a Firebase console and clicking “Get started” on the Authentication tab.

Then, we should enable required sign-in providers using the `Identity Toolkit API` endpoints.
Both endpoints require a token with a `cloud-platform` scope, which GCloud CLI can provide. Since the API rejects the end-user token, we need to use the service account to receive the required token.

Please consider the following steps to receive the token:

1. Download a service account's key using the following command:

```bash
gcloud iam service-accounts keys create key.json --iam-account project_id@appspot.gserviceaccount.com
```

2. Auth with the service account using the following command:

```bash
gcloud auth activate-service-account project_id@appspot.gserviceaccount.com --key-file=key.json
```

3. The next command prints a token into the console:

```bash
gcloud auth print-access-token
```

4. Retrieve the token from the console.

Once we have received the token, we can start working with the API.

##### Enable Email & Password provider

We should call the next endpoint to enable the Email provider:

```bash
PATCH https://identitytoolkit.googleapis.com/admin/v2/projects/${projectId}/config
```

The request body must contain the following:

```json
{
  "name" : "projects/${projectId}/config",
  "signIn" : {
     "email" : {
        "enabled": true,
        "passwordRequired": true
      }
  }
}
```

##### Enable Google sign-in provider

The following request requires the client id and client secret from the [GCloud credentials page](https://console.cloud.google.com/apis/credentials) in addition to the token.

Unfortunately, there is unavailable to retrieve them using  GCloud CLI or API, so we should show a prompt, which told the user to go to the [Credentials page](https://console.cloud.google.com/apis/credentials), open the OAuth 2.0 web Client IDs, and asks to copy & paste the client id and client secret into the console.

Then we can request the following endpoint:

```bash
POST https://identitytoolkit.googleapis.com/admin/v2/projects/${projectId}/defaultSupportedIdpConfigs/google.com
```
The request body must contain the following:

```json
{
  "enabled": true,
  "clientId": "client id from OAuth 2.0 Web client",
  "clientSecret": "client secret from OAuth 2.0 Web client"
}
```

Finally, since we've already had a client id, we should pass it to the Metrics Config, which makes the Google sign-in work on the deployed web app.

Let's review the pros and cons of the API approach.

Pros:

- provides an ability to ensure that the required auth providers are enabled to proceed with deployment.
- less user interaction required than in the previous [approach](#manual).

Cons:

- still requires user interaction.

#### Decision

As we analyzed above, both cases require manual actions, but in the [API approach](#using-an-api), the user will not need to worry about enabling required providers, so we should choose an [API approach](#using-an-api) because it requires less action from the user side.
