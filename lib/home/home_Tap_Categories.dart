
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Api/Api_Manager_categories.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/Models/Category_Item_response.dart';
import 'package:innovahub_app/Models/product_response.dart';
import 'package:innovahub_app/home/widget/home_screen_categoys_body.dart';

class HomeScreenCategories extends StatefulWidget {
  const HomeScreenCategories({super.key});

  static const String routeName = 'categories';    // routeName:
   //CategoryItemResponse? category;


  @override
  State<HomeScreenCategories> createState() => _HomeScreenInvestorState();
}

class _HomeScreenInvestorState extends State<HomeScreenCategories> {
  int select = 0;

  @override
  Widget build(BuildContext context) {
    
    var arguments = ModalRoute.of(context)!.settings.arguments as CategoryItemResponse;     // receive data:

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
       /*eading:IconButton(
          onPressed:() {
            
            Navigator.pop(context);

          }, icon: Icon(Icons.arrow_back),
          ),*/
        title: const Text(
          'Innova',
          style: TextStyle(
              color: Constant.blackColorDark,
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 24,
              backgroundImage:
                  AssetImage('assets/images/image-13.png'), // ضع الصورة هنا
            ),
          ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.white),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_filled,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite_border_outlined,
              ),
              label: "Wishlist",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart_outlined,
              ),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search_outlined,
              ),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
              ),
              label: "Profile",
            ),
          ],
          currentIndex: select,
          onTap: (index) {
            select = index;
            setState(() {});
          },
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          selectedLabelStyle: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      
      body: FutureBuilder<CategoryModel>(
        future: ApiManagerCategories.getProducts(arguments.categoryId),
        builder: (context,snapshot) {
          log(snapshot.connectionState.toString());
          if(snapshot.connectionState == ConnectionState.waiting){

            return const Center(child: CircularProgressIndicator(
              color:Constant.mainColor,
            ));
          }else if(snapshot.hasError){

            return Center(child: Text("Error: ${snapshot.error}"));
          }else if (snapshot.connectionState == ConnectionState.done){
            log(snapshot.data.toString());
              return HomeScreenCategorysBody(categoryModel: snapshot.data!,);         // body:
      
          }else {
            return Container();
          }
        }
      ),
    );
  }
}

