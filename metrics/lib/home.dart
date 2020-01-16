import 'package:flutter/material.dart';
import 'package:metrics/utils/app_colors.dart';
import 'package:metrics/utils/app_strings.dart';
import 'package:metrics/utils/scaling_info.dart';
import 'package:metrics/widgets/build_results_widget.dart';
import 'package:metrics/widgets/circle_progress_widget.dart';
import 'package:metrics/widgets/sparkline_graph_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) 
  {

    if (!ScalingInfo.initialized) 
    {
      ScalingInfo.init(context);
    }
    
      return Scaffold(
          body:
           SafeArea(
             child: 
             SingleChildScrollView(
               primary: false,               
                    physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                      child: Center(
                          child: Row(               
                  children: <Widget>
                  [               
                    SizedBox(width: 20,),
                    BuildResultWidget(),
                     SizedBox(width: 20,),
                                          SparklineGraphWidget(
                        title: AppStrings.performance,
                        value: "10M",
                    ),
                     SizedBox(width: 20,),
                     SparklineGraphWidget(
                        title: AppStrings.builds,
                        value: "7",
                     
                    ),
                     SizedBox(width: 20,),
                    CircleProgressWidget(
                      title: AppStrings.stability,
                      percent: 50.0,
                      color: AppColor.mediumBlueColor,
                    ),
                     SizedBox(width: 20,),
                    CircleProgressWidget(
                      title: AppStrings.coverage,
                      percent: 26.0,
                      color: AppColor.purpleColor,
                    ),   
                         SizedBox(width: 20,),      
                  ],
                ),
                          ),        
        ),
      ),
         
          );
    
  }
}
