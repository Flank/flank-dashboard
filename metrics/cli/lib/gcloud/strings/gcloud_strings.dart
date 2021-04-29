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

  static String configureOauth(String projectId) => '''
Use the following link for correct work of the Metrics project: https://$projectId.firebaseapp.com. 

If you are going to use the "https://$projectId.web.app" reference, you need to configure OAuth 2.0 following the steps below:

1. Follow the link https://console.cloud.google.com/apis/credentials?project=$projectId/
2. Open the 'Web client (auto created by Google Service)' OAuth 2.0 Client ID.
3.Press a 'ADD URI' button under the Authorized JavaScript origins section.
4. Paste the 'https://$projectId.web.app' to the URI.
5. Press a 'SAVE' button.
''';
}
