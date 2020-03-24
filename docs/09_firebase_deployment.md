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

The Metrics application instance with test data accessible via a link.

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

> Identify risks and edge cases

# API

> What will the proposed API look like?


## Before you begin

Before you start, you should have the following installed:

1. [Flutter](https://flutter.dev/docs/get-started/install) v1.15.3.
2. [npm](https://www.npmjs.com/get-npm).

## Creating a new Firebase project.

1. Go to [Firebase Console](https://console.firebase.google.com/), login if needed, and tap the `Add project` button.
2. Enter a project name and tap the `Continue` to proceed.
3. On the next page, select whether you want to use Firebase Analytics or not and click the `Continue`/`Create project` to proceed.
4. Select a Firebase Analytics account if you are using one and tap the `Create project`.  

After a couple of seconds, your project will be ready, and you'll be redirected to the project console.  
Your next step will be to create a Firestore database: 

1. Go to the `Database` tab on the left bar and click the `Create database` button under the `Cloud Firestore`. 
2. Select `Start in test mode` to create a database with no security rules for now and tap `Next`.
3. Select your database location and click `Done`.

After a while, your database will be created, and you will see the database console page.

## Firebase configuration

When your Firestore database is up, you need to add a Web application to your Firebase project,
to be able to connect your web application with the Firestore database: 

1. In the [Firebase Console](https://console.firebase.google.com/), open your project and go to
 the project setting page (tap on the setting gear icon near the `Project Overview` on top of the 
 left panel and select `Project settings`).
2. Scroll down and find `There are no apps in your project` text,
 and tap on the `</>` icon to add a new Web application to your Firebase project.
3. Choose the app nickname and check `Also set up Firebase Hosting for this app`.
4. Select from the dropdown menu, or create a new site for your application and tap the `Register app` to proceed.
5. Skip the `Configure Firebase SDK` step. We will return to Firebase SDK configuration a bit later in [Firebase SDK configuration](#Firebase-SKD-configuration).
6. Tap on the `Next` button and follow instructions to install the Firebase CLI.
7. Skip the `Deploy to Firebase Hosting` and tap on the `Continue to console` to finish configuring your Firebase Web application.
 The deployment process described more detailed in
  [Building and deploying the application to the Firebase Hosting](#Building-and-deploying-the-application-to-the-Firebase-Hosting) section.
 
Finally, your Firebase project configured ant it's time to configure the Firebase SDK in your Flutter for Web application.

## Firebase SKD configuration

To configure the Flutter for Web application to use recently created Firestore Database follow the next steps: 

1. Open the [Firebase console](https://console.firebase.google.com/), choose your project 
and go to the project setting (tap on the setting gear icon near the `Project Overview` on top of the left panel and select `Project settings`.
2. Scroll down and find your Firebase Web Application. 
3. Go to `Firebase SDK snippet` of your application, select `Config` and copy the generated code.
4. Go to the `web/index.js` file in the application directory and replace this piece of code with the copied one in step 3: 
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
 
## Building and deploying the application to the Firebase Hosting

### Preparing your environment 
Before deploying metrics application, make sure you have the correct Flutter version installed,
 by running the `flutter --version` command. You should have `v1.15.3` installed. 

To switch the Flutter to the required version, you should run the `flutter version 1.15.3` command.

Also, you should enable flutter web support by running the `flutter config --enable-web` command.

### Building and deploying Flutter application
 
1. Open the terminal and navigate to the metrics project folder.
2. Run `firebase login` command and follow the instructions to log in to the Firebase CLI with your Google account.
 Use the same account that you used to create your Firebase project (or the one that has access to it).
3. After you have logged in, run the `firebase use --add` command, and select the project id of the project, created in previous steps.
4. Give an alias to your project.
5. Run the `flutter build web` command from the root of the metrics project to build the release version of the application.
 It is recommended to add `--dart-define=FLUTTER_WEB_USE_SKIA=true` parameter to build the application with the `SKIA` renderer.
4. Run the `firebase deploy --only hosting` command to deploy an application to the Firebase Hosting.

After the deployment process finished, your application will be accessible using the `Hosting URL`, printed to console.

## Creating test data for the deployed application

Once you've deployed the metrics application to Firebase Hosting, you can create a sample data to test the application.  
The application reads data from 2 Firestore collections: `projects` and `build`. To create a sample data follow the next steps: 

1. Deploying the `seedData` cloud function: 
    1. Go to the `metrics/firebase/index.js` file and comment this line of code: `return resp.status(200).send('done');`.
    2. Open console, navigate to `metrics` directory and run the `firebase deploy --only functions`
     command to deploy this cloud function.
    3. Once the function deployment is finished, the URL will be printed to the console.
     You can trigger this function to create builds from the project, using this URL.  
     This HTTP function has the following query parameters: 
        - buildsCount (required) - the number of builds to generate.
        - projectId (required) - the project identifier for which builds will be generated.
        - startDate (optional) - builds will be generated with 'startedAt'
         property in the range from the `startDate` to `startDate - 7` days. Defaults to the current date.
        - delay (optional) - is the delay in milliseconds between adding builds to the project.

2. Creating projects in Firestore Database:
    1. Go to [Firebase Console](https://console.firebase.google.com/), and select the project, created in previous steps.
    2. Go to the database section on the left panel and tap on the `Start collection` button.
    3. Add collection with `projects` identifier and tap `Next`. 
    4. In the document creation window tap on the `Auto-ID` button or enter the project identifier you want.
    5. Add a field named `name` with the `String` type and the name for your project as a value.

# Dependencies

> What is the project blocked on?

No blockers

> What will be impacted by the project?

Nothing will be impacted by this project.

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
  
# Results

> What was the outcome of the project?

The Metrics application and the Cloud Function for creating test data are deployed and available via the links.
