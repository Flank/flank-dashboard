// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:ci_integration/util/archive/archive_helper.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ArchiveHelper", () {
    final zipDecoderMock = _ZipDecoderMock();
    final archiveHelper = ArchiveHelper(zipDecoderMock);

    final archiveBytes = Uint8List.fromList([5, 6, 7, 8]);
    final archive = Archive();
    final fileBytes = Uint8List.fromList([1, 2, 3, 4]);
    archive.files = [ArchiveFile('test', 10, fileBytes)];

    tearDown(() {
      reset(zipDecoderMock);
    });

    test(
      "throws an ArgumentError if the given zip decoder is null",
      () {
        expect(() => ArchiveHelper(null), throwsArgumentError);
      },
    );

    test(
      "creates an instance with the given zip decoder",
      () {
        final helper = ArchiveHelper(zipDecoderMock);

        expect(helper.zipDecoder, equals(zipDecoderMock));
      },
    );

    test(
      ".decodeArchive() returns a decoded archive",
      () {
        when(zipDecoderMock.decodeBytes(archiveBytes)).thenReturn(archive);

        final actualArchive = archiveHelper.decodeArchive(archiveBytes);

        expect(actualArchive, equals(archive));
      },
    );

    test(
      ".getFileContent() returns content bytes of a file with the specified filename",
      () {
        final bytes = archiveHelper.getFileContent(archive, 'test');

        expect(bytes, equals(fileBytes));
      },
    );

    test(
      ".getFileContent() returns null if the given archive does not contain a file with the specified filename",
      () {
        final bytes = archiveHelper.getFileContent(archive, 'not specified');

        expect(bytes, isNull);
      },
    );
  });
}

class _ZipDecoderMock extends Mock implements ZipDecoder {}
