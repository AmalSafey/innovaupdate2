import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/Custom_Widgets/Stack_listCart.dart';
import 'package:innovahub_app/Custom_Widgets/stack_list.dart';
import 'package:innovahub_app/Custom_Widgets/stack_listHandmade.dart';
import 'package:innovahub_app/Models/product_response.dart';
import 'package:innovahub_app/home/widget/custom_search_bar.dart';
import 'package:innovahub_app/home/widget/search_container.dart';
import 'package:innovahub_app/home/widget/title_and_description.dart';

class HomeScreenCategorysBody extends StatelessWidget {
  final CategoryModel categoryModel; // object:

  const HomeScreenCategorysBody({
    super.key,
    required this.categoryModel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomSearchBar(),
          const SizedBox(
            height: 25,
          ),
          TitleAndDescription(
            description: categoryModel.categoryDescription,
            title: categoryModel.categoryName,
          ),
          SearchContainer(),
          const SizedBox(
            height: 20,
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
            height: 20,
          ),

          /*Container(
            height: 500,
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,       // Number of columns in the grid
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 4,   // Aspect ratio of each grid item
              )
              ,
              itemCount: categoryModel.allProducts.length, // Total number of items in the grid
              itemBuilder: (context, index) {
                //return stacklisthandmade(product: categoryModel.allProducts[index],);
                return stacklistcart(product:categoryModel.allProducts[index] ,);
              },
            ),
          ),*/

          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            height: 350,
            width: double.infinity,
            child: ListView.separated(
              itemBuilder: (context, index) {
                if (categoryModel.categoryName == 'Carpets') {
                  return stacklistcart(
                    product: categoryModel.allProducts[index],
                  );
                } else if (categoryModel.categoryName == 'Necklace' ||
                    categoryModel.categoryName == 'Rings') {
                  return stacklisthandmade(
                    product: categoryModel.allProducts[index],
                  );
                } else if (categoryModel.categoryName == 'Bags') {
                  return stacklist(product: categoryModel.allProducts[index]);
                }
                // if click any item:
                return stacklist(product: categoryModel.allProducts[index]);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(width: 15);
              },
              itemCount: categoryModel.allProducts.length,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }
}
