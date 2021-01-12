# Metrics firebase deployment with CLI


## Before you begin

Before you start, you should have the following installed:

1. [Flutter](https://flutter.dev/docs/get-started/install) v1.24.0-10.2.pre.
2. [npm](https://www.npmjs.com/get-npm).
3. [Google Cloud SDK ](https://cloud.google.com/sdk/docs)
4. [Firebase CLI](https://firebase.google.com/docs/cli)

## Creating a new Firebase project.

1. Login to your Google account.

```
gcloud auth login
```

2. List avaiable organisations.

```
gcloud organizations list
```

3. Create new Google Cloud project.

```
gcloud projects create $PROJECT_ID --organization $GCLOUD_ORGANIZATION_ID
```

4. Set gcloud config to point to new project.

```
gcloud config set project $PROJECT_ID
```

5. Add Firebase capabilities to project.

```
firebase projects:addfirebase --project $PROJECT_ID
```

6. Add project app needed to create firestore database.

```
gcloud app create --region=europe-west --project $PROJECT_ID
```

7. Create database

```
gcloud alpha firestore databases create --region=europe-west --project $PROJECT_ID --quiet
```

8. Create web app

```
firebase apps:create --project $PROJECT_ID
```

9. Export firebase config APP_ID will be displayed as output of previouse command.

```
firebase apps:sdkconfig WEB $APP_ID
```

## Firebase SDK configuration

1. Go to the `web/index.html` file in the application directory.
5. You have two options for how to set up the Flutter configuration for Web application:
  
  - If you want to use the `auto-generated` Firebase configuration add the following script below the previously loaded Firebase SDKs:
  ```
  <script src="/__/firebase/init.js"></script>
  ```
  With this setup option, after you deploy to Firebase, your app automatically pulls the Firebase configuration object from the Firebase project to which you've deployed.

  - If you want to `manually` define a configuration, replace the `init.js` script with the following:

```
// Firebase project configuration, copied one in step 9
const firebaseConfig = {
  // ...
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);
```

Finally, you have a configured Flutter application that works with your Firebase instance.
It's time to deploy your Flutter application to the Firebase Hosting!
 
## Building and deploying the application to the Firebase Hosting

### Preparing your environment 
Before building and deploying Metrics application, make sure you have the correct Flutter version installed. 
The required version of Flutter is `v1.24.0-10.2.pre`. 
The following command prints the current Flutter version on your machine:

```
flutter --version
```

If current version differs from the required one you can change it by running the following commands:

```
cd $(which flutter | xargs dirname) && git checkout 1.24.0-10.2.pre
```
_**Note:** The above commands works correctly on Unix based operating systems (verified: macOS and Ubuntu)! Before using, consider rewriting it according to your operating system._

Also, you should enable Flutter Web support by running the command below:

```
flutter config --enable-web
```

### Building and deploying Flutter application
 
1. Open the terminal and navigate to the metrics project folder.
2. Run  command and follow the instructions to log in to the Firebase CLI with your Google account.
 Use the same account that you used to create your Firebase project (or the one that has access to it).

```
firebase login
```
3. After you have logged in, run the  command below and select the project id of the project, created in previous steps.

```
firebase use --add
```
4. Give an alias to your project.
5. Run the  command from the root of the metrics project to build the release version of the application.
   It is recommended to add `--dart-define=FLUTTER_WEB_USE_SKIA=true` parameter to build the application with the `SKIA` renderer.
```
flutter build web --dart-define=FLUTTER_WEB_USE_SKIA=true
```

6. Run the  command to deploy an application to the Firebase Hosting.

```
firebase deploy --only hosting
```

After the deployment process finished, your application will be accessible using the `Hosting URL`, printed to console.

## Configuring Firestore database

Once you've deployed the metrics application to Firebase Hosting, you should finish configuring your Firestore database. 
The `metrics/firebase` folder contains Firestore security rules, Firestore indexes, and a `seedData` Cloud function needed to create a test data for our application. To deploy all of these components, follow the next steps: 

1. Activate the `seedData` function: go to the `metrics/firebase/functions/index.js` file and change the `const inactive = true;` to `const inactive = false;`.
2. 0pen the terminal, navigate to `metrics/firebase` folder and ensure all dependencies are installed by running: 
```
npm install
```

3. Run the  command to deploy all components.

```
firebase deploy
```
4. Once command execution finished, you'll find the `seedData` function URL, that can be used to trigger function execution in the console. Save this URL somewhere - you will need it a bit later.

Now you can create test projects in your Firestore database: 

1. List service accounst 

```
gcloud iam service-accounts list
```
3. Generate key if you don't have one already 
```
gcloud iam service-accounts keys create ~/key.json --iam-account $SERVICE_ACCOUNT_EMAIL
```
4. Set env variable SERVICE_ACCOUNT_KEY_PATH to point to your key

```
export SERVICE_ACCOUNT_KEY_PATH=~/key.json
```

2. Run import script

```
npm run seed
``` 

So, you've created the test projects in the database. It is time to generate test builds. In the previous steps you've got the `seedData` function URL. Now you can trigger this function to create builds for the project, using this URL. This HTTP function has the following query parameters:
  - buildsCount (required) - the number of builds to generate.
  - projectId (required) - the project identifier for which builds will be generated.
  - startDate (optional) - builds will be generated with 'startedAt'
      property in the range from the `startDate` to `startDate - 7` days. Defaults to the current date.
  - delay (optional) - is the delay in milliseconds between adding builds to the project.


Once you've finished creating test data, you should deactivate the `seedData` cloud function. To deactivate this function, follow the next steps:

1. Go to the `metrics/firebase/functions/index.js` file and change the `inactive` constant back to `true`.
2. Redeploy this function, using the command.
```
firebase deploy --only functions
```

## Creating a new Firebase User

Once you've finished deploying the Metrics application and created the test data, you probably want to open the application and ensure it works well, so you need to create a Firebase User to log-in to the application:

1. Go to the [Firebase Console](https://console.firebase.google.com/) and select the project, created in the previous steps.
2. Go to the `Authentication` section on the left panel and tap on the `Add user` button.
3. Provide an email and a password to create a new user and type on the `Add user` button again.
4. You should see your email with additional data appear in the list of the users' table.

With that in place, you can use your credentials, that you've used to create the user, to fill an authentication form of the web application. 

After logging in, you should see a dashboard page with a list of test projects and their metrics if you've created them in the previous steps or no data. The app should provide an ability to switch between light/dark themes.

## Delete

to delete project run:

```
gcloud projects delete $PROJECT_ID
```
