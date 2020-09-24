
import 'dart:io';
import 'dart:typed_data';

// import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutrifact/screens/result_screen.dart';
import 'package:path/path.dart';

class PreviewScreen extends StatefulWidget{
  final String imgPath;

  PreviewScreen({this.imgPath});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();

}
class _PreviewScreenState extends State<PreviewScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Image.file(File(widget.imgPath),fit: BoxFit.contain,),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 60.0,
                color: Colors.black,
                child: Center(
                  child: IconButton(
                    icon: Icon(Icons.share,color: Colors.white,),
                    onPressed: () async{
                      //Text recognition
                      final File imageFile = File(widget.imgPath);
                      final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
                      final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
                      final VisionText visionText = await textRecognizer.processImage(visionImage);
                      //String text = visionText.text;
                      // print(text);
                      for (TextBlock block in visionText.blocks) {
                        final Rect boundingBox = block.boundingBox;
                        final List<Offset> cornerPoints = block.cornerPoints;
                        final String text = block.text;
                        print('block --> $text');
                        final List<RecognizedLanguage> languages = block.recognizedLanguages;

                        for (TextLine line in block.lines) {
                          // Same getters as TextBlock
                          for (TextElement element in line.elements) {
                            // Same getters as TextBlock
                          }
                        }
                      }
                      textRecognizer.close();


                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResultScreen(
                              path: widget.imgPath,
                            )),
                      );
                      // getBytesFromFile().then((bytes){
                      //   //Share.file('Share via', basename(widget.imgPath), bytes.buffer.asUint8List(),'image/path');
                      // });
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<ByteData> getBytesFromFile() async{
    Uint8List bytes = File(widget.imgPath).readAsBytesSync() as Uint8List;
    return ByteData.view(bytes.buffer);
  }
}
