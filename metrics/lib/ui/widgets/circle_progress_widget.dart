import 'package:flutter/material.dart';
import 'package:metrics/custom_painters/circle_progress_painter.dart';
import 'package:metrics/utils/app_keys.dart';
import 'package:metrics/utils/scaling_info.dart';

class CircleProgressWidget extends StatefulWidget
{
  final String title;
  final double percent;
  final Color color;
 
  CircleProgressWidget(
      { this.title = "", this.percent = 0.0, this.color = Colors.transparent,Key key}):super(key:key);
  @override
  _CircleProgressWidgetState createState() => _CircleProgressWidgetState();
}

class _CircleProgressWidgetState extends State<CircleProgressWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2400));

    _controller.addListener(() {
      setState(() {});
    });

    _controller.animateTo(widget.percent);

    super.initState();
  }

  

  @override
  void didUpdateWidget(CircleProgressWidget oldWidget) {
    if (oldWidget.percent != widget.percent) {
      _controller.animateTo(widget.percent);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(context) 
  {
   
    return Container(
      width: 150 * ScalingInfo.scaleY,
      height: 150 * ScalingInfo.scaleY,
      padding: EdgeInsets.all(10),
      child: CustomPaint(
        key:Key(AppKeys.circularProgressKey),
        isComplex: false,
        size: Size.fromRadius(1.0),
        painter: CircleProgressPainter(_controller.value, widget.color),
       
        child: 
         Container(
          
          padding: EdgeInsets.all(20),
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
               
                children: <Widget>[
                 
                     FittedBox(
                       fit: BoxFit.contain,
                     alignment: Alignment.center,
                    child: Text('${(_controller.value * 100).toInt()}%',
                        key: Key(AppKeys.percentageKey),
                        style: Theme.of(context).textTheme.display3.merge(TextStyle(
                            color: widget.color, fontSize: ScalingInfo.scaleX * 40)),
                            maxLines: 1,                           
                            ),
                    ),                 
                  FittedBox(
                    fit: BoxFit.contain,
                     alignment: Alignment.center,
                        child: Text(widget.title,
                        key: Key(AppKeys.circularProgressTitleKey),
                          style: Theme.of(context)
                              .textTheme
                              .display1
                              .merge(TextStyle(fontSize: ScalingInfo.scaleX * 15),),),
                  ),
                                  
                 
                ],
             
          ),
        ),
        
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
