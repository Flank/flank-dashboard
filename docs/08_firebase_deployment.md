# Metrics firebase deployment

> Summary of the proposed change

Describe the process of deployment of the Metrics application to the Firebase Hosting and deploying the Cloud functions needed to create test data for the application.

# References

> Link to supporting documentation, GitHub tickets, etc.

- [Getting started with Firestore](https://cloud.google.com/firestore/docs/client/get-firebase)
- [Deploying to Firebase Hosting](https://firebaseopensource.com/projects/firebase/emberfire/docs/guide/deploying-to-firebase-hosting.md/)
- [Getting started with Firebase Cloud Functions](https://firebase.google.com/docs/functions/get-started)

# Motivation

> What problem is this project solving?

The Metrics application instance accessible via a link.

# Goals

> Identify success metrics and measurable goals.

- Web application is deployed to Firebase Hosting and available for everyone via the link.
- The Cloud Functions required for creating test data are deployed.

# Non-Goals

> Identify what's not in scope.

Deployment to other platforms is out of scope.

# Design

> Explain and diagram the technical design

`Metrics Web Source` -> `Build` -> `Deploy` ->  `Firebase Hosting`

`Metrics Web Cloud Functions` -> `Deploy` -> `Firebase Cloud Functions`

`Metrics Web Security Rules` -> `Deploy` -> `Firestore Security Rules`

`Metrics Web Indexes` -> `Deploy` -> `Firestore Indexes`

> Identify risks and edge cases

# API

> What will the proposed API look like?

## Before you begin

Before you start, you should have the following installed:

1. [Flutter](https://flutter.dev/docs/get-started/install)
2. [npm](https://www.npmjs.com/get-npm)

To view the recommended versions of the dependencies, please check out the [dependencies file](https://github.com/platform-platform/monorepo/raw/update_metrics_cli_readme/metrics/cli/recommended_versions.yaml).

## Creating a new Firebase project.

1. Go to [Firebase Console](https://console.firebase.google.com/), login if needed, and tap the `Add project` button.
2. Enter a project name and tap the `Continue` to proceed.
3. On the next page, select whether you want to use Firebase Analytics or not and click the `Continue`/`Create project` to proceed.
4. If you choose to use Firebase Analytics in the previous step select a Firebase Analytics account and tap the `Create project`.

After a couple of seconds, your project will be ready, and you'll be redirected to the project console.
Your next step will be to create a Firestore database:

1. Go to the `Database` tab on the left bar and click the `Create database` button under the `Cloud Firestore`.
2. Select `Start in test mode` to create a database with no security rules for now and tap `Next`. We will add security rules in the [Configuring Firestore database](#Configuring-Firestore-database) section.
3. Select your database location and click `Done`.

After a while, your database will be created, and you will see the database console page.

## Firebase configuration

When your Firestore database is up, you need to add a Web application to your Firebase project,
to be able to connect your web application with the Firestore database:

1. In the [Firebase Console](https://console.firebase.google.com/), open your project and tap on the setting gear icon near the `Project Overview` on top of the left panel and select `Project settings`.
2. Scroll down and find `There are no apps in your project` text, and tap on the `</>` icon to add a new Web application to your Firebase project.
3. Enter the app nickname and make sure that `Also set up Firebase Hosting for this app` is checked.
4. Select from the dropdown menu, or create a new site for your application and tap the `Register app` to proceed.
5. Skip the `Configure Firebase SDK` step. We will return to Firebase SDK configuration a bit later in [Firebase SDK configuration](#Firebase-SDK-configuration).
6. Tap on the `Next` button and follow instructions to install the Firebase CLI.
7. Skip the `Deploy to Firebase Hosting` and tap on the `Continue to console` to finish configuring your Firebase Web application.

The deployment process described more detailed in the [Building and deploying the application to the Firebase Hosting](#Building-and-deploying-the-application-to-the-Firebase-Hosting) section.

Finally, your Firebase project configured and it's time to configure the Firebase SDK in your Flutter for the Web application.

## Firebase SDK configuration

By default, the Metrics Web Application is configured by using the `auto-generated` Firebase configuration. It means that after you deploy the Metrics application to the Firebase, your app automatically pulls the Firebase configuration object from the Firebase project to which you've deployed.

If you are okay with the defaults, you can skip this configuration step.

If you want to configure a connection to the Firebase `manually`, follow the next steps:
1. Open the [Firebase console](https://console.firebase.google.com/), choose your project
and go to the project setting (tap on the setting gear icon near the `Project Overview` on top of the left panel and select `Project settings`).
2. Scroll down and find your Firebase Web Application.
3. Go to `Firebase SDK snippet` of your application, select `Config` and copy the generated code.
4. Go to the `web/index.html` file in the application directory and replace the following piece of code:

```
  <script src="/__/firebase/init.js"></script>
```

with the:

```
// Your web app's Firebase configuration, copied one in the step 3
const firebaseConfig = {...};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);
```

The full example of how the Firebase configuration in the `index.html` looks like:

  - `auto-generated` Firebase configuration
```
// Firebase SDKs
<script src="https://www.gstatic.com/firebasejs/7.5.0/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/7.5.0/firebase-analytics.js"></script>
...

<script src="/__/firebase/init.js"></script>
```

 - `manual` configuration
```
<script src="https://www.gstatic.com/firebasejs/7.5.0/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/7.5.0/firebase-analytics.js"></script>
...

const firebaseConfig = {
  apiKey: "AIzaSyCkM-7WEAb9GGCjKQNChi5MD2pqrcRanzo",
  authDomain: "metrics-d9c67.firebaseapp.com",
  databaseURL: "https://metrics-d9c67.firebaseio.com",
  projectId: "metrics-d9c67",
  storageBucket: "metrics-d9c67.appspot.com",
  messagingSenderId: "650500796855",
  appId: "1:650500796855:web:65a4615a28f3d88e8bb832",
  measurementId: "G-3DB4JFLKHQ"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);
```

Finally, you have a configured Flutter application that works with your Firebase instance.
It's time to deploy your Flutter application to the Firebase Hosting!

## Firebase Email and Password Sign-In configuration

The email and password sign-in option allows authorizing to the application using the email and password a user has been created with. About how to create a new user with email and password consider the [Creating a new Firebase User](#creating-a-new-firebase-user) section. _Please note, that adding a new user requires the email and password sign-in option to be enabled!_

To enable the email and password sign-in option, consider the following steps:

1. Open the [Firebase console](https://console.firebase.google.com/) and choose your project.
2. Navigate to `Authentication` -> `Sign-in method`.
3. Press the `Email/Password` item in the `Sign-in providers` table.
4. Enable the `Email/Password` sign-in method using the toggle in the opened menu.
5. Press the `Save` button.

The email and password sign-in option is controlled by the remote `Feature Config` stored in the Firestore. The `isPasswordSignInOptionEnabled` configuration stands for the email and password auth form availability on the Login Page of the application. If the `isPasswordSignInOptionEnabled` is `false` then users are not allowed to log in using the email and password sign-in method and no appropriate authentication form appears on the UI. To know more about the `Feature Config` consider the [Feature Config](https://github.com/platform-platform/monorepo/blob/master/metrics/web/docs/features/feature_config/01_feature_config_design.md) design document.

To enable the email and password authentication form, consider the following steps:

1. Open the [Firebase console](https://console.firebase.google.com/) and choose your project.
2. Navigate to `Cloud Firestore` -> `Data`.
3. Open the `feature_config` collection (or create one by pressing the `Start collection` button).
4. Open the `feature_config` document (or create one by pressing the `Add document` button).
5. Find the `isPasswordSignInOptionEnabled` field (or create one by pressing the `Add field` button).
6. Ensure the `isPasswordSignInOptionEnabled` value is `true`.
7. Press the `Update` button to save the field value.

When both the email and password sign-in option and appropriate feature config is enabled, users can use their credentials to sign in to the application.

## Firebase Google Sign-In configuration

The Google sign-in option allows authorizing to the application using Google.
To enable the Google sign-in option, consider the following steps:

1. Open the [Firebase console](https://console.firebase.google.com/) and choose your project.
2. Navigate to `Authentication` -> `Sign-in method`.
3. Press the `Google` item in the `Sign-in providers` table.
4. Enable the `Email/Password` sign-in method using the toggle in the opened menu.
5. Expand `Web SDK Configuration` panel in the opened menu and copy `Web client ID`, and press `Save` to save configurations.
6. Open `metrics/web/web/metric_config.js` and replace `this.googleSignInClientId =  "$GOOGLE_SIGN_IN_CLIENT_ID";` with your OAuth Client ID.

Once the Google sign-in option is enabled it should work out of the box on default hosting domain. If you would like to add additional domains you should populate the `Authorized JavaScript origins` with URLs related to these domains. Consider the following steps:

1. Open the [Google Cloud Platform](https://console.cloud.google.com/home/dashboard) and select your project in the top left corner.
2. Open the side menu and go to the `APIs & Services` section.
3. Go to the `Credentials` section, find the `Web client` in `OAuth 2.0 Client IDs` section and open it.
4. Then you should find the `Authorized JavaScript origins` section. That is the place where you can add any URL origins that will have access to the Google sign-in.

_**Note:** The Google sing-in option requires configuring the allowed email domains. Consider the [Google Sign-in allowed domains configuration](#google-sign-in-allowed-domains-configuration) section to know more about allowed email domains._

### Google Sign-in allowed domains configuration

The application validates users' email domains when they sign in with Google. These domains are stored within the `Cloud Firestore` database. To configure allowed email domains, consider the following steps:

1. Browse to the [Firebase Console](https://console.firebase.google.com/) and select the project, created in previous steps.
2. Open the `Cloud Firestore` section on the left panel.
3. Press the `Start collection` button, enter the `allowed_email_domains` as a collection ID, and press the `Next` button.
4. After you tapped the `Next` button, you'll be asked to add the first document to your collection. This is the point where we start adding the allowed user email domains for the application. For example, if we want to allow the `gmail.com` domain, we should create an empty document with the `gmail.com` document ID.

To add more allowed email domains you should add a new document for each email domain with the domain itself as a document ID.

_**Note:** It is required for the allowed email domains collection to be not empty. Empty collection means that no email domains are allowed and the Google sign-in will fail with any domain._

## API Key Restrictions

To enable API key restrictions, follow the next steps:

First, let's restrict the browser key:

1. Open the [Google Cloud Platform](https://console.cloud.google.com/home/dashboard) and select your project in the top left corner.
2. Open the side menu and go to the `APIs & Services` section.
3. Go to the `Credentials` section, find the `Browser Key` in the `API Keys` section and open it.
4. Under the `Application restrictions`, click `HTTP referrers(web sites)` and then `Add an item` to add URLs that can use this API key.
5. To specify the APIs available for this key, scroll down to the `API Restrictions` section, and click the `Restrict key` button.
6. In the opened dropdown, enable the following APIs: `Google Identity Toolkit API`, `Token Service API`, `Firebase Installations API`, and `Firebase Management API`.
7. Click the `Save` button.

To be able to synchronize the build data using the CI Integrations tool, we need to set up a new API key. The following steps are required to do so:

1. Go back to the [Credentials](https://console.cloud.google.com/apis/credentials) section.
2. Click the `Create Credentials` button at the top of the page and select `API Key`.
3. In the opened dialog, click the `Restrict Key` button.
4. Set a new name of the created `API key`, e.g. `CI Integrations Key`.
5. Scroll down to the `API Restrictions` section and click the `Restrict key` button.
6. In the displayed dropdown, enable the `Google Identity Toolkit API`.
7. Click the `Save` button.

After that, update the CI Integration configurations to use the previously created key.

## Building and deploying the application to the Firebase Hosting

### Preparing your environment
Before building and deploying Metrics application, make sure you have the correct Flutter version installed.
The required version of Flutter is `v1.25.0-8.2.pre`.
The following command prints the current Flutter version on your machine:

```
flutter --version
```

If current version differs from the required one you can change it by running the following commands:

```
cd $(which flutter | xargs dirname) && git checkout 1.25.0-8.2.pre
```
_**Note:** The above commands works correctly on Unix based operating systems (verified: macOS and Ubuntu)! Before using, consider rewriting it according to your operating system._

Also, you should enable Flutter Web support by running the command below:

```
flutter config --enable-web
```

### Building Flutter application

Once you've installed Flutter you can build the application to deploy it then to the Firebase Hosting as described in the next section. To build Metrics Web Application consider the following steps:

1. Open the terminal and navigate to the `metrics/web` project folder.
2. Run the `flutter build web --release` to build the release version of the application.

The built application is located under the `build/web` folder. By default, Flutter builds a version that uses the HTML renderer that lacks performance on the desktop. Instead, one can use the Skia renderer that significantly improves performance on the desktop but breaks the application on mobile. The solution is to use auto renderer that automatically chooses which renderer to use. To enable auto renderer it is required to set the `FLUTTER_WEB_AUTO_DETECT` flag to `true` using the `--dart-define` argument of the `flutter build` command. Consider the following example:

```bash
flutter build web --release --dart-define=FLUTTER_WEB_AUTO_DETECT=true
```

#### Building with Sentry support

The Metrics Web Application uses Sentry to report errors occurred during the app execution. Sentry requires additional configurations related to the application building. Thus, it requires binding DSN and release options Sentry uses to report errors. To know more about the Sentry options itself and how to bind them consider the [Metrics Logger](https://github.com/platform-platform/monorepo/blob/master/metrics/web/docs/features/metrics_logger/01_metrics_logger_design.md) document and [Sentry Integration](https://github.com/platform-platform/monorepo/blob/master/metrics/web/docs/features/metrics_logger/01_metrics_logger_design.md#sentry-integration) section.

Also, Sentry uses source maps generated during the build to make errors more readable and clear. To ensure `flutter build` command generates source maps it is required to pass the `--source-maps` flag.

The following example demonstrates building the application with Sentry support:

```bash
flutter build web --release --source-maps --dart-define=FLUTTER_WEB_AUTO_DETECT=true --dart-define=SENTRY_DSN=<YOUR_SENTRY_DSN> --dart-define=SENTRY_RELEASE=<YOUR_SENTRY_RELEASE>
```

Then, using Sentry CLI one should update source maps as described in the [Updating Source Maps](https://github.com/platform-platform/monorepo/blob/master/metrics/web/docs/features/metrics_logger/01_metrics_logger_design.md#updating-source-maps) section of the Metrics Logger document.

Once you've built the application, you can proceed to deploying to the Firebase Hosting.

### Deploying Flutter application

You can deploy the built application to the Firebase Hosting using the `firebase` CLI. Consider the following steps:

1. Open the terminal and navigate to the `metrics/web` project folder.
2. Run `firebase login` command and follow the instructions to log in to the Firebase CLI with your Google account. Use the same account that you used to create your Firebase project (or the one that has access to it).
3. Run the `firebase use --add` command and select the ID of the project created in previous steps.
4. Run the `firebase target:apply hosting metrics <YOUR_HOSTING_NAME>` to specify the hosting deploy to. You can find the `<YOUR_HOSTING_NAME>` within the `Hosting` section in the Firebase console.
5. Run the `firebase deploy --only hosting:metrics` command to deploy the application to the Firebase Hosting.

_**Note:** If you've already had the configured hosting deployment target you should run the `firebase target:clear hosting metrics` before the 4th step._

When the deployment process is finished, the application is accessible by the `Hosting URL` printed to the console.

## Configuring Firestore database

Once you've deployed the metrics application to Firebase Hosting, you should finish configuring your Firestore database.
The `metrics/firebase` folder contains Firestore security rules, Firestore indexes, and a `seedData` Cloud function needed to create a test data for our application. To deploy all of these components, follow the next steps:

1. Activate the `seedData` function: go to the `metrics/firebase/functions/index.js` file and change the `const inactive = true;` to `const inactive = false;`.
2. Install ESLint `npm install -g eslint`.
3. Open the terminal, navigate to `metrics/firebase` folder and ensure all dependencies are installed by running: `npm install`. There are [known issues](https://stackoverflow.com/questions/64437656/gcp-cloud-function-error-fetching-storage-source-during-build-deploy) regarding deploying Cloud Functions using Node 15.6.x.
4. Run the `firebase use --add` command and select current project ID.
5. Run the `firebase deploy` command to deploy all components.
6. Once command execution finished, you'll find the `seedData` function URL, that can be used to trigger function execution in the console. Save this URL somewhere - you will need it a bit later.

Now you can create test projects in your Firestore database:

1. Go to the [Firebase Console](https://console.firebase.google.com/) and select the project, created in previous steps.
2. Go to the `Cloud Firestore` section on the left panel and tap on the `Start collection` button.
3. Add collection with `projects` identifier and tap `Next`.
4. In the document creation window tap on the `Auto-ID` button or enter the project identifier you want.
5. Add a field named `name` with the `String` type and the name for your project as a value.

So, you've created the test projects in the database. It is time to generate test builds. In the previous steps you've got the `seedData` function URL. Now you can trigger this function to create builds for the project, using this URL. This HTTP function has the following query parameters:
  - buildsCount (required) - the number of builds to generate.
  - projectId (required) - the project identifier for which builds will be generated.
  - startDate (optional) - builds will be generated with 'startedAt'
      property in the range from the `startDate` to `startDate - 7` days. Defaults to the current date.
  - delay (optional) - is the delay in milliseconds between adding builds to the project.

Once you've finished creating test data, you should deactivate the `seedData` cloud function. To deactivate this function, follow the next steps:

1. Go to the `metrics/firebase/functions/index.js` file and change the `inactive` constant back to `true`.
2. Redeploy this function, using the `firebase deploy --only functions` command.

To validate user's email domain when they sign in with Google, the application uses the `validateEmailDomain` cloud function deployed previously. If user signs in using the email and password method then no domain validation happens. To enable this validation, you should enable the `validateEmailDomain` for all users. Consider the following steps:

1. Open the [Google Cloud Platform](https://console.cloud.google.com/home/dashboard) and select your project in the top left corner.
2. Open the side menu and go to the `Cloud Functions` section.
3. Find the `validateEmailDomain` function and check its checkbox.
4. Tap the `SHOW INFO PANEL` button on the right top corner under your avatar if this panel is not opened.
5. In the info panel, select the `PERMISSIONS` tab and click an `ADD MEMBER` button.
6. In the opened menu, type `allUsers` in the `New members` field and select a `Cloud Functions` -> `Cloud Functions Invoker` role.
7. Save the changes.

## Creating a new Firebase User

Once you've finished deploying the Metrics application and created the test data, you probably want to open the application and ensure it works well, so you need to create a Firebase User to log-in to the application:

1. Go to the [Firebase Console](https://console.firebase.google.com/) and select the project, created in the previous steps.
2. Go to the `Authentication` section on the left panel and tap on the `Add user` button.
3. Provide an email and a password to create a new user and type on the `Add user` button again.
4. You should see your email with additional data appear in the list of the users' table.

With that in place, you can use your credentials, that you've used to create the user, to fill an authentication form of the web application.

After logging in, you should see a dashboard page with a list of test projects and their metrics if you've created them in the previous steps or no data. The app should provide an ability to switch between light/dark themes.

# Dependencies

> What is the project blocked on?

No blockers.

> What will be impacted by the project?

All the deployment process for a flutter web application(s) within the Metrics project will be impacted.

# Testing

> How will the project be tested?

This project will be tested manually by opening an application using the obtained link.

# Alternatives Considered

> Summarize alternative designs (pros & cons)

No alternatives considered.

# Timeline

> Document milestones and deadlines.

DONE:

- Deploy Metrics application to Firebase Hosting.
- Deploy the Cloud Function for creating test data.
- Deploy Firestore Security Rules & Indexes.

# Results

> What was the outcome of the project?

The Metrics application and the Cloud Function for creating test data are deployed and available via the links.
