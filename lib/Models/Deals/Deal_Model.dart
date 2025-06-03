
 // Deal Model:
class DealModel{

  String businessName;
  String description;
  String offerMoney;
  String offerDeal;
  String manufacturingCost;
  String estimatedPrice;
  int categoryId;
  List <String>? images;
 
 DealModel({required this.businessName,
 required this.description,
 required this.offerMoney,
 required this.offerDeal,
 required this.manufacturingCost,
 required this.estimatedPrice,
 required this.categoryId,
  this.images,
 });

  // to json:

  Map<String, dynamic> toJson() {
    return {
      'BusinessName': businessName,
      'Description': description,
      'OfferMoney': offerMoney,
      'OfferDeal': offerDeal,
      'ManufacturingCost': manufacturingCost,
      'EstimatedPrice': estimatedPrice,
      'CategoryId': categoryId,
      'Pictures': images ?? [],
    };
  }


}

