import 'package:metrics/common/presentation/colored_bar/theme/style/metrics_colored_bar_style.dart';
import 'package:metrics/common/presentation/metrics_theme/config/color_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_result_bar/theme/attention_level/build_result_bar_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_result_bar/theme/theme_data/build_result_bar_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("BuildResultsThemeData", () {
    test(
      "creates a new instance with given colors and textStyle",
      () {
        final buildResultsThemeData = BuildResultBarThemeData(
          attentionLevel: BuildResultBarAttentionLevel(
            successful: MetricsColoredBarStyle(
              color: ColorConfig.primaryColor,
              backgroundColor: ColorConfig.primaryColor,
            ),
            cancelled: MetricsColoredBarStyle(
              color: ColorConfig.inactiveColor,
              backgroundColor: ColorConfig.inactiveColor,
            ),
            failed: MetricsColoredBarStyle(
              color: ColorConfig.accentColor,
              backgroundColor: ColorConfig.accentColor,
            ),
          ),
        );
        expect(
          buildResultsThemeData.attentionLevel.cancelled.color,
          equals(ColorConfig.inactiveColor),
        );
        expect(
          buildResultsThemeData.attentionLevel.cancelled.backgroundColor,
          equals(ColorConfig.inactiveColor),
        );
        expect(
          buildResultsThemeData.attentionLevel.successful.color,
          equals(ColorConfig.primaryColor),
        );
        expect(
          buildResultsThemeData.attentionLevel.successful.backgroundColor,
          equals(ColorConfig.primaryColor),
        );
        expect(
          buildResultsThemeData.attentionLevel.failed.color,
          equals(ColorConfig.accentColor),
        );
        expect(
          buildResultsThemeData.attentionLevel.failed.backgroundColor,
          equals(ColorConfig.accentColor),
        );
      },
    );
  });
}
