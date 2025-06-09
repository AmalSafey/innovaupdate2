import 'package:flutter/material.dart';
import 'package:innovahub_app/Custom_Widgets/Stack_listCart.dart';
import 'package:innovahub_app/Custom_Widgets/stack_list.dart';
import 'package:innovahub_app/Custom_Widgets/stack_listHandmade.dart';
import 'package:innovahub_app/Models/product_response.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class HomeScreenCategorysBody extends StatefulWidget {
  final CategoryModel categoryModel;

  const HomeScreenCategorysBody({Key? key, required this.categoryModel})
      : super(key: key);

  @override
  State<HomeScreenCategorysBody> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<HomeScreenCategorysBody> {
  late TextEditingController _nameController;
  late TextEditingController _fromController;
  late TextEditingController _toController;

  late List<ProductResponse> filteredProducts;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _fromController = TextEditingController();
    _toController = TextEditingController();

    filteredProducts = widget.categoryModel.allProducts;

    _nameController.addListener(_searchProducts);
    _fromController.addListener(_searchProducts);
    _toController.addListener(_searchProducts);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _searchProducts() {
    final nameQuery = _nameController.text.toLowerCase();
    final fromPrice = double.tryParse(_fromController.text);
    final toPrice = double.tryParse(_toController.text);

    setState(() {
      filteredProducts = widget.categoryModel.allProducts.where((product) {
        final price = product.price.toDouble();

        final matchesName =
            nameQuery.isEmpty || product.name.toLowerCase().contains(nameQuery);

        final matchesPrice = () {
          if (fromPrice != null && price < fromPrice) return false;
          if (toPrice != null && price > toPrice) return false;
          return true;
        }();

        return matchesName && matchesPrice;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = widget.categoryModel.categoryName;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Constant.mainColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(60),
              ),
            ),
            width: double.infinity,
            height: 220,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        "Search by name",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 30,
                          child: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintStyle: const TextStyle(color: Colors.grey),
                              prefixIcon:
                                  const Icon(Icons.search, color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            // onChanged: (_) => _searchProducts(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Text(
                        "Range From",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      const SizedBox(width: 45),
                      SizedBox(
                        height: 30,
                        width: 80,
                        child: TextField(
                          controller: _fromController,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          // onChanged: (_) => _searchProducts(),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        "to",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        height: 30,
                        width: 80,
                        child: TextField(
                          controller: _toController,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          // onChanged: (_) => _searchProducts(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Center(
            child: Text(
              "Find out more and give us more \n power to complete our journey.",
              style: TextStyle(
                  color: Constant.mainColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          if (filteredProducts.isEmpty)
            const Center(
              child: Text(
                "No matching products found",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          else
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 350,
              width: double.infinity,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filteredProducts.length,
                separatorBuilder: (context, index) => const SizedBox(width: 15),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];

                  if (categoryName == 'Carpets') {
                    return stacklistcart(product: product);
                  } else if (categoryName == 'Necklace' ||
                      categoryName == 'Rings') {
                    return stacklisthandmade(product: product);
                  } else {
                    return stacklist(product: product);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
