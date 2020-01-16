import 'package:flutter/material.dart';
import 'package:metrics/custom_painters/line_painter.dart';
import 'package:metrics/utils/app_colors.dart';
import 'package:metrics/utils/app_strings.dart';
import 'package:metrics/utils/scaling_info.dart';

class BuildResultWidget extends StatefulWidget 
{
  final List<double> list=[2.0,1,4,5,2,5,3,4,10];
 
  @override
  _BuildResultWidgetState createState() => _BuildResultWidgetState();
}

class _BuildResultWidgetState extends State<BuildResultWidget>
{
  @override
  Widget build(BuildContext context) 
  {
  
    return
     SizedBox(
       width: 150 * ScalingInfo.scaleY,
          height: 150 * ScalingInfo.scaleY,
            child: Column
              (       
              
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>
              [
                Text(AppStrings.buildJobName,style: Theme.of(context).textTheme.body1.merge(TextStyle(fontSize: ScalingInfo.scaleX*12)),),
                SizedBox(height: 10,),
                Expanded(
                                  child: Container
                  (
                    
                              
                  decoration: BoxDecoration
                  ( 
                    border: Border.all(color: AppColor.blackColor0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    
                  ),
                  child: Padding(padding: EdgeInsets.all(30.0),
                  child: ListView.builder
                  (
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: widget.list.length,
                        itemBuilder: 
                        (context,index)
                        {
                        return 
                         Padding(
                           padding: const EdgeInsets.only(right:8.0),
                           child: CustomPaint
                           (
                             size:Size.fromHeight(100 * ScalingInfo.scaleY-20.0),
                              painter: LinePainter(index.toDouble(),widget.list[index]),
                              child: Container(                          
                              width: 7 * ScalingInfo.scaleY,
                              height: 100 * ScalingInfo.scaleY-20.0,
                              ),
                            ),
                         );
                        },                            
                      ),

                    ),
                  ),
                ),
            ],
        ),
     );
  }
}