import 'dart:async';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:process_run/which.dart';

import '../../util/file_utils.dart';

/// An abstract class that represents the web driver.
abstract class WebDriver {
  /// An executable name of this web driver.
  String get executableName;

  /// A URL used to download this web driver.
  FutureOr<String> get downloadUrl;

  /// A version of this web driver.
  String get version;

  /// Decodes the archive file specified as a [filePath].
  Archive decodeArchive(String filePath);

  /// Check if the web driver file exists in [workingDir]
  /// or the web driver is global-accessible.
  /// If not - downloads the web driver and makes it executable.
  Future<void> prepare(String workingDir) async {
    final webDriverFilePath = "$workingDir/$executableName";
    final webDriverFile = File(webDriverFilePath);
    final globalChromedriver = whichSync(executableName);

    if (!webDriverFile.existsSync() && globalChromedriver == null) {
      await FileUtils.download(
        await downloadUrl,
        webDriverFilePath,
      );

      final decodedArchive = decodeArchive(webDriverFilePath);

      FileUtils.extractFromArchive(decodedArchive, workingDir);

      await Process.run('chmod', ['a+x', webDriverFilePath]);
    }
  }
}
