import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:metrics/utils/app_colors.dart';
import 'package:metrics/utils/app_strings.dart';
import 'package:metrics/utils/scaling_info.dart';

class BuildResultWidget extends StatefulWidget 
{
  @override
  _BuildResultWidgetState createState() => _BuildResultWidgetState();
}

class _BuildResultWidgetState extends State<BuildResultWidget>
{

  // final List<double> dummyList=[2,1,4,5,2,5,3,1,2,1,2,1,2,1];

  /// Create series list with single series
  static List<Series<OrdinalSales, String>> _createSampleData() {
    final globalSalesData = [
      new OrdinalSales('2007', 3100),
      new OrdinalSales('2008', 3500),
      new OrdinalSales('2009', 5000),
      new OrdinalSales('2010', 2500),
      new OrdinalSales('2011', 3200),
      new OrdinalSales('2012', 4500),
      new OrdinalSales('2013', 4400),
      new OrdinalSales('2014', 5000),
      new OrdinalSales('2015', 5000),
      new OrdinalSales('2016', 4500),
      new OrdinalSales('2017', 4300),
       new OrdinalSales('2014', 5000),
      new OrdinalSales('2015', 5000),
      new OrdinalSales('2016', 4500),
      new OrdinalSales('2017', 4300),
       new OrdinalSales('2013', 4400),
      new OrdinalSales('2014', 5000),
      new OrdinalSales('2015', 5000),
      new OrdinalSales('2016', 4500),
      new OrdinalSales('2017', 4300),
       new OrdinalSales('2014', 5000),
      new OrdinalSales('2015', 5000),
      new OrdinalSales('2016', 4500),
      new OrdinalSales('2017', 4300),
    ];

    return [
      new Series<OrdinalSales, String>(
        id: 'Global Revenue',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: globalSalesData,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) 
  {
  
    return
     SizedBox(
       width: 145 * ScalingInfo.scaleX,
          height: 140 * ScalingInfo.scaleY,
            child: Column
              (       
              
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>
              [
                Text(AppStrings.buildJobName,style: Theme.of(context).textTheme.body1.merge(TextStyle(fontSize: ScalingInfo.scaleX*12)),),
                SizedBox(height: 10,),
                Expanded(
                                  child: Card(

                                                                      child: Container
                  (

                    width: 145 * ScalingInfo.scaleX,
                    
                              
                  decoration: BoxDecoration
                  ( 
                    border: Border.all(color: AppColor.blackColor0),
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    
                  ),
                  child: Padding(padding: EdgeInsets.all(25.0),
                  // child: ListView.builder
                  // (
                  //   shrinkWrap: true,
                  //   // scrollDirection: Axis.horizontal,
                  //   physics: BouncingScrollPhysics(),
                  //   itemCount: dummyList.length,
                  //       itemBuilder: 
                  //       (context,index)
                  //       {
                  //       return 
                  //        Padding(
                  //          padding: const EdgeInsets.only(right:8.0),
                  //          child: CustomPaint
                  //          (
                  //            size:Size.fromHeight(100 * ScalingInfo.scaleY-20.0),
                  //             painter: LinePainter(index.toDouble(),dummyList[index]),
                  //             child: Container(                          
                  //             width: 7 * ScalingInfo.scaleY,
                  //             height: 100 * ScalingInfo.scaleY-20.0,
                  //             ),
                  //           ),
                  //        );
                  //       },                            
                  //     ),
                  child: CustomRoundedBars(_createSampleData()),

                    ),
                  ),
                                  ),
                ),
            ],
        ),
     );
  }
}









class CustomRoundedBars extends StatelessWidget {
  final List<Series> seriesList;
  final bool animate;

  CustomRoundedBars(this.seriesList, {this.animate});

 
  factory CustomRoundedBars.withSampleData() {
    return new CustomRoundedBars(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new BarChart(
      seriesList,
      animate: animate,
      defaultRenderer: new BarRendererConfig(
        

          // By default, bar renderer will draw rounded bars with a constant
          // radius of 100.
          // To not have any rounded corners, use [NoCornerStrategy]
          // To change the radius of the bars, use [ConstCornerStrategy]
          cornerStrategy: const ConstCornerStrategy(30)),
    );
  }

  /// Create one series with sample hard coded data.
  static List<Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    return [
      new Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
