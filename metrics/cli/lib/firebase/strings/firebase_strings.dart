// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

// ignore_for_file: public_member_api_docs

/// A class that holds the strings for the Firebase prompts.
class FirebaseStrings {
  static const String acceptTerms = '''
If you have already accepted the terms of the Firebase service, skip this step. Otherwise, follow the steps below to accept the terms:

1. Follow the link and click the 'Create a project' button: https://console.firebase.google.com/.
   NOTE: Make sure you are using the same account used to authenticate with the Firebase CLI on the previous steps.
2. Enter any project name.
3. Accept the Firebase terms of service.
4. Press the 'Continue' button.
5. Disable Google Analytics for the project.
6. Press the 'Create project' button.

Once you are done, press the ENTER to continue:''';

  static String upgradeBillingPlan(String projectId) => '''
The Metrics app uses Firebase features not available in the Spark plan, such as Firebase Functions. 
Thus, a Blaze plan is required for the Metrics app to function properly.

To configure the Blaze billing plan for the Firebase project, consider the following steps:

1. Follow the link and press the 'Continue' button in the open modal window: https://console.firebase.google.com/project/$projectId/overview?purchaseBillingPlan=metered&billingContext=pricingBuyFlow.
2. Select your country and press the 'Confirm'.
3. Enter your customer info, choose the payment method, and press the 'Confirm Purchase'.

Consider the following link to find out more about Firebase plans' pricing: https://firebase.google.com/pricing.

Press the ENTER to continue once the billing plan configured:''';

  static String initializeData(String projectId) => '''
To initialize Firestore data for the currently deploying project, consider the following steps:

1. Follow the link to open the Firestore database: https://console.firebase.google.com/project/$projectId/firestore.
2. Create a collection with the 'allowed_email_domains' identifier.
3. Create document(s) with the domain identifier(s) as the document ID(s) you want to allow to be used for the Google Sign In.
4. Create a collection with the 'feature_config' identifier.
5. Create a document with the 'feature_config' identifier.
6. Add the following boolean fields to the 'feature_config' document:
   - 'isDebugMenuEnabled' - indicates whether the Debug Menu feature is enabled;
   - 'isPasswordSignInOptionEnabled' - indicates whether the Email and Password sign-in option is enabled.

To get more info about creating the 'allowed_email_domains' collection, see the following document: 
https://github.com/platform-platform/monorepo/blob/master/docs/08_firebase_deployment.md#google-sign-in-allowed-domains-configuration.

Consider the following link for a detailed structure of the 'feature_config' collection:
https://github.com/platform-platform/monorepo/blob/master/docs/18_security_audit_document.md#the-feature_config-collection.

Press the ENTER to continue when you finish with the Firestore database initialization:''';

  static String configureAuthProviders(String projectId) => '''
To enable the Firebase Auth for the Metrics Web application, consider the following steps:

1. Follow the link and click the 'Get started' button: https://console.firebase.google.com/project/$projectId/authentication.
2. Navigate to the 'Sign-in method' tab on the Firebase auth page or use the following link: https://console.firebase.google.com/project/$projectId/authentication/providers.
3. Enable an Email/Password provider by clicking on the provider name and toggling the 'Enable' switch.
4. Enable a Google provider by clicking on the provider name and toggling the 'Enable' switch.
5. On the 'Google' provider popup, open the 'Web SDK configuration' tab, copy the 'Web client ID' and paste it to the console.
Paste your Web client Id here:''';

  static String enableAnalytics(String projectId) => '''
To enable Firebase analytics for the currently deploying project, follow the next steps:

1. Follow the link and click the 'Enable' button on the Google Analytics card: https://console.firebase.google.com/project/$projectId/settings/integrations/analytics.
2. Configure the Google Analytics account:
   If you've ever configured the Firebase Analytics on your Google Account, choose an existing Google Analytics account from the dropdown.

   If you've never configured the Firebase Analytics on your Google Account or you want to create a new one, use the following steps to configure it:
  
   2.1. Choose the location from the `Analytics location` dropdown.
   2.2. Accept the Google Analytics Terms.
3. Click the 'Enable Google Analytics' button.
4. Click the 'Finish' button on the `Add the Google Analytics SDK` page.

Once you are done, press the ENTER to continue:''';
}
