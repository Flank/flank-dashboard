// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_color/metrics_color.dart';

// ignore_for_file: public_member_api_docs

/// A class that holds main colors used in the application.
class MetricsColors {
  static const Color black = Color(0xFF000000);
  static const Color barrierColor = Color.fromRGBO(13, 13, 13, 0.8);
  static const Color shadow32 = Color.fromRGBO(0, 0, 0, 0.32);
  static const Color shadow50 = Color.fromRGBO(0, 0, 0, 0.5);
  static const Color white = Color(0xFFFFFFFF);

  static const MetricsColor grey = MetricsColor(
    _grayPrimaryValue,
    <int, Color>{
      100: Color(0xFFF5F8FA),
      200: Color(0xFFDCDCE3),
      300: Color(0xFF878799),
      400: Color(0xFF4F4F56),
      500: Color(_grayPrimaryValue),
      600: Color(0xFF303033),
      700: Color(0xFF252528),
      800: Color(0xFF1B1B1D),
      900: Color(0xFF0D0D0D),
    },
  );
  static const int _grayPrimaryValue = 0xFF3B3B41;

  static const MetricsColor green = MetricsColor(
    _greenPrimaryValue,
    <int, Color>{
      100: Color(0xFFE6F9F3),
      200: Color(0xFFB6E3D5),
      500: Color(_greenPrimaryValue),
      600: Color(0xFF1EB284),
      800: Color(0xFF07372F),
      900: Color(0xFF182B27),
    },
  );
  static const int _greenPrimaryValue = 0xFF20CE9A;

  static const MetricsColor orange = MetricsColor(
    _orangePrimaryValue,
    <int, Color>{
      100: Color(0xFFFFF5F3),
      200: Color(0xFFF9BCAE),
      500: Color(_orangePrimaryValue),
      600: Color(0xFFE2431F),
      800: Color(0xFF5A281F),
      900: Color(0xFF2D1F1F),
    },
  );
  static const int _orangePrimaryValue = 0xFFF45531;

  static const MetricsColor yellow = MetricsColor(
    _yellowPrimaryValue,
    <int, Color>{
      100: Color(0xFFFAF6E6),
      200: Color(0xFFFCEEB0),
      500: Color(_yellowPrimaryValue),
      600: Color(0xFFCCA800),
      800: Color(0xFF54480C),
      900: Color(0xFF292618),
    },
  );
  static const int _yellowPrimaryValue = 0xFFFED100;
}
