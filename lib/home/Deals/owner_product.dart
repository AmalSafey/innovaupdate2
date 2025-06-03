
/*import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multiselect/multiselect.dart';*/

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:innovahub_app/Custom_Widgets/Custom_Dropdownmenue.dart';
import 'package:innovahub_app/Custom_Widgets/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class OwnerPublish extends StatefulWidget {
  const OwnerPublish({Key? key}) : super(key: key);

  static const String routeName = 'owner_publish';

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<OwnerPublish> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController categoryIdController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController dimensionsController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController sizeNamesController = TextEditingController();
  TextEditingController colorNamesController = TextEditingController();
  File? _image1;
  File? _image2;
  File? _image3;
  final _formKey = GlobalKey<FormState>();

  File? homePicture;
  List<File> pictures = [];
  Set<String> selectedColors = {};

  final picker = ImagePicker();

  Future<void> pickHomePicture() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        homePicture = File(pickedFile.path);
      });

      print("✅ Home picture selected: ${homePicture!.path}");
    } else {
      print("⚠ No image selected");
    }
  }

  // اختيار صور إضافية
  Future<void> pickOtherPicture(int imageNumber) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        switch (imageNumber) {
          case 2:
            _image2 = File(pickedFile.path);
            break;
          case 3:
            _image3 = File(pickedFile.path);
            break;
        }
      });

      print("✅ Image $imageNumber selected: ${pickedFile.path}");
    } else {
      print("⚠ No image selected for $imageNumber");
    }
  }

  Future<void> _pickImage(int imageNumber) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (imageNumber == 1) {
          _image1 = File(pickedFile.path);
        } else if (imageNumber == 2) {
          _image2 = File(pickedFile.path);
        } else if (imageNumber == 3) {
          _image3 = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> addProduct() async {
    if (!_formKey.currentState!.validate()) {
      showErrorMessage("Please fill all required fields.");
      return;
    }

    if (homePicture == null || !homePicture!.existsSync()) {
      showErrorMessage("Please select a home picture.");
      print("DEBUG: No home picture selected.");
      return;
    }

    if (_image2 == null && _image3 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠ Please select at least one additional photo."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        throw Exception("User is not authenticated!");
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://innova-hub.premiumasp.net/api/Product"),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      request.fields['ProductName'] = productNameController.text;
      request.fields['Description'] = descriptionController.text;
      request.fields['Price'] = priceController.text;
      request.fields['Discount'] = discountController.text;
      request.fields['CategoryId'] = categoryIdController.text;
      request.fields['Stock'] = stockController.text;
      request.fields['Dimensions'] = dimensionsController.text;
      request.fields['Weight'] = weightController.text;
      request.fields['SizeNames'] = sizeNamesController.text;
      request.fields['ColorNames'] = colorNamesController.text;

      request.files.add(
          await http.MultipartFile.fromPath('HomePicture', homePicture!.path));

      // ✅ Only add additional images if they are not null
      if (_image2 != null) {
        request.files
            .add(await http.MultipartFile.fromPath('Pictures', _image2!.path));
      }

      if (_image3 != null) {
        request.files
            .add(await http.MultipartFile.fromPath('Pictures', _image3!.path));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var decodedResponse = jsonDecode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product added successfully!")),
        );
      } else {
        var errorMessage = decodedResponse['errors']?['Pictures']?.first ??
            decodedResponse['Message'] ??
            "Unknown error occurred";

        print("❌ Server Error: $errorMessage");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $errorMessage")),
        );
      }
    } catch (e) {
      print("❌ Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: $e")),
      );
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Publish Your Product",
          style: TextStyle(fontSize: 18, color: Constant.blackColorDark),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(
              Icons.close,
              color: Colors.red,
              size: 25,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Product Name : ",
                      style: TextStyle(
                          fontSize: 16,
                          color: Constant.mainColor,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 230,
                      height: 30,
                      child: CustomTextField(controller: productNameController),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Product Category : ",
                      style: TextStyle(
                          fontSize: 16,
                          color: Constant.mainColor,
                          fontWeight: FontWeight.w500),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Constant.white4Color,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: 50,
                      width: 200,
                      child: dropdownmenueforcatregory(
                        categoryIdController: categoryIdController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Description : ",
                      style: TextStyle(
                          fontSize: 16,
                          color: Constant.mainColor,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 230,
                      height: 100,
                      child: CustomTextField(
                        controller: descriptionController,
                        maxLines: 5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Price : ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Constant.mainColor,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 170,
                          height: 30,
                          child: CustomTextField(controller: priceController),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Discount : ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Constant.mainColor,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 170,
                          height: 30,
                          child:
                              CustomTextField(controller: discountController),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Weight (Kg): ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Constant.mainColor,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 170,
                          height: 30,
                          child: CustomTextField(controller: weightController),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Dimensions(L×W×H) : ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Constant.mainColor,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 170,
                          height: 30,
                          child:
                              CustomTextField(controller: dimensionsController),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  children: [
                    Text(
                      "Availability",
                      style: TextStyle(
                          fontSize: 16,
                          color: Constant.mainColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Color : ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Constant.mainColor,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Constant.white4Color,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Constant.white4Color,
                            ),
                          ),
                          height: 40,
                          width: 170,
                          child: DropdownMenuForcolor(
                            colorNamesController: colorNamesController,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Size : ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Constant.mainColor,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Constant.white4Color,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Constant.white4Color,
                            ),
                          ),
                          height: 40,
                          width: 170,
                          child: DropdownMenuForsize(
                            sizeNamesController: sizeNamesController,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Stock Availability : ",
                      style: TextStyle(
                          fontSize: 16,
                          color: Constant.mainColor,
                          fontWeight: FontWeight.w500),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 30,
                        child: CustomTextField(controller: stockController),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => pickHomePicture(),
                      child: Container(
                        width: 200,
                        height: 270,
                        decoration: BoxDecoration(
                          color: Constant.white4Color,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: homePicture != null
                            ? Image.file(homePicture!, fit: BoxFit.cover)
                            : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.file_upload, size: 30,color: Constant.blackColorDark,),
                                   Text(
                                    "Home Picture",
                                    style: TextStyle(fontSize: 16,color: Constant.blackColorDark),
                                  ),
                                ],
                              ),
                      ),
                    ),
                     Column(
                       children: [
                         GestureDetector(
                              onTap: () => pickOtherPicture(2),
                              child: Container(
                                width: 140,
                                height: 130,
                                decoration: BoxDecoration(
                                  color: Constant.white4Color,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: _image2 != null
                                    ? Image.file(_image2!, fit: BoxFit.cover)
                                    : const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                  Icon(Icons.file_upload, size: 30,color: Constant.blackColorDark,),
                                   Text(
                                    "Other Pictures",
                                    style: TextStyle(fontSize: 15,color: Constant.blackColorDark),
                                  ),
                                ],
                              ),
                              ),
                            ),
                             const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => pickOtherPicture(3),
                          child: Container(
                            width: 140,
                            height: 130,
                            decoration: BoxDecoration(
                              color: Constant.white4Color,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: _image3 != null
                                ? Image.file(_image3!, fit: BoxFit.cover)
                                : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.file_upload, size: 30,color: Constant.blackColorDark,),
                                   Text(
                                    "Other Pictures",
                                    style: TextStyle(fontSize: 15,color: Constant.blackColorDark),
                                  ),
                                ],
                              ),
                          ),
                        ),
                       ],
                     ),

                  ],
                ),
                
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      addProduct();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.green2Color,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Publish Deal',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}






/*class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  static const String routeName = 'owner_product';

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController categoryIdController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController dimensionsController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController sizeNamesController = TextEditingController();
  TextEditingController colorNamesController = TextEditingController();
  File? _image1;
  File? _image2;
  File? _image3;
  final _formKey = GlobalKey<FormState>();

  File? homePicture;
  List<File> pictures = [];
  Set<String> selectedColors = {};

  final picker = ImagePicker();

  Future<void> pickHomePicture() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        homePicture = File(pickedFile.path);
      });
    }
  }

  // اختيار صور إضافية
  Future<void> pickPictures() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        pictures = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<void> _pickImage(int imageNumber) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (imageNumber == 1) {
          _image1 = File(pickedFile.path);
        } else if (imageNumber == 2) {
          _image2 = File(pickedFile.path);
        } else if (imageNumber == 3) {
          _image3 = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> addProduct() async {
    if (!_formKey.currentState!.validate() || homePicture == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("Please fill all required fields and select images.")),
      );
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        throw Exception("User is not authenticated!");
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://innova-hub.premiumasp.net/api/Product"),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      request.fields['ProductName'] = productNameController.text;
      request.fields['Description'] = descriptionController.text;
      request.fields['Price'] = priceController.text;
      request.fields['Discount'] = discountController.text;
      request.fields['CategoryId'] = categoryIdController.text;
      request.fields['Stock'] = stockController.text;
      request.fields['Dimensions'] = dimensionsController.text;
      request.fields['Weight'] = weightController.text;
      request.fields['SizeNames'] = sizeNamesController.text;
      request.fields['ColorNames'] = colorNamesController.text;

      request.files.add(
          await http.MultipartFile.fromPath('HomePicture', homePicture!.path));

      for (var picture in pictures) {
        request.files
            .add(await http.MultipartFile.fromPath('Pictures', picture.path));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var decodedResponse = jsonDecode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product added successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${decodedResponse['Message']}")),
        );
      }
    } catch (e) {
      print("Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Publish Your Product",
            style: TextStyle(fontSize: 18.sp),
          ),
          actions: [
            Icon(
              Icons.close,
              color: Colors.red,
              size: 25.r,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ).r,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Product Name : ",
                        style: TextStyle(fontSize: 16.sp, color: Colors.teal),
                      ),
                      SizedBox(
                          width: 230.r,
                          height: 30.r,
                          child: const CustomTextField())
                    ],
                  ),
                  SizedBox(
                    height: 20.r,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Product Category : ",
                        style: TextStyle(fontSize: 16, color: Colors.teal),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Constant.white4Color,
                              borderRadius: BorderRadius.circular(5)),
                          height: 50.r,
                          width: 200.r,
                          child: dropdownmenueforcatregory(
                            categoryIdController: categoryIdController,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 20.r,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Description : ",
                        style: TextStyle(fontSize: 16, color: Colors.teal),
                      ),
                      SizedBox(
                          width: 230.r,
                          height: 100.r,
                          child: const CustomTextField(
                            maxLines: 5,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 10.r,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Price : ",
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.teal),
                          ),
                          SizedBox(
                            height: 5.r,
                          ),
                          SizedBox(
                              width: 170.r,
                              height: 30.r,
                              child: const CustomTextField())
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Discount : ",
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.teal),
                          ),
                          SizedBox(
                            height: 5.r,
                          ),
                          SizedBox(
                              width: 170.r,
                              height: 30.r,
                              child: const CustomTextField())
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.r,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Wight (Kg): ",
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.teal),
                          ),
                          SizedBox(
                            height: 5.r,
                          ),
                          SizedBox(
                              width: 170.r,
                              height: 30.r,
                              child: const CustomTextField())
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dimentions(L×W×H) : ",
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.teal),
                          ),
                          SizedBox(
                            height: 5.r,
                          ),
                          SizedBox(
                              width: 170.r,
                              height: 30.r,
                              child: const CustomTextField())
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.r,
                  ),
                  Row(
                    children: [
                      Text(
                        "Availability",
                        style: TextStyle(fontSize: 16.sp, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.r,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Color : ",
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.teal),
                          ),
                          SizedBox(
                            height: 5.r,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: Constant.white4Color, //
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Constant.white4Color,
                                ),
                              ),
                              height: 40.r,
                              width: 170.r,
                              child: DropdownMenuForcolor(
                                selectedColors: selectedColors,
                              ))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Size : ",
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.teal),
                          ),
                          SizedBox(
                            height: 5.r,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: Constant.white4Color, //
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Constant.white4Color,
                                ),
                              ),
                              height: 40.r,
                              width: 170.r,
                              child: const DropdownMenuForsize())
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.r,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Stock Availability : ",
                        style: TextStyle(fontSize: 16.sp, color: Colors.teal),
                      ),
                      Expanded(
                          child: SizedBox(
                              height: 30.r, child: const CustomTextField()))
                    ],
                  ),
                  SizedBox(
                    height: 20.r,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Home Picture",
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.teal)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildImagePicker(1, _image1, isLarge: true),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Other Picture",
                            style: TextStyle(fontSize: 16, color: Colors.teal)),
                        Column(
                          children: [
                            _buildImagePicker(2, _image2),
                            const SizedBox(height: 15),
                            _buildImagePicker(3, _image3),
                          ],
                        ),
                      ]),
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        addProduct();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constant.green2Color,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Publish Deal',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildImagePicker(int imageNumber, File? image,
      {bool isLarge = false}) {
    return GestureDetector(
      onTap: () => _pickImage(imageNumber),
      child: Container(
        clipBehavior: Clip.antiAlias,
        width: isLarge ? 200 : 130,
        height: isLarge ? 270 : 130,
        decoration: BoxDecoration(
            color: Constant.white4Color,
            borderRadius: BorderRadius.circular(15)),
        child: image != null
            ? Image.file(image, fit: BoxFit.cover)
            : Icon(Icons.file_upload, size: isLarge ? 30 : 20),
      ),
    );
  }
  }
  

class CustomTextField extends StatelessWidget {
  final int maxLines;

  const CustomTextField({super.key, this.maxLines = 1});
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.black),
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Constant.white4Color,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Constant.white4Color),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Constant.white4Color),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Constant.white4Color, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
    );
  }
}

class dropdownmenueforcatregory extends StatefulWidget {
  final TextEditingController categoryIdController;
  const dropdownmenueforcatregory(
      {super.key, required this.categoryIdController});

  @override
  State<dropdownmenueforcatregory> createState() =>
      _dropdownmenueforcatregoryState();
}

class _dropdownmenueforcatregoryState extends State<dropdownmenueforcatregory> {
  String? dropdownvalue;

  final List<Map<String, dynamic>> categories = [
    {"CategoryId": 1, "CategoryName": "Carpets"},
    {"CategoryId": 2, "CategoryName": "Home"},
    {"CategoryId": 3, "CategoryName": "Bags"},
    {"CategoryId": 4, "CategoryName": "Jewelry"},
    {"CategoryId": 5, "CategoryName": "Art"},
    {"CategoryId": 6, "CategoryName": "Men"},
    {"CategoryId": 7, "CategoryName": "Watches"},
    {"CategoryId": 8, "CategoryName": "Drawing"},
    {"CategoryId": 9, "CategoryName": "Necklace"},
    {"CategoryId": 10, "CategoryName": "Wood Crafting"},
    {"CategoryId": 11, "CategoryName": "Toys"},
    {"CategoryId": 12, "CategoryName": "Carpets"},
    {"CategoryId": 13, "CategoryName": "Rings"},
    {"CategoryId": 14, "CategoryName": "Furniture"},
    {"CategoryId": 15, "CategoryName": "Laptops"},
  ];
  String? selectedCategoryName;
  int? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Select Category',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      value: selectedCategoryName,
      items: categories.map((category) {
        return DropdownMenuItem<String>(
          value: category['CategoryName'],
          child: Text(category['CategoryName']),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedCategoryName = newValue;
          selectedCategoryId = categories.firstWhere(
            (category) => category['CategoryName'] == newValue,
          )['CategoryId'];

          // تحديث قيمة الـ Controller بالـ CategoryId
          widget.categoryIdController.text = selectedCategoryId.toString();
        });
      },
    );
  }
}

class DropdownMenuForcolor extends StatefulWidget {
  Set<String> selectedColors;
  DropdownMenuForcolor({
    Key? key,
    required this.selectedColors,
  }) : super(key: key);

  @override
  State<DropdownMenuForcolor> createState() => _DropdownMenuForcolorState();
}

class _DropdownMenuForcolorState extends State<DropdownMenuForcolor> {
  final List<String> colorOptions = [
    "Red",
    "Green",
    "Yellow",
    "Blue",
    "Black",
    "White"
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropDownMultiSelect(
            options: colorOptions,
            selectedValues: widget.selectedColors.toList(),
            whenEmpty: widget.selectedColors.isEmpty
                ? ""
                : widget.selectedColors.join(" | "),
            onChanged: (List<String> values) {
              setState(() {
                widget.selectedColors = values.toSet();
              });
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class DropdownMenuForsize extends StatefulWidget {
  const DropdownMenuForsize({super.key});

  @override
  State<DropdownMenuForsize> createState() => _DropdownMenuForsizeState();
}

class _DropdownMenuForsizeState extends State<DropdownMenuForsize> {
  List<String> selectedColors = [];

  final List<String> colorOptions = [
    "-",
    "S",
    "M",
    "L",
    "XL",
    "XXL",
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropDownMultiSelect(
            // selectedValuesStyle: TextStyle(  color: Colors.black, ),
            options: colorOptions,
            selectedValues: selectedColors,
            whenEmpty: '', //
            // separator: " | ", // ✅
            onChanged: (List<String> values) {
              setState(() {
                selectedColors = values;
              });
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
          ),
        ),
      ],
    );
  }
}*/

