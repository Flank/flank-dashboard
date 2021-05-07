// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

// ignore_for_file: public_member_api_docs

/// A class that holds the strings for the Firebase prompts.
class FirebaseStrings {
  static const String acceptTerms = '''
If you have already accepted the terms of the Firebase service, skip this step otherwise, follow the steps below to accept them:  

1. Follow the link and click a 'Create a project' button: https://console.firebase.google.com/.
2. Enter any project name.
3. Accept the Firebase terms of service.
4. Press a 'Continue' button.
5. Disable Google Analytics for the project.
6. Press a 'Create project' button.

Once you are done, press any key to continue:''';

  static String upgradeBillingPlan(String projectId) => '''
The Metrics app uses Firebase features not available in the Spark plan, such as Firebase Functions. 
Thus, a Blaze plan is required for the Metrics app to function properly.

To configure the Blaze billing plan for the Firebase project, consider the following steps:

1. Follow the link and press continue in the open modal window: https://console.firebase.google.com/project/$projectId/overview?purchaseBillingPlan=metered&billingContext=pricingBuyFlow.
2. Select your country and press 'Confirm'.
3. Enter your customer info, choose payment method and press 'Confirm Purchase'.

Consider the following link to find out more about Firebase plans' pricing: https://firebase.google.com/pricing.

Press any key to continue once the billing plan configured:''';

  static String initializeData(String projectId) => '''
To initialize Firestore data for the currently deploying project, consider the following steps:

1. Follow the link to open the Firestore database: https://console.firebase.google.com/project/$projectId/firestore.
2. Create a collection with the 'allowed_email_domains' identifier.
3. Create document(s) with the 'domain' identifier you want to allow access to the Metrics application without any fields.
4. Create a collection with the 'feature_config' identifier.
5. Create a document with the 'feature_config' identifier.
6. Add the following boolean fields to the 'feature_config' document:
   - 'isDebugMenuEnabled' - indicates whether the Debug Menu feature is enabled;
   - 'isPasswordSignInOptionEnabled' - indicates whether the Email and Password sign-in option is enabled.

To get more info about creating the 'allowed_email_domains' collection, see the following document: 
https://github.com/platform-platform/monorepo/blob/master/docs/08_firebase_deployment.md#google-sign-in-allowed-domains-configuration.

Consider the following link for a detailed structure of the 'feature_config' collection:
https://github.com/platform-platform/monorepo/blob/master/docs/18_security_audit_document.md#the-feature_config-collection.

Press any key to continue when you finish with the Firestore database initialization:''';

  static String configureAuthProviders(String projectId) => '''
To enable the Firebase Auth for the Metrics Web application, consider the following steps:

1. Follow the link and click a 'Get started' button: https://console.firebase.google.com/project/$projectId/authentication.
2. Navigate to the 'Sign-in method' tab on the Firebase auth page or use the following link: https://console.firebase.google.com/project/$projectId/authentication/providers.
3. Enable an Email/Password provider by clicking on provider name and toggling the 'Enable' switch.
4. Enable a Google provider by clicking on provider name and toggling the 'Enable' switch.
5. On the 'Google' provider popup, open the 'Web SDK configuration' tab, copy the 'Web client ID' and paste it to the console.
Paste your Web client Id here:''';

  static String enableAnalytics(String projectId) => '''
To enable Firebase analytics for the currently deploying project, follow the next steps:

1. Follow the link and click an 'Enable Google Analytics' button: https://console.firebase.google.com/project/$projectId/settings/integrations/analytics.

Once you are done, press any key to continue:''';
}
