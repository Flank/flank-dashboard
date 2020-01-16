import 'package:flutter/material.dart';
import 'package:metrics/custom_painters/graph_painter.dart';
import 'package:metrics/utils/app_colors.dart';
import 'package:metrics/utils/scaling_info.dart';

class SparklineGraphWidget extends StatefulWidget {
  final String title;
  final String value;
  SparklineGraphWidget({this.title,this.value});

  @override
  _SparklineGraphWidgetState createState() => _SparklineGraphWidgetState();
}

class _SparklineGraphWidgetState extends State<SparklineGraphWidget> {
  @override
  Widget build(BuildContext context) {
   
    return SizedBox(
          width: 200 * ScalingInfo.scaleY,
          height: 155 * ScalingInfo.scaleY,
          child: Card( 
            color: AppColor.lightBlueColor,            
        child:  CustomPaint( 
            isComplex: false,child: 
          Padding(
            padding: EdgeInsets.all(20.0),
                  child: Stack(children: <Widget>[
              Text(widget.title,style: Theme.of(context).textTheme.display1.merge(TextStyle(fontSize: ScalingInfo.scaleX*15)),),
              Positioned.fill(child: Align(alignment: Alignment.center,child: Text(widget.value,style: Theme.of(context).textTheme.display2.merge(TextStyle(fontSize:ScalingInfo.scaleX*30 )),),),
              ),
            ],),
          ),
          painter: GraphPainter(),     
          ),     
      ),
    );
  }
}