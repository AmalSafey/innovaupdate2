// Model Business owner response:

class BusinessOwnerResponse {
  String businessownerId;
  String businessownerName;
  String businessName;
  String description;
  double offerMoney;
  double offerDeal;
  String approvedAt;
  int categoryId;
  String categoryName;
  List<String> images;

  BusinessOwnerResponse({
    required this.businessownerId,
    required this.businessownerName,
    required this.businessName,
    required this.description,
    required this.offerMoney,
    required this.offerDeal,
    required this.approvedAt,
    required this.images,
    required this.categoryId,
    required this.categoryName,
  });

  // from json:

  factory BusinessOwnerResponse.fromjson(Map<String, dynamic> json) {
    return BusinessOwnerResponse(
      businessownerId: json['BusinessOwnerId'],
      businessownerName: json['BusinessOwnerName'],
      businessName: json['BusinessName'],
      description: json['Description'],
      offerMoney: json['OfferMoney'],
      offerDeal: json['OfferDeal'],
      images: (json['Pictures'] != null && json['Pictures'] is List)
          ? List<String>.from(json['Pictures'])
          : [],
      categoryId: json['CategoryId'],
      categoryName: json['CategoryName'],
      approvedAt: json['ApprovedAt'],
    );
  }

  // to json:

  Map<String, dynamic> toJson() {
    return {
      'BusinessOwnerId': businessownerId,
      'BusinessOwnerName': businessownerName,
      'BusinessName': businessName,
      'Description': description,
      'OfferMoney': offerMoney,
      'OfferDeal': offerDeal,
      'Pictures': images,
      'CategoryId': categoryId,
      'CategoryName': categoryName,
    };
  }
}
