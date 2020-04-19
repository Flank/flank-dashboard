# Flutter/Dart ecosystem overview

Overall Flutter/Dart has a great ecosystem, support from Google and most importantly great community. Working with Flutter/Dart is fun due to ‘Hot-reload’, 1 language for all & great cross-compatibility that is growing (mobile, web, cli, server, dart->js). Recent improvements with SKIA based rendered for Flutter for Web are truly awesome.


| Growth Area | Description |
| --- | --- |
Code coverage collection reliability | For us it’s important that we can track code coverage to get a sense of what parts of the our code base is not covered with tests: [flutter/flutter#46868](https://github.com/flutter/flutter/issues/46868) [dart-lang/sdk#38934](https://github.com/dart-lang/sdk/issues/38934)
Support Flutter Driver on Firebase Test Lab | Making reliable software and having the ability to have all the tools to support it
Ability to write Firebase cloud functions using Dart | As Flutter/Dart gives great code-reuse capabilities Dart support for Firebase cloud functions is important as Firebase is becoming the go-to solution for mobile/web app development.
Ability to do query based updates in Firebase | It’s hard to manipulate large amounts of data in Firebase so it’s important to provide an ability to do an update like queries so clients don’t have to load all the data before manipulating it
Firestore client libraries should return DateTime rather than Timestamp | While client libraries accept DateTime as a parameter to save data to the Firestore, they return custom Timestamp object that sometimes hard to integrate into cross-platform apps (CLI & Flutter)
Improve Enum support | In some cases, we would love to see improved enums [dart-lang/language#158](https://github.com/dart-lang/language/issues/158) as while we port code from other languages to dart or trying to implement more consistent string enums we unnecessary spend time on it
CanvasKit (SKIA) rendering issues | It’s important to make sure that everything renders great on the Web - but with recent changes, it looks like we have all we need, so Thanks for the Team. We’ll let know if we find anything
Tooling improvements | Even paid tools are not great now - so we had to add very basic functionality ourselves: [JetBrains/intellij-plugins#767](https://github.com/JetBrains/intellij-plugins/pull/767) - it would be great if this could be improved
