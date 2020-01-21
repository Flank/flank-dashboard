import 'package:flutter/material.dart';
import 'package:metrics/chart/chart.dart';
import 'package:metrics/chart/chart_data.dart';
import 'package:metrics/circle_progress_store.dart';
import 'package:metrics/repository/circle_progress_repository.dart';
import 'package:metrics/ui/widgets/circle_progress_widget.dart';
import 'package:metrics/ui/widgets/loading_widget.dart';
import 'package:metrics/ui/widgets/sparkline_graph_widget.dart';
import 'package:metrics/utils/app_colors.dart';
import 'package:metrics/utils/app_strings.dart';
import 'package:metrics/utils/scaling_info.dart';
import 'dart:math' as math;

import 'package:states_rebuilder/states_rebuilder.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  //dummy data
  // final double mockDataStability = 0.50;
  // final double mockDataCoverage = math.Random().nextDouble();
  final int buildsNumber = 7;
  final String performanceValue = "10M";
  Chart _chart;

  @override
  void initState() {
    var data = ChartData();
    _chart = Chart([data.dataSet1]);
    _chart.domainStart = 1;
    _chart.domainEnd = 6;
    _chart.rangeStart = 0;
    _chart.rangeEnd = 10;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!ScalingInfo.initialized) {
      ScalingInfo.init(context);
    }

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                SparklineGraphWidget(
                  title: AppStrings.performance,
                  value: performanceValue,
                  chart: _chart,
                ),
                SizedBox(
                  width: 20,
                ),
                SparklineGraphWidget(
                  title: AppStrings.builds,
                  value: buildsNumber.toString(),
                  chart: _chart,
                ),
                SizedBox(
                  width: 20,
                ),
                
                StateBuilder<CircleProgressStore>(
                  models: [Injector.getAsReactive<CircleProgressStore>()],
                  builder: (_, reactiveModel) {
                    return reactiveModel.whenConnectionState(
                      onIdle: () =>
                          buildInitialInput(AppStrings.stability),
                      onWaiting: () => Loading(),
                      onData: (store) => CircleProgressWidget(
                        title: AppStrings.stability,
                        percent: store.circleProgressModelStability.data??0.0,
                        color: AppColor.purpleColor,
                      ),
                      onError: (_) =>
                          buildInitialInput(AppStrings.stability),
                    );
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                
                
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInitialInput(String type) {
    return Container(
      width: 150 * ScalingInfo.scaleY,
      height: 150 * ScalingInfo.scaleY,
      child: Center(
        child: RaisedButton(
          color: AppColor.lightBlueColor,
          textColor: AppColor.whiteColor,
          child: Text("Show progress"),
          onPressed: () {
            _submitProgressBarType(type);
          },
        ),
      ),
    );
  }

  void _submitProgressBarType(String type) {
    final reactiveModel = Injector.getAsReactive<CircleProgressStore>();
    reactiveModel.setState(
      (store) {
        if (type == AppStrings.stability)
          return store.getCircleProgressStability();
          else
          return store.getCircleProgressCoverage();
      },
      onError: (context, error) {
        if (error is NetworkError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content:
                  Text("Couldn't fetch $type progress. Is the device online?"),
            ),
          );
        } else {
          throw error;
        }
      },
    );
  }
}
