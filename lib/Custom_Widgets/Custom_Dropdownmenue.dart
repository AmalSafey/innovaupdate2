

import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

// ignore: camel_case_types
class dropdownmenueforcatregory extends StatefulWidget {
  final TextEditingController categoryIdController;
  const dropdownmenueforcatregory(
      {super.key, required this.categoryIdController});

  @override
  State<dropdownmenueforcatregory> createState() =>
      _dropdownmenueforcatregoryState();
}

// ignore: camel_case_types
class _dropdownmenueforcatregoryState extends State<dropdownmenueforcatregory> {
  String? selectedCategoryName;
  int? selectedCategoryId;

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
    {"CategoryId": 12, "CategoryName": "Rings"},
    {"CategoryId": 13, "CategoryName": "Furniture"},
    {"CategoryId": 14, "CategoryName": "Laptops"},
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        border: InputBorder.none,
        //labelText: 'Select Category',
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), ),
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
          // البحث عن الـ CategoryId المرتبط بـ CategoryName
          selectedCategoryId = categories.firstWhere(
            (category) => category['CategoryName'] == newValue,
            orElse: () =>
                {"CategoryId": null}, // تجنب الخطأ إذا لم يتم العثور على الفئة
          )['CategoryId'];

          // تحديث TextEditingController بالـ CategoryId الصحيح
          widget.categoryIdController.text =
              selectedCategoryId?.toString() ?? "";

          // طباعة القيم للتأكد
          print(
              "Selected Category:$selectedCategoryName, ID: $selectedCategoryId");
        });
      },
    );
  }
}

class DropdownMenuForcolor extends StatefulWidget {
  final TextEditingController colorNamesController; // ✅ تمرير الكنترولر

  const DropdownMenuForcolor({Key? key, required this.colorNamesController})
      : super(key: key);

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
    "White",
    "-"
  ];
  List<String> selectedColors = []; // ✅ تخزين القيم المختارة

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropDownMultiSelect(
            options: colorOptions,
            selectedValues: selectedColors,
            whenEmpty: 'Select color',
            onChanged: (List<String> values) {
              setState(() {
                selectedColors = values;
                widget.colorNamesController.text =
                    selectedColors.join(", "); // ✅ تحديث الكنترولر
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
  final TextEditingController sizeNamesController; // ✅ تمرير الكنترولر

  const DropdownMenuForsize({super.key, required this.sizeNamesController});

  @override
  State<DropdownMenuForsize> createState() => _DropdownMenuForsizeState();
}

class _DropdownMenuForsizeState extends State<DropdownMenuForsize> {
  final List<String> sizeOptions = ["S", "M", "L", "XL", "XXL", "-"];
  List<String> selectedSizes = []; // ✅ تخزين القيم المختارة

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropDownMultiSelect(
            options: sizeOptions,
            selectedValues: selectedSizes,
            whenEmpty: 'Select size',
            onChanged: (List<String> values) {
              setState(() {
                selectedSizes = values;
                widget.sizeNamesController.text =
                    selectedSizes.join(", "); // ✅ تحديث الكنترولر
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


