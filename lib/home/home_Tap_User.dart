
import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Api/Api_Manager_categories.dart';
import 'package:innovahub_app/Products/product_page.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/Custom_Widgets/Stack_listCart.dart';
import 'package:innovahub_app/Custom_Widgets/category_card.dart';
import 'package:innovahub_app/Custom_Widgets/container_category_Item.dart';
import 'package:innovahub_app/Custom_Widgets/discount_container.dart';
import 'package:innovahub_app/Custom_Widgets/stack_list.dart';
import 'package:innovahub_app/Custom_Widgets/stack_listHandmade.dart';
import 'package:innovahub_app/Models/Category_response.dart';
import 'package:innovahub_app/Models/product_response.dart';


class HomeScreenUser extends StatelessWidget {
   const HomeScreenUser({super.key,});

  static const String routeName = 'home_user';      // routeName:
  
   //CategoryModel? category ;       // object:

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      
         // mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 6),
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Constant.mainColor,
              child: TextField(
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                  fillColor: Constant.whiteColor,
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Constant.greyColor2,
                  ),
                  hintText: 'Search any Product...',
                  hintStyle:
                      const TextStyle(color: Constant.greyColor2, fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Constant.whiteColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Constant.whiteColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(color: Constant.whiteColor),
                  ),
                ),
              ),
            ),
      
            const Padding(
              padding:  EdgeInsets.only(left: 10,top: 10),
              child:  Text(
                'Categories',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Constant.blueColor),
              ),
            ),
        
            const SizedBox(height: 10),
            const ContainerCategoryItem(),
            const SizedBox(height: 15,),
            const DiscountContainer(),
            const SizedBox(height: 10,),
      
             // display categories:
          FutureBuilder<List<CategoryResponse>>(
          future: ApiManagerCategories.getAllCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
      
              return const Center(child: CircularProgressIndicator(
               color:Constant.mainColor,
              ));
      
            } else if (snapshot.hasError) {
      
              return Center(child: Text("Error: ${snapshot.error}"));
      
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      
              return const Center(child: Text("No categories found"));
            }
       
            // server has data:
             List<CategoryResponse> categoryList = snapshot.data!;
      
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: categoryList.take(3).map((category) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: CategoryCard(category: category),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 10),
      
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: categoryList.skip(3).map((category) {
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: CategoryCard(category: category)
                      );
                    }).toList(),
                  ),
                ],
            );
          },
        ),
      
            const SizedBox(height: 20,),
            
               Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Best Selling Products",
                  style: TextStyle(
                  color: Constant.blackColorDark,
                  fontWeight:FontWeight.w500,
                  fontSize: 18),
                ),
                 
                 //const SizedBox( width: 110,),
                 const Spacer(),
      
                 InkWell(
                  onTap: () {
                    
                   /* Navigator.pushNamed(context, HomeScreenCategories.routeName,
                   // arguments:category,
                    );*/
      
                  },
                   child: const Row(
                     children: [
                       Text(
                        "Show All",
                        style: TextStyle(
                        color: Constant.blueColor,
                        fontWeight:FontWeight.w400,
                        fontSize: 15),
                       ),
                       Icon(Icons.chevron_right,color: Constant.blackColorDark,)
                   
                     ],
                   ),
                 ), 
                 const SizedBox(width: 10,)
               ],
            ),
            
            const SizedBox(height: 20),
      
            // display Bags product:
         FutureBuilder<CategoryModel>(
          future: ApiManagerCategories.getProducts(3),      // loading data:
      
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
      
              return const Center(child: CircularProgressIndicator(color: Constant.mainColor,));
      
            } else if (snapshot.hasError) {
      
              return Center(child: Text("Error: ${snapshot.error}"));
      
            } else if (!snapshot.hasData ) {
      
              return const Center(child: Text("No categories found"));
            }
       
            // server has data:
      
           var products = snapshot.data?.allProducts ?? [];     // get all products;
      
            return Container(
               margin: const EdgeInsets.only(left: 10,right: 15),
               height: 350,
               width: double.infinity,
               child: ListView.separated(
                 itemCount: products.length,
                 scrollDirection: Axis.horizontal,
                 itemBuilder: (context, index) {
      
                   return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ProductPage.routeName,
                      arguments: products[index],);
                    },
                    child: stacklist(product: products[index]));
      
                 },
                 separatorBuilder: (BuildContext context, int index) {
                   return const SizedBox( width: 5, );
      
                 },
               ),
            );
          },
        ),
      
           const SizedBox(height: 20,),
              Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
      
                const Text(
                  "Handcraft Carpets",
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Constant.blackColorDark),
                ),
      
               // const SizedBox( width: 130,),
                 const Spacer(),
      
                   InkWell(
                    onTap: () {
                    // Navigator.pushNamed(context, HomeScreenCategories.routeName,);
                     //arguments:  CategoryItemResponse.localData[21]);
      
                    },
                    child: const Row(
                      children: [
                        Text(
                        "Show All",
                        style: TextStyle(
                        color: Constant.blueColor,
                        fontWeight:FontWeight.w400,
                        fontSize: 15),
                       ),
                      Icon(Icons.chevron_right,color: Constant.blackColorDark,)
                       
                      ],
                    ),
                  ),
                  const SizedBox(width: 10,)
              ],
            ),
        
            const SizedBox(
              height: 20,
            ),
           
           // display carpets products:
         FutureBuilder<CategoryModel>(
          future: ApiManagerCategories.getProducts(12),      // loading data:
      
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
      
              return const Center(child: CircularProgressIndicator(color: Constant.mainColor,));
      
            } else if (snapshot.hasError) {
      
              return Center(child: Text("Error: ${snapshot.error}"));
      
            } else if (!snapshot.hasData ) {
      
              return const Center(child: Text("No categories found"));
            }
       
            // server has data:
      
           var products = snapshot.data?.allProducts ?? [];     // get all products;
      
            return SizedBox(
              height: 350,
              width: double.infinity,
              child: ListView.separated(
                itemBuilder: (context,index){
      
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ProductPage.routeName,
                      arguments: products[index],);
                    },
                    child: stacklistcart(product: products[index]));
      
                } , 
                separatorBuilder:(BuildContext context, int index) {
                    return const SizedBox(width: 5);
                    },
                 itemCount: products.length,
                 scrollDirection: Axis.horizontal,
                 
              ),
            );
          },
        ),
      
      
           const SizedBox(height: 20,),
      
            //Explore other products
             Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Shop Necklaces",
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Constant.blackColorDark),
                ),
                
                //const SizedBox( width: 150,),
                  const Spacer(),
      
      
                 InkWell(
                  onTap: () {
                  },
                   child: const Row(
                     children: [
                       Text(
                        "Show All",
                        style: TextStyle(
                        color: Constant.blueColor,
                        fontWeight:FontWeight.w400,
                        fontSize: 15),
                       ),
                     
                      Icon(Icons.chevron_right,color: Constant.blackColorDark,)
                   
                     ],
                   ),
                 ),
                  const SizedBox(width: 10,)
      
              ],
            ),
        
            const SizedBox(
              height: 20,
            ),
            
          // display Necklace products:
          FutureBuilder<CategoryModel>(
          future: ApiManagerCategories.getProducts(9),      // loading data:
      
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
      
              return const Center(child: CircularProgressIndicator(color: Constant.mainColor,));
      
            } else if (snapshot.hasError) {
      
              return Center(child: Text("Error: ${snapshot.error}"));
      
            } else if (!snapshot.hasData ) {
      
              return const Center(child: Text("No categories found"));
            }
       
            // server has data:
      
           var products = snapshot.data?.allProducts ?? [];     // get all products;
            return Container(
               margin: const EdgeInsets.only(left: 15,right: 15),
               height: 350,
               width: double.infinity,
               child: ListView.separated(
                 itemCount: products.length,
                 scrollDirection: Axis.horizontal,
                 itemBuilder: (context, index) {
      
                   return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ProductPage.routeName,
                      arguments: products[index],);
                    },
                    child: stacklisthandmade(product: products[index],));
      
                 },
                 separatorBuilder: (BuildContext context, int index) {
                   return const SizedBox( width: 15, );
      
                 },
               ),
            );
          },
        ),
           const SizedBox(height: 30,),
      
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Shop Rings",
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Constant.blackColorDark),
                ),
                
                //const SizedBox( width: 150,),
                const Spacer(),
      
                 InkWell(
                  onTap: () {
                  },
                   child: const Row(
                     children: [
                       Text(
                        "Show All",
                        style: TextStyle(
                        color: Constant.blueColor,
                        fontWeight:FontWeight.w400,
                        fontSize: 15),
                        textAlign: TextAlign.end,
                       ),
                     
                      Icon(Icons.chevron_right,color: Constant.blackColorDark,)
                   
                     ],
                   ),
                 ),
                  const SizedBox(width: 10,)
      
              ],
            ),
      
            const SizedBox(height: 20,),
      
         // display Rings products:
          FutureBuilder<CategoryModel>(
          future: ApiManagerCategories.getProducts(13),      // loading data:
      
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
      
              return const Center(child: CircularProgressIndicator(color: Constant.mainColor,));
      
            } else if (snapshot.hasError) {
      
              return Center(child: Text("Error: ${snapshot.error}"));
      
            } else if (!snapshot.hasData ) {
      
              return const Center(child: Text("No categories found"));
            }
       
            // server has data:
      
           var products = snapshot.data?.allProducts ?? [];     // get all products;
      
            return Container(
               margin: const EdgeInsets.only(left: 15,right: 15),
               height: 350,
               width: double.infinity,
               child: ListView.separated(
                 itemCount: products.length,
                 scrollDirection: Axis.horizontal,
                 itemBuilder: (context, index) {
      
                   return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ProductPage.routeName,
                      arguments: products[index],);
                    },
                    child: stacklisthandmade(product: products[index],));
      
                 },
                 separatorBuilder: (BuildContext context, int index) {
                   return const SizedBox( width: 15, );
      
                 },
               ),
            );
          },
        ),
      
          ],
        ),
      );
  }
}