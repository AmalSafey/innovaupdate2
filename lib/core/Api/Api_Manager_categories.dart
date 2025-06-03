
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:innovahub_app/Models/Category_Item_response.dart';
import 'package:innovahub_app/Models/Category_response.dart';
import 'package:innovahub_app/Models/product_response.dart';

// class => represent Methods of API:

class ApiManagerCategories {
  
  //https://innova-hub.premiumasp.net/api/Category/getAllCategories

  static const String baseUrl = 'innova-hub.premiumasp.net'; // name of the server:

  static Future<List<CategoryItemResponse>> getAllCategoryItems() async {
    
    // divide Url:
    var url = Uri.https(baseUrl,'/api/Category/getAllCategories');

    var response = await http.get(url); // we make a request:

    if (response.statusCode == 200) {
      // that mean server response with data:

      var bodyString = response.body; // data => of Type String:
      List<dynamic> json = jsonDecode(bodyString); // convert String to json (parsing):

      return json
          .map((json) => CategoryItemResponse.fromJson(json))
          .toList(); // convert json to object (model):(list of categories):
    } else {
      throw Exception('failed to load categories');
    }
  }

  //https://innova-hub.premiumasp.net/api/Category/getPopularCategories
  static Future<List<CategoryResponse>> getAllCategories() async {
    var url = Uri.https(baseUrl, '/api/Category/getPopularCategories');
    var response = await http.get(url); // request:

    if (response.statusCode == 200) {
      // that mean server response with data:

      var bodyString = response.body; // data => of type String:
      List<dynamic> json = jsonDecode(bodyString); // string => to list of json:

      return json
          .map((json) => CategoryResponse.fromJson(json))
          .toList(); // list of categories:
    } else {
      throw Exception('failed to load categories');
    }
  }

  // Get all Products from Api:
  //https://innova-hub.premiumasp.net/api/Category/getProductsByCategory/21
  static Future<CategoryModel> getProducts([int? id]) async {
    var url = Uri.https(baseUrl, '/api/Category/getProductsByCategory/$id');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var bodyString = response.body;
      var json = jsonDecode(bodyString);
      var productResponse = CategoryModel.fromJson(json);

      return productResponse; // return all products:
    } else {
      throw Exception('failed to load categories');
    }
  }
  

   

}

