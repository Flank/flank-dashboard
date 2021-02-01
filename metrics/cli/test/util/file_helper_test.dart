import 'dart:io';

import 'package:cli/util/file_helper.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_util/called_once_verification_result.dart';

void main() {
  group('FileHelper', () {
    test('.deleteDirectory() deletes a given directory', () {
      const fileHelper = FileHelper();
      final directoryMock = DirectoryMock();

      fileHelper.deleteDirectory(directoryMock);

      verify(fileHelper.deleteDirectory(directoryMock)).calledOnce();
    });
  });
}

class DirectoryMock extends Mock implements Directory {}
