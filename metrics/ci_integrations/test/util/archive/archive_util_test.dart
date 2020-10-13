import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:ci_integration/util/archive/archive_util.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'zip_decoder_mock.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("ArchiveUtil", () {
    final zipDecoderMock = ZipDecoderMock();

    final fileBytes = Uint8List.fromList([1, 2, 3, 4]);
    final archiveFile = ArchiveFile('test', 10, fileBytes);

    final archiveBytes = Uint8List.fromList([5, 6, 7, 8]);
    final archive = Archive();
    archive.files = [archiveFile];

    tearDown(() {
      reset(zipDecoderMock);
    });

    test(
      "throws an ArgumentError if the given zip decoder is null",
      () {
        expect(() => ArchiveUtil(null), throwsArgumentError);
      },
    );

    test(
      "creates an instance with the given zip decoder",
      () {
        final util = ArchiveUtil(zipDecoderMock);

        expect(util.zipDecoder, equals(zipDecoderMock));
      },
    );

    test(
      ".decodeArchive() returns a decoded archive",
      () {
        final util = ArchiveUtil(zipDecoderMock);

        when(zipDecoderMock.decodeBytes(archiveBytes)).thenReturn(archive);

        final actualArchive = util.decodeArchive(archiveBytes);

        expect(actualArchive, equals(archive));
      },
    );

    test(
      ".getFile() returns an archive file if the given archive contains a file with the specified filename",
      () {
        final util = ArchiveUtil(zipDecoderMock);

        final file = util.getFile(archive, 'test');

        expect(file, equals(archiveFile));
      },
    );

    test(
      ".getFile() returns null if the given archive does not contain a file with the specified filename",
      () {
        final util = ArchiveUtil(zipDecoderMock);

        final file = util.getFile(archive, 'not specified');

        expect(file, isNull);
      },
    );
  });
}
