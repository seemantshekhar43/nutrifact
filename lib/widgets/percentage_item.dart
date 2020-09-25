import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PercentageItem extends StatelessWidget {
  final String label;
  final double percentage;
  final Color color;

  PercentageItem({this.label, this.percentage, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.15,
      width: MediaQuery.of(context).size.width*0.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SfRadialGauge(axes: <RadialAxis>[
              RadialAxis(
                  minimum: 0,
                  maximum: 100,
                  showLabels: false,
                  showTicks: false,
                  axisLineStyle: AxisLineStyle(
                    thickness: 0.2,
                    cornerStyle: CornerStyle.bothCurve,
                    color: color.withOpacity(0.4),
                    thicknessUnit: GaugeSizeUnit.factor,
                  ),
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: percentage,
                      cornerStyle: CornerStyle.bothCurve,
                      width: 0.2,
                      color: color,
                      sizeUnit: GaugeSizeUnit.factor,
                    ),

                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        positionFactor: 0.1,
                        angle: 90,
                        widget: Text(
                          percentage.toStringAsFixed(0) + ' %',
                          style: TextStyle(fontSize: 14),
                        ))
                  ]),
            ]),
          ),

          Text(label, style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),)
        ],
      ),
    );
  }
}
