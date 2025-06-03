import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innovahub_app/core/Api/Api_Manager_favourite.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class FavouriteTab extends StatefulWidget {
  static const String routeName = "FavouriteTab";

  @override
  State<FavouriteTab> createState() => _FavouriteTabState();
}

class _FavouriteTabState extends State<FavouriteTab> {
  final WishlistService wishlistService = WishlistService();
  List<Map<String, dynamic>> wishlistItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWishlistItems();
  }

  Future<void> fetchWishlistItems() async {
  if (!mounted) return;  // التحقق من أن الـ State لا يزال موجودًا
  setState(() => isLoading = true);

  wishlistItems = await wishlistService.fetchWishlist();
  print("Fetched wishlist items: $wishlistItems");

  if (!mounted) return;  // التحقق مرة أخرى بعد عملية الـ await
  setState(() => isLoading = false);
}


  Future<void> addProductToWishlist(int productId) async {
    bool success = await wishlistService.addProductToWishlist(productId);
    if (success) {
      fetchWishlistItems();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Product added to wishlist"),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.teal,
          content: Text("Failed to add to wishlist"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> removeFromWishlist(int index) async {
    final productId = wishlistItems[index]["ProductId"];
    bool success = await wishlistService.removeProductFromWishlist(productId);

    if (success) {
      setState(() {
        wishlistItems.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Constant.mainColor,
          content: Text("Item removed from wishlist",style: TextStyle(color: Constant.whiteColor),),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text("Failed to remove item"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : wishlistItems.isEmpty
              ? const Center(
                  child: Text(
                    "Favourite List is empty",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text("WishList  ",
                                  style: TextStyle(fontSize: 18)),
                              Text(
                                "(${wishlistItems.length} items)",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: wishlistItems.length,
                          itemBuilder: (context, index) {
                            final item = wishlistItems[index];
                            return Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      item["ProductHomeImage"] ?? "",
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    item["ProductName"] ?? "Product",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "\$${(item["FinalPrice"] as num).toStringAsFixed(2)}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          removeFromWishlist(index);
                                        },
                                        child: const FaIcon(
                                          FontAwesomeIcons.trashCan,
                                          color: Colors.red,
                                        ),
                                      ),
                                      /*IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          removeFromWishlist(index);
                                        },
                                      ),*/
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
