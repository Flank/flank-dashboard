// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

// ignore_for_file: public_member_api_docs

/// A class that holds the strings for the Sentry prompts.
class SentryStrings {
  static const String enterReleaseName = '''
The last thing required for the Sentry configuration is a release name. The Sentry web page will display the entered release name in the issues tags.
While creating a release name, consider it cannot:  
- contain newlines, tabulator characters, forward slashes(/), or back slashes(\\);
- be (in their entirety) period (.), double period (..), or space ( );
- exceed 200 characters.
Please enter your Sentry release name:''';

  static const String enterOrganizationSlug = '''
The following steps help to find an 'Organization Slug' for the Sentry account:
1. Visit the following link and authorize: https://sentry.io.
2. Navigate to the Sentry's 'Settings' tab.
3. Navigate to the 'General Settings' tab and copy an 'Organization Slug'.
Paste the 'Organization Slug' here:''';

  static String enterProjectSlug(String organizationSlug) => '''
The following steps help to find a 'Project Slug' for the Sentry account:
1. Visit the following link: https://sentry.io/settings/$organizationSlug/projects/.
2. Select a required project and copy a project name.
The project name equals to its slug, so paste it here:''';

  static String enterDsn(String organizationSlug, String projectSlug) => '''
The following steps help to find a 'DSN' for the Sentry account:
1. Visit the following link: https://sentry.io/settings/$organizationSlug/projects/$projectSlug/keys/.
2. Copy your 'DSN'.
Paste the 'DSN' here:''';
}
