// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

// ignore_for_file: public_member_api_docs

/// A class that holds the strings for the GCloud prompts.
class GcloudStrings {
  static const String enterRegionName =
      'Please enter the region name that suits you best:';
  static const String acceptTerms = '''
If you have already accepted the terms of the GCloud service, skip this step, otherwise please accept them, consider the following:
  
1. Follow the link https://console.cloud.google.com/.
2. A welcome popup should appear.
3. Select your country.
4. Accept the Gcloud terms of service.
5. Press a 'AGREE AND CONTINUE' button.

Once you are done, press any key to continue:''';
}
