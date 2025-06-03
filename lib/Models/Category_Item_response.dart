
 // Model of data that represented data that returned from ApI:

 class CategoryItemResponse {
  // attributes:
   int categoryId;
   String categoryName;

  CategoryItemResponse({
    required this.categoryId,
    required this.categoryName,
  });

  // Factory method to create a Category object from JSON
  factory CategoryItemResponse.fromJson(Map<String, dynamic> json) {

    return CategoryItemResponse(

      categoryId: json['CategoryId'],
      categoryName: json['CategoryName'],

    );
  }
  
  static List<CategoryItemResponse> localData = [
    CategoryItemResponse(categoryId: 2, categoryName: "Home"),
    CategoryItemResponse(categoryId: 3, categoryName: "Bags"),
    CategoryItemResponse(categoryId: 4, categoryName: "Jewelry"),
    CategoryItemResponse(categoryId: 5, categoryName: "Art"),
    CategoryItemResponse(categoryId: 11, categoryName: "Men"),
    CategoryItemResponse(categoryId: 12, categoryName: "Watches"),
    CategoryItemResponse(categoryId: 14, categoryName: "Drawing"),
    CategoryItemResponse(categoryId: 15, categoryName: "Necklace"),
    CategoryItemResponse(categoryId: 16, categoryName: "Wood Crafting"),
    CategoryItemResponse(categoryId: 19, categoryName: "Crafts"),
    CategoryItemResponse(categoryId: 20, categoryName: "Toys"),
    CategoryItemResponse(categoryId: 21, categoryName: "Carpets"),
    CategoryItemResponse(categoryId: 22, categoryName: "Rings"),
    CategoryItemResponse(categoryId: 23, categoryName: "Carpts"),
  ];

 
}

  


 /*class CategoryResponse{
  
   // attributes:
   
   String? status; 
   int? categoryId;
   String? categoryName;
   String? message;
   String? code;

  // constructor:
  CategoryResponse({this.categoryId,this.categoryName,this.message,this.code,this.status});

  // factory constructor: (from json):
  factory CategoryResponse.fromJson(Map<String, dynamic> json){
  
  return CategoryResponse(
    status: json['status'] as String?,
    categoryId: json['CategoryId'] as int?,
    categoryName: json['CategoryName'] as String?,
    message: json['message'] as String?,
    code: json['code'] as String?,

  );

  }

  // to json:

  Map<String, dynamic> toJson(){

   final Map<String, dynamic> map = <String, dynamic>{};

   map['status'] = status;
   map['CategoryId'] = categoryId;
   map['CategoryName'] = categoryName;

   return map;

  }

 }*/


