import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutrifact/constant.dart';
import 'package:nutrifact/models/nutrient.dart';
import 'package:nutrifact/models/result.dart';
import 'package:nutrifact/widgets/percentage_item.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class ResultScreen extends StatefulWidget {
  final path;
  final Result result;
  ResultScreen({this.path, this.result});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Result result;
  File _imageFile;
  List<Nutrient> _nutrients = [];

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    result = widget.result;
    result.nutrients.forEach((element) {
      if(element.unit =='g' || element.unit == 'mg')
        _nutrients.add(element);
    });
    _nutrients.sort(((a, b) => (b.percentage -a.percentage).toInt()));
   // initialiseResult();
    super.initState();
  }

  void initialiseResult() {
    final List<String> ingredients = [
      'Carbonated Water',
      'Sugar',
      'Aspertame',
      'Phosphoric Acid',
      'Citric Acid',
      'Caffeine',
      'Caramel Colors',
      'Added Flavors'
    ];
    final List<Nutrient> list = [
      Nutrient(
          name: 'Protein',
          value: 40,
          unit: 'g',
          percentage: 40,
          color: kColorsList[0]),
      Nutrient(
          name: 'Carbohydrate',
          value: 30,
          unit: 'g',
          percentage: 30,
          color: kColorsList[1]),
      Nutrient(
          name: 'Sugar',
          value: 15,
          unit: 'g',
          percentage: 10,
          color: kColorsList[2]),
      Nutrient(
          name: 'Sodium',
          value: 10,
          unit: 'g',
          percentage: 10,
          color: kColorsList[3]),
      Nutrient(
          name: 'Fat',
          value: 5,
          unit: 'g',
          percentage: 10,
          color: kColorsList[4]),
    ];
    result = Result(
      productName: 'Sprite',
      manufacturer:
          'The Coca Cola company, West Delhi Branch, Industrial Area, Narela, Delhi- 110040 India',
      nutrients: list,
      ingredients: ingredients,
      containsCaffeine: false,
      quantity: 330,
      quantityUnit: 'mL',
    );
  }

  captureScreenshot(){
    screenshotController.capture().then((File image) {
      //Capture Done
      setState(() {
        _imageFile = image;
      });
      getBytesFromFile().then((bytes){
        Share.file('Share via', 'random.png', bytes.buffer.asUint8List(),'image/path');
      });
    }).catchError((onError) {
      print(onError);
    });
  }


  Future<ByteData> getBytesFromFile() async {
    Uint8List bytes = File(_imageFile.path).readAsBytesSync();
    return ByteData.view(bytes.buffer);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.25,
                floating: false,
                pinned: true,
                backgroundColor: Colors.black,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  title: Text(
                    result.productName,
                    style: kProductNameTextStyle,
                  ),
                  background: Stack(
                    children: [
                      Container(
                          width: double.infinity,
                          child: Image.file(
                            File(widget.path),
                            fit: BoxFit.cover,
                          )),
                      Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: Screenshot(
            controller: screenshotController,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Here\'s your Food summary',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Center(
                            child: Container(
                              height: 1.5,
                              width: MediaQuery.of(context).size.width * 0.3,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nutrition Fact',
                            style: kLabelTextStyle,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _nutrients.length,
                            itemBuilder: (context, i) {

                              return PercentageItem(
                                label: _nutrients[i].name,
                                percentage: _nutrients[i].percentage,
                                color: _nutrients[i].color,
                              );
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 10.0,
                                    childAspectRatio: 2 / 2.5,
                                    crossAxisSpacing: 10.0),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: result.nutrients.length,
                              shrinkWrap: true,
                              itemBuilder: (context, i) {
                                return ListTile(
                                  leading: Container(
                                    height:
                                        MediaQuery.of(context).size.width * 0.05,
                                    width:
                                        MediaQuery.of(context).size.width * 0.05,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: result.nutrients[i].color,
                                    ),
                                  ),
                                  title: Text(
                                    result.nutrients[i].name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Colors.black),
                                  ),
                                  trailing: Text(
                                    result.nutrients[i].value.toStringAsFixed(1) +
                                        ' ${result.nutrients[i].unit}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ingredients',
                            style: kLabelTextStyle,
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            result.ingredientsString,
                            style: kDescTextStyle,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    Center(
                      child: Container(
                        margin: EdgeInsets.all(16),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black, width: 1, style: BorderStyle.solid)
                        ),
                        child: Text(result.containsCaffeine? 'contains caffeine'.toUpperCase(): 'Does not contain caffeine'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Manufacturer Information',
                            style: kLabelTextStyle,
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            result.manufacturer,
                            style: kDescTextStyle,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Net Quantity',
                            style: kLabelTextStyle,
                          ),
                          Spacer(),
                          Text(
                            '${result.quantityUnit}',
                            style:TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),

                          ),
                        ],
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: (){
                    //     captureScreenshot();
                    //   },
                    //   child: Container(
                    //       height: 60.0,
                    //       color: Colors.black,
                    //       child: Center(
                    //         child: Text('Share'.toUpperCase(), style: kWhiteButtonTextStyle,),
                    //       )),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
