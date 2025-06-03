
import 'package:flutter/material.dart';
import 'package:innovahub_app/Models/product_response.dart';
import 'package:innovahub_app/core/Api/Api_Manager_favourite.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class FavoriteIconButton extends StatefulWidget {
  final ProductResponse product;

  const FavoriteIconButton({Key? key, required this.product}) : super(key: key);

  @override
  State<FavoriteIconButton> createState() => _FavoriteIconButtonState();
}

class _FavoriteIconButtonState extends State<FavoriteIconButton> {
  bool isFavorite = false;
  final WishlistService wishlistService = WishlistService();

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
  List<Map<String, dynamic>> wishlist = await wishlistService.fetchWishlist();
  if (mounted) {
    setState(() {
      isFavorite = wishlist.any((item) => item["ProductID"] == widget.product.productId);
    });
  }
}


  Future<void> _toggleFavorite() async {
    bool success = await wishlistService.addProductToWishlist(widget.product.productId);

    if (success) {
      setState(() {
        isFavorite = !isFavorite;
      });

      QuickAlert.show(
        context: context,
        type: isFavorite ? QuickAlertType.success : QuickAlertType.info,
        title: isFavorite
            ? "Added to favourite successfully"
            : "Removed from favourites",
        confirmBtnColor: Constant.mainColor,
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Failed to update wishlist",
        confirmBtnColor: Constant.mainColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFavorite,
      child: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.black,
      ),
    );
  }
}