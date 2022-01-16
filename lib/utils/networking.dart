import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_encoder/url_encoder.dart';

const String apiKey = "11ebb933a8d3463a9259571160f1a19a";

class NetWorkHelper {
  Future getMyData(String city, String street) async {
    String adress = urlEncode(text: "$city, $street");
    http.Response response = await http.get(
        "https://api.opencagedata.com/geocode/v1/json?q=$adress&key=$apiKey&pretty=1&countrycode=br");

    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      return decodedData;
    } else {
      print(response.statusCode);
      throw 'Problem with the get request';
    }
  }
}
