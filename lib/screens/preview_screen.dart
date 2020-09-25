import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutrifact/constant.dart';
import 'package:nutrifact/models/ocr_text.dart';
import 'package:nutrifact/models/result.dart';
import 'package:nutrifact/screens/result_screen.dart';
import 'package:nutrifact/service/api_helper.dart' as helper;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class PreviewScreen extends StatefulWidget {
  final String imgPath;

  PreviewScreen({this.imgPath});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Image.file(
              File(widget.imgPath),
              fit: BoxFit.fitWidth,
            ),
          ),

          Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
    },
                    child: Container(
                        height: 60.0,
                        color: Colors.black,
                        child: Center(
                          child: Text('Cancel'.toUpperCase(), style: kWhiteButtonTextStyle,),
                        )),
                  ),
                ),
                SizedBox(width: 0.4,),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      //Text recognition
                      setState(() {
                        _isLoading = true;
                      });
                      final File imageFile = File(widget.imgPath);
                      final FirebaseVisionImage visionImage =
                          FirebaseVisionImage.fromFile(imageFile);
                      final TextRecognizer textRecognizer =
                          FirebaseVision.instance.cloudTextRecognizer();
                      final VisionText visionText =
                          await textRecognizer.processImage(visionImage);
                      //String text = visionText.text;
                      // print(text);
                      //OCRText ocrText = OCRText();
                      String outputText = '';
                      List<Block> blocks = [];
                      for (TextBlock block in visionText.blocks) {
                        List<Line> lines = [];
                        outputText+='###';
                        final Rect boundingBox = block.boundingBox;
                        final List<Offset> cornerPoints = block.cornerPoints;
                        final String text = block.text;
                      // print('block --> $text');
                        final List<RecognizedLanguage> languages =
                            block.recognizedLanguages;

                        for (TextLine line in block.lines) {
                          // Same getters as TextBlock
                          List<String> elements= [];
                          outputText+='~~~';
                          outputText+=line.text;
                          for (TextElement element in line.elements) {
                            // Same getters as TextBlock
                            elements.add(element.text);
                          }
                          lines.add(Line(elements: elements));
                        }
                        blocks.add(Block(lines:lines ));
                      }
                      OCRText ocrText = OCRText(blocks:blocks);

                      //OUTPUT
                      print(outputText);
                      //Share.text('Output text', outputText, 'text/plain');
                      try{
                        Result result  = await helper.spellCheck(outputText);
                        print('correct: ' + result.toString());
                        textRecognizer.close();
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResultScreen(
                                path: widget.imgPath,result: result,
                              )),
                        );
                      }catch(e){
                        setState(() {
                          _isLoading = false;
                        });

                        textRecognizer.close();
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Unable to process this image'),));
                      }


                      // getBytesFromFile().then((bytes){
                      //   //Share.file('Share via', basename(widget.imgPath), bytes.buffer.asUint8List(),'image/path');
                      // });
                    },

                    child: Container(
                        height: 60.0,
                        color: Colors.black,
                        child: Center(
                          child: (_isLoading)? SpinKitThreeBounce(color: Colors.white,) :Text('Process'.toUpperCase(), style: kWhiteButtonTextStyle,),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<ByteData> getBytesFromFile() async {
    Uint8List bytes = File(widget.imgPath).readAsBytesSync() as Uint8List;
    return ByteData.view(bytes.buffer);
  }
}
