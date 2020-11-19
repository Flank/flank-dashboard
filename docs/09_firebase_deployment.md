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

1. [Flutter](https://flutter.dev/docs/get-started/install) v1.22.0-12.1.pre.
2. [npm](https://www.npmjs.com/get-npm).

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
2. Scroll down and find `There are no apps in your project` text,
 and tap on the `</>` icon to add a new Web application to your Firebase project.
3. Enter the app nickname and make sure that `Also set up Firebase Hosting for this app` is checked.
4. Select from the dropdown menu, or create a new site for your application and tap the `Register app` to proceed.
5. Skip the `Configure Firebase SDK` step. We will return to Firebase SDK configuration a bit later in [Firebase SDK configuration](#Firebase-SDK-configuration).
6. Tap on the `Next` button and follow instructions to install the Firebase CLI.
7. Skip the `Deploy to Firebase Hosting` and tap on the `Continue to console` to finish configuring your Firebase Web application.
 The deployment process described more detailed in
  [Building and deploying the application to the Firebase Hosting](#Building-and-deploying-the-application-to-the-Firebase-Hosting) section.

Finally, your Firebase project configured and it's time to configure the Firebase SDK in your Flutter for the Web application.

## Firebase SDK configuration

To configure the Flutter for Web application to use recently created Firestore Database follow the next steps:

1. Open the [Firebase console](https://console.firebase.google.com/), choose your project
and go to the project setting (tap on the setting gear icon near the `Project Overview` on top of the left panel and select `Project settings`.
2. Scroll down and find your Firebase Web Application.
3. Go to `Firebase SDK snippet` of your application, select `Config` and copy the generated code.
4. Go to the `web/index.html` file in the application directory and replace the following piece of code with the copied one in step 3:
    ```
        var firebaseConfig = {
          apiKey: "AIzaSyCkM-7WEAb9GGCjKQNChi5MD2pqrcRanzo",
          authDomain: "metrics-d9c67.firebaseapp.com",
          databaseURL: "https://metrics-d9c67.firebaseio.com",
          projectId: "metrics-d9c67",
          storageBucket: "metrics-d9c67.appspot.com",
          messagingSenderId: "650500796855",
          appId: "1:650500796855:web:65a4615a28f3d88e8bb832",
          measurementId: "G-3DB4JFLKHQ"
        };
    ```

Finally, you have a configured Flutter application that works with your Firebase instance.
It's time to deploy your Flutter application to the Firebase Hosting!

## Firebase Google Sign-In configuration

To allow users sign-in using Google, please follow the next steps:

1. Open the [Firebase console](https://console.firebase.google.com/), choose your project
2. Navigate to `Authentication` -> `Sign-in method`.
3. Enable `Google`.
4. Expand `Web SDK Configuration` and copy `Web client ID`, then press `Save`.
5. Open `web/index.html` and replace `content` of `meta` tag with `name = "google-signin-client_id"` with the value from clipboard.

Once you've done, you should add an allowed URLs to the Authorized JavaScript origins to be able to use the Google Sign-in from these origins. So, to do that, you should: 

1. Open the [Google Cloud Platform](https://console.cloud.google.com/home/dashboard) and select your project in the top left corner.
2. Open the side menu and go to the `APIs & Services` section.
3. Go to the `Credentials` section, find the `Web client` in `OAuth 2.0 Client IDs` section and open it.
4. Then you should find the `Authorized JavaScript origins` section. That is the place where you can add any URL origins that will have access to the google sign.

## Firebase Key Restrictions

To enable Firebase key restrictions, follow the next steps:

1. Open the [Google Cloud Platform](https://console.cloud.google.com/home/dashboard) and select your project in the top left corner.
2. Open the side menu and go to the `APIs & Services` section.
3. Go to the `Credentials` section, find the `Browser Key` in `API Keys` section and open it.
4. Scroll down to the `API Restrictions` section and click `Restrict key` button.
5. In the displayed dropdown enable the following APIs:
    - Google Identity Toolkit API
    - The Token Service API
    - Cloud Functions API
    - Firestore API
    - Firebase Installations API
    - Cloud Logging API
6. Click `Save` button.

## Building and deploying the application to the Firebase Hosting

### Preparing your environment
Before deploying metrics application, make sure you have the correct Flutter version installed,
 by running the `flutter --version` command. You should have `v1.22.0-12.1.pre` installed.
If the version is different you should run the `flutter version 1.22.0-12.1.pre` command.

Also, you should enable flutter web support by running the `flutter config --enable-web` command.

### Building and deploying Flutter application

1. Open the terminal and navigate to the metrics project folder.
2. Run `firebase login` command and follow the instructions to log in to the Firebase CLI with your Google account.
 Use the same account that you used to create your Firebase project (or the one that has access to it).
3. After you have logged in, run the `firebase use --add` command, and select the project id of the project, created in previous steps.
4. Give an alias to your project.
5. Run the `flutter build web` command from the root of the metrics project to build the release version of the application.
 It is recommended to add `--dart-define=FLUTTER_WEB_USE_SKIA=true` parameter to build the application with the `SKIA` renderer.
6. Run the `firebase deploy --only hosting` command to deploy an application to the Firebase Hosting.

After the deployment process finished, your application will be accessible using the `Hosting URL`, printed to console.

## Configuring Firestore database

Once you've deployed the metrics application to Firebase Hosting, you should finish configuring your Firestore database.
The `metrics/firebase` folder contains Firestore security rules, Firestore indexes, and a `seedData` Cloud function needed to create a test data for our application. To deploy all of these components, follow the next steps:

1. Activate the `seedData` function: go to the `metrics/firebase/functions/index.js` file and change the `const inactive = true;` to `const inactive = false;`.
2. 0pen the terminal, navigate to `metrics/firebase` folder and ensure all dependencies are installed by running: `npm install`.
3. Run the `firebase deploy` command to deploy all components.
4. Once command execution finished, you'll find the `seedData` function URL, that can be used to trigger function execution in the console. Save this URL somewhere - you will need it a bit later.

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

Also, to allow users to sign in with Google, you should enable the `validateEmailDomain` function for all users and configure the allowed user email domains within `Cloud Firestore`. 

To allow any user call the `validateEmailDomain` function deployed previously, you should follow the next steps: 

1. Open the [Google Cloud Platform](https://console.cloud.google.com/home/dashboard) and select your project in the top left corner.
2. Open the side menu and go to the `Cloud Functions` section.
3. Find the `validateEmailDomain` function and check its checkbox.
4. Tap the `SHOW INFO PANEL` button on the right top corner under your avatar if this panel is not opened.
5. In the info panel, select the `PERMISSIONS` tab and click an `ADD MEMBER` button.
6. In the opened menu, type `allUsers` in the `New members` field and select a `Cloud Functions` -> `Cloud Functions Invoker` role.
7. Save the changes.

Once you've finished with these steps, and the `validateEmailDomain` function available for all users, consider the following steps to configure allowed email domains: 

1. Go to the [Firebase Console](https://console.firebase.google.com/) and select the project, created in previous steps.
2. Open the `Cloud Firestore` section on the left panel.
3. Tap on the `Start collection` button, enter the `allowed_email_domains` as a collection ID, and tap the `Next` button.
4. After you tapped the `Next` button, you'll be asked to add a first document to your collection. This is the point where we start adding the allowed user email domains for our application. For example, we want to allow the `gmail.com` domain, so we should create an empty document with the `gmail.com` document ID.

To add more allowed email domains you should add a new document for each email domain with the domain itself as a document ID.

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
