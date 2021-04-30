// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

// ignore_for_file: public_member_api_docs

/// A class that holds the strings for the GCloud prompts.
class GCloudStrings {
  static const String enterRegionName =
      'Please enter the region name that suits you best:';

  static const String acceptTerms = '''
If you have already accepted the terms of the GCloud service, skip this step otherwise, follow the steps below to accept them:  
  
1. Follow the link https://console.cloud.google.com/.
2. A welcome popup should appears.
3. Select your country.
4. Accept the GCloud terms of service.
5. Press a 'AGREE AND CONTINUE' button.
Once you are done, press any key to continue:''';

  static String configureOAuth(String projectId) => '''
Use the following link for the correct work of the Metrics project: https://$projectId.firebaseapp.com. 

If you are going to use any other domains to run the Metrics project, you should configure the OAuth 2.0 for them by following the steps listed below:

1. Follow the link https://console.cloud.google.com/apis/credentials?project=$projectId/
2. Press the 'Web client (auto created by Google Service)' name in the 'OAuth 2.0 Client IDs' section.
3. Press the 'ADD URI' button at the end of the 'Authorized JavaScript origins' section.
4. Enter the required domain.
5. Press the 'SAVE' button at the bottom of the web page.
''';
}
