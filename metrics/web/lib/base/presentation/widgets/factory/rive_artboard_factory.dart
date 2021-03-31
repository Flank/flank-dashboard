// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

/// A factory class that provides a method for creating an instance of the
/// [Artboard].
class RiveArtboardFactory {
  /// An [AssetBundle] this factory uses to work with assets.
  final AssetBundle bundle;

  /// Creates a new instance of the [RiveArtboardFactory] with the given [bundle].
  ///
  /// Throws an [ArgumentError] if the given [bundle] is `null`.
  RiveArtboardFactory(this.bundle) {
    ArgumentError.checkNotNull(bundle, 'bundle');
  }

  /// Returns a new [Artboard] from the asset with the given [assetName] having
  /// the given [artboardName].
  ///
  /// Returns the main [Artboard] if the given [artboardName] is null or not
  /// specified.
  ///
  /// Throws an [ArgumentError] if the given [assetName] is `null`.
  Future<Artboard> create(
    String assetName, {
    String artboardName,
  }) async {
    ArgumentError.checkNotNull(assetName, 'assetName');

    final assetBytes = await bundle.load(assetName);

    final riveFile = RiveFile();
    riveFile.import(assetBytes);

    if (artboardName == null) return riveFile.mainArtboard;

    return riveFile.artboardByName(artboardName);
  }
}
