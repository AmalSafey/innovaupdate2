
  
  // Model => to get popular categories:
class CategoryResponse{
  
  // attributes:
  int id;
  String name;
  String imageUrl;

  // constructor:
  CategoryResponse({required this.id,required this.name,required this.imageUrl});

  // factory constructor:(from json):
  factory CategoryResponse.fromJson(Map<String, dynamic> json){

    return CategoryResponse(
      id: json['Id'] , 
      name:json['Name'] , 
      imageUrl: json['ImageUrl'] ,
      
      );
  }

  // to json:
  Map<String, dynamic> toJson(){

    return{
    'Id' : id,
    'Name' : name,
    'ImageUrl' : imageUrl,

    };
  }


}

