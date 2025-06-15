class ProductModel {
  final String productName;
  final String productAuthorId;
  final String productHomePicture;
  final double productPriceAfterDiscount;
  final double productPriceBeforeDiscount;
  final String productDescription;
  final int productStock;
  final double productRate;
  final int numberOfRatings;

  ProductModel({
    required this.productName,
    required this.productAuthorId,
    required this.productHomePicture,
    required this.productPriceAfterDiscount,
    required this.productPriceBeforeDiscount,
    required this.productDescription,
    required this.productStock,
    required this.productRate,
    required this.numberOfRatings,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productName: json['ProductName'] ?? '',
      productAuthorId: json['ProductAuthorId'] ?? '',
      productHomePicture: json['ProductHomePicture'] ?? '',
      productPriceAfterDiscount:
          (json['ProductPriceAfterDiscount'] ?? 0).toDouble(),
      productPriceBeforeDiscount:
          (json['ProductPriceBeforeDiscount'] ?? 0).toDouble(),
      productDescription: json['ProductDescription'] ?? '',
      productStock: json['ProductStock'] ?? 0,
      productRate: (json['ProductRate'] ?? 0).toDouble(),
      numberOfRatings: json['NumberOfRatings'] ?? 0,
    );
  }
}
