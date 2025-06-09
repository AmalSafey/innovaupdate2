import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:innovahub_app/Models/Deals/Deal_Model.dart';
import 'package:innovahub_app/core/Api/Api_Manager_deals.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class PublishDealScreen extends StatefulWidget {
  const PublishDealScreen({super.key});

  static const String routeName =
      'adding_deal_owner'; // route name of this screen:

  @override
  // ignore: library_private_types_in_public_api
  _PublishDealScreenState createState() => _PublishDealScreenState();
}

class _PublishDealScreenState extends State<PublishDealScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessTypeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController offerMoneyController = TextEditingController();
  final TextEditingController offerDealController = TextEditingController();
  final TextEditingController manufacturingController = TextEditingController();
  final TextEditingController estimatedPriceController =
      TextEditingController();
  File? _image1;
  File? _image2;
  File? _image3;

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

  // to publish the deal:
  Future<void> publishDeal() async {
    if (!_formKey.currentState!.validate()) {
      return; // stop the fuction if the form is not valid:
    }
    DealModel deal = DealModel(
      businessName: businessNameController.text,
      description: descriptionController.text,
      offerMoney: offerMoneyController.text,
      offerDeal: offerDealController.text,
      manufacturingCost: manufacturingController.text,
      estimatedPrice: estimatedPriceController.text,
      categoryId: 16,
    );

    List<File?> images = [_image1, _image2, _image3]; // list of images:

    String result = await ApiManagerDeals.addDeal(deal, images);

    /*ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(result)),
  );*/
    if (result.toLowerCase().contains("success")) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Thank’s For your Deal\nWait for Admin Approval',
        confirmBtnText: 'OK',
        onConfirmBtnTap: () {
          Navigator.pop(context); // to close alert:
          Navigator.pop(context); // to close this screen:
        },
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: result,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.whiteColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                color: Constant.mainColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Publish Deal',
                      style: TextStyle(
                        fontSize: 16,
                        color: Constant.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Constant.whiteColor,
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabeledTextField(
                        'Business name', businessNameController),
                    _buildLabeledTextField(
                        'Business type', businessTypeController),
                    _buildLabeledTextField('Description', descriptionController,
                        maxLines: 3),
                    _buildLabeledTextField('Offer Money', offerMoneyController),
                    _buildLabeledTextField('Offer Deal', offerDealController),
                    _buildLabeledTextField(
                        'Manufacturing', manufacturingController),
                    _buildLabeledTextField(
                        'Estimated Price', estimatedPriceController),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildImagePicker(1, _image1, isLarge: true),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            _buildImagePicker(2, _image2),
                            const SizedBox(height: 15),
                            _buildImagePicker(3, _image3),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          publishDeal(); // call Function to publish deal:
                          //Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constant.mainColor,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          'Publish Deal',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style:
                  const TextStyle(fontSize: 16, color: Constant.blackColorDark),
            ),
          ),
          Expanded(
            flex: 5,
            child: TextFormField(
              controller: controller,
              maxLines: maxLines,
              decoration: InputDecoration(
                filled: true,
                fillColor: Constant.whiteColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Constant.greyColor4, 
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Constant.greyColor4,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "$label is required";
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
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
            color: Constant.whiteColor,
            border: Border.all(
              color: Constant.greyColor2,
            ),
            borderRadius: BorderRadius.circular(15)),
        child: image != null
            ? Image.file(image, fit: BoxFit.cover)
            : Icon(Icons.file_upload, size: isLarge ? 30 : 20),
      ),
    );
  }
}
