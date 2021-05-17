// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

// ignore_for_file: public_member_api_docs

/// A class that holds the strings for the GCloud prompts.
class GCloudStrings {
  static const String enterRegionName = '''
Please, choose the region name that suits you best. Note that the region cannot be changed after project creation.

Enter the region to create a project:''';

  static const String acceptTerms = '''
If you have already accepted the terms of the GCloud service, skip this step. Otherwise, follow the steps below to accept the terms: 
  
1. Follow the link https://console.cloud.google.com/.
   NOTE: Make sure you are using the same account used to authenticate with the Google Cloud SDK on the previous steps.
2. A welcome popup should appear.
3. Select your country.
4. Accept the GCloud terms of service.
5. Press the 'AGREE AND CONTINUE' button.

Once you are done, press the ENTER to continue:''';

  static String configureOAuth(String projectId) => '''
The Metrics Web application deployed successfully! Use the following link for the correct work of the Metrics project: https://$projectId.firebaseapp.com. 

If you are going to use any other domains to access the Metrics Web application, you should configure the OAuth 2.0 for these domains by following the steps listed below:

1. Follow the link https://console.cloud.google.com/apis/credentials?project=$projectId/
2. Press the 'Web client (auto created by Google Service)' name in the 'OAuth 2.0 Client IDs' section.
3. Press the 'ADD URI' button at the end of the 'Authorized JavaScript origins' section.
4. Enter the domain you want to use to access the Metrics Web application.
5. Press the 'SAVE' button at the bottom of the web page.''';

  static String configureProjectOrganization(String projectId) => '''
The $projectId GCloud project has been created successfully! 
If you want to configure the organization for the $projectId project, use the following guide https://cloud.google.com/resource-manager/docs/project-migration.

Once you are done, press the ENTER to continue:''';
}
