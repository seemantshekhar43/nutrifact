import 'dart:convert';
import 'dart:io';
import 'package:nutrifact/constant.dart';
import 'package:nutrifact/models/nutrient.dart';
import 'package:nutrifact/models/result.dart';

import 'http_exception.dart';
import 'package:http/http.dart' as http;


const baseUrl = 'http://8b393b5f1be3.ngrok.io/';
//Removed extra codes which are of no use.


Future<Result> spellCheck(String output) async{
  Result result;
  try{
    final url = '$baseUrl';
    print(url);
    final String finalOutput = output.replaceAll('"', '');
    print(finalOutput);
    final response = await http.post(url, body: json.encode({'content': finalOutput}), headers: {'Content-Type': 'application/json'});
    if(response.statusCode == 200){
      //print('ran block');
      print(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);
      print('response is: ' + responseBody.length.toString());
      //text =  responseBody['text'];
      String manufacturer = responseBody['Manufactured By']??'';
      String quantity = responseBody['Quantity']??'';
      bool caffeine = responseBody['Caffeine']??false;
      List<String> ingredients = [];
      if(responseBody['ingredients'].toList().isNotEmpty){
        List<dynamic> dataIngredients = responseBody['ingredients'].toList();
        dataIngredients.forEach((element) {
          ingredients.add(element.toString());
        });
      }

      List<Nutrient> nutrients = [];
      int count = 0;
      double total = 0;
      if(responseBody['nutrient'].toList().isNotEmpty){
        List<dynamic>dataNutrients = responseBody['nutrient'].toList();
        dataNutrients.forEach((element) {
          if(element[2] == 'g'){
            total+=double.parse(element[1]);
          }
          if(element[2] == 'mg'){
            total+=double.parse(element[1])/1000;
          }
          Nutrient nutrient = Nutrient( name: element[0], value: double.parse(element[1]), unit: element[2], color: kColorsList[count%5]);
          nutrients.add(nutrient);
          count++;
        });

        nutrients.forEach((element) {
          double percentage = 0;
          if(element.unit == 'g'){
            percentage = element.value/total*100;
          }
          if(element.unit == 'mg'){
            percentage = element.value/total*100/1000;
          }
          element.percentage = percentage;
        });

      }

       result= Result(manufacturer: manufacturer, productName: 'Soft Drink', nutrients: nutrients, ingredients: ingredients, quantityUnit: quantity, containsCaffeine: caffeine);
      //print('text: $text');
    }else{
      print(jsonDecode(response.body));
      throw HttpException(message: 'Error Converting to Text');
    }
    return result;

  }catch(error){
    throw error;
  }
}





