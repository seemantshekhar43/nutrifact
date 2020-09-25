import 'package:nutrifact/models/nutrient.dart';

class Result {
  String manufacturer;
  String productName;
  List<Nutrient> nutrients;
  List<String> ingredients;
  bool containsCaffeine;
  double quantity;
  String quantityUnit;

  Result(
      {this.manufacturer,
      this.productName,
      this.nutrients,
      this.ingredients,
      this.containsCaffeine: false,
      this.quantity,
      this.quantityUnit});

  String get ingredientsString {
    String s = '';
    ingredients.forEach((element) {
      s += element + ', ';
    });

    if(s.length>3)
    return s.substring(0, s.length - 3);
    return s;
  }
}
