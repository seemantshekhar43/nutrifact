import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nutrifact/constant.dart';

class ResultScreen extends StatelessWidget {
  final path;

  ResultScreen({this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Container(

              height: MediaQuery.of(context).size.height * 0.25,
              width: double.maxFinite,
              // alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(File(path)), fit: BoxFit.cover)),
              child: Stack(
                children: [
                  Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Parle G',
                          style: kLabelTextStyle,
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text('50g \t 500Cal', style: kLabelSubsTextStyle,)
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 16,
            ),


          ],
        ),
      ),
    );
  }
}
