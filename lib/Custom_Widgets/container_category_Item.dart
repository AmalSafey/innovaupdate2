
import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Api/Api_Manager_categories.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/Models/Category_Item_response.dart';
import 'package:innovahub_app/home/home_Tap_Categories.dart';

class ContainerCategoryItem extends StatelessWidget {
  const ContainerCategoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 2),
      height: 80,
      width: double.infinity,
      color: Constant.transparentColor,
      child: FutureBuilder<List<CategoryItemResponse>>(
        
        future: ApiManagerCategories.getAllCategoryItems(), // load data from Api:

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // loading data:

            return const Center(
                child: CircularProgressIndicator(
              color: Constant.mainColor,
            ));
          } else if (snapshot.hasError) {
            // if data has error:

            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // Server will response with data or error:

          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // if data is empty:

            return const Center(child: Text("No categories found"));
          }

          // Server has data:

          List<CategoryItemResponse> categoryList =
              snapshot.data!; // store list of category:

          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: categoryList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        HomeScreenCategories.routeName,
                        arguments: categoryList[index],
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      // padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          categoryList[index].categoryName,
                          style: const TextStyle(
                              fontSize: 15, color: Constant.blackColorDark),
                        ),
                      ),
                    ));
              });
        },
      ),
    );
  }
}


