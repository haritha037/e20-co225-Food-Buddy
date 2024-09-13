import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_buddy_frontend/controllers/category_controller.dart';
import 'package:food_buddy_frontend/controllers/product_controller.dart';
import 'package:food_buddy_frontend/models/api_response.dart';
import 'package:food_buddy_frontend/models/categories.dart';
import 'package:food_buddy_frontend/models/create_product_body.dart';
import 'package:food_buddy_frontend/models/products.dart';
import 'package:food_buddy_frontend/utils/app_constants.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/app_text_field.dart';
import 'package:food_buddy_frontend/widgets/big_text.dart';
import 'package:food_buddy_frontend/widgets/custom_snackbar.dart';
import 'package:food_buddy_frontend/widgets/loading_indicator.dart';
import 'package:food_buddy_frontend/widgets/small_text.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UpdateProductPage extends StatefulWidget {
  final Product product;
  const UpdateProductPage({super.key, required this.product});

  @override
  State<UpdateProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<UpdateProductPage> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isButtonDisabled = false;
  final List<Category> _categories =
      Get.find<CategoryController>().categoriesList;
  late Category _selectedCategory;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late String validUntil;

  late TextEditingController _productNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _originalPriceController;
  late TextEditingController _discountedPriceController;
  late TextEditingController _quantityController;

  void _disableButton() {
    setState(() {
      _isButtonDisabled = true;
    });
  }

  @override
  void initState() {
    super.initState();

    Product product = widget.product;

    _productNameController = TextEditingController(text: product.productName);
    _descriptionController = TextEditingController(text: product.description);
    _originalPriceController =
        TextEditingController(text: product.originalPrice.toString());
    _discountedPriceController =
        TextEditingController(text: product.discountedPrice.toString());
    _quantityController =
        TextEditingController(text: product.quantity.toString());

    _selectedCategory = _categories
        .firstWhere((category) => category.categoryId == product.categoryId);

    validUntil = product.validUntil;

    _selectedDate = validUntilStringToDateTime(validUntil);
    _selectedTime =
        TimeOfDay(hour: _selectedDate.hour, minute: _selectedDate.minute);
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.dispose();
    _originalPriceController.dispose();
    _discountedPriceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _takePhoto(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    setState(() {
      _imageFile = image;
    });
  }

  void _setValidUntilDateTimeString() {
    DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");

    DateTime dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    validUntil = dateFormat.format(dateTime);
  }

  DateTime validUntilStringToDateTime(String date) {
    DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");

    return dateFormat.parse(date);
  }

  Future<void> _addProduct() async {
    Product product = widget.product;
    _hideKeyboard();

    String productName = _productNameController.text.trim();
    String description = _descriptionController.text.trim();
    String originalPrice = _originalPriceController.text.trim();
    String discountedPrice = _discountedPriceController.text.trim();
    String quantity = _quantityController.text.trim();

    if (_validateInputs(
        productName, description, originalPrice, discountedPrice, quantity)) {
      _disableButton();
      print('Inputs are valid');

      _setValidUntilDateTimeString();

      print('valid until text - $validUntil');

      CreateProductBody createProductBody = CreateProductBody(
        productName: productName,
        description: description,
        originalPrice: double.parse(originalPrice),
        discountedPrice: double.parse(discountedPrice),
        quantity: int.parse(quantity),
        validUntil: validUntil,
        categoryId: _selectedCategory.categoryId,
      );

      ApiResponse productResponse = await Get.find<ProductController>()
          .updateProduct(createProductBody, product, _imageFile);
      if (productResponse.status == true) {
        showCustomSnackBar(productResponse.message,
            isError: false, title: 'Success');
        print('Product updated successfully');
        Navigator.pop(context);
      } else {
        showCustomSnackBar(productResponse.message, isError: true);
      }
    } else {
      print('Invalid inputs');
    }
  }

  void _showBottomSheetForImage() {
    _hideKeyboard();
    Get.bottomSheet(
      Container(
        height: 200 * Dimentions.hUnit,
        width: Dimentions.screenWidth,
        padding: EdgeInsets.symmetric(
          horizontal: 40 * Dimentions.hUnit,
          vertical: 20 * Dimentions.hUnit,
        ),
        child: Column(
          children: [
            BigText(text: 'Choose product image'),
            SizedBox(height: 20 * Dimentions.hUnit),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //
                // CAMERA
                InkWell(
                  onTap: () {
                    _takePhoto(ImageSource.camera);
                    Get.back();
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.camera,
                        size: 60 * Dimentions.hUnit,
                        color: AppColors.pinkColor,
                      ),
                      BigText(
                        text: 'camera',
                        color: AppColors.pinkColor,
                      ),
                    ],
                  ),
                ),
                //
                // GALLERY
                InkWell(
                  onTap: () {
                    _takePhoto(ImageSource.gallery);
                    Get.back();
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 60 * Dimentions.hUnit,
                        color: AppColors.lightBlueColor,
                      ),
                      BigText(
                        text: 'Gallery',
                        color: AppColors.lightBlueColor,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  bool _validateInputs(
    String productName,
    String description,
    String originalPrice,
    String discountedPrice,
    String quantity,
  ) {
    if (productName.isEmpty) {
      showCustomSnackBar(
        'Type in the product name',
        title: 'Product name',
        isError: false,
      );
      return false;
    } else if (description.isEmpty) {
      showCustomSnackBar(
        'Type in the description',
        title: 'Description',
        isError: false,
      );
      return false;
    } else if (originalPrice.isEmpty) {
      showCustomSnackBar(
        'Type in the original price',
        title: 'Original price',
        isError: false,
      );
      return false;
    } else if (discountedPrice.isEmpty) {
      showCustomSnackBar(
        'Type in the discounted price',
        title: 'Discounted price',
        isError: false,
      );
      return false;
    } else if (quantity.isEmpty) {
      showCustomSnackBar(
        'Type in the quantity',
        title: 'Quantity',
        isError: false,
      );
      return false;
    } else if (!_selectedDate.isAfter(DateTime.now())) {
      showCustomSnackBar(
        'Select a future date',
        title: 'Date',
        isError: false,
      );
      return false;
    } else if (productName.length > 30) {
      showCustomSnackBar(
        'Product name is too long',
        title: 'Product name',
        isError: false,
      );
      return false;
    } else if (description.length > 255) {
      showCustomSnackBar(
        'Product description is too long',
        title: 'Product description',
        isError: false,
      );
      return false;
    } else if (!GetUtils.isNum(originalPrice) ||
        !GetUtils.isNum(originalPrice) ||
        !GetUtils.isNum(originalPrice)) {
      showCustomSnackBar(
        'Invalid price',
        title: 'Price',
        isError: true,
      );
      return false;
    } else if (double.parse(originalPrice) <= double.parse(discountedPrice)) {
      showCustomSnackBar(
        'Discounted price must be lower than the original price',
        title: 'Discount',
        isError: true,
      );
      return false;
    } else if (double.parse(originalPrice) > 10000) {
      showCustomSnackBar(
        'Maximum unit price is Rs. 10 000',
        title: 'Price',
        isError: true,
      );
      return false;
    } else if (!GetUtils.isNumericOnly(quantity)) {
      showCustomSnackBar(
        'Invalid quantity',
        title: 'Quantity',
        isError: true,
      );
      return false;
    }
    return true;
  }

  void _showDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime.now();
    final lastDate = DateTime(now.year, now.month, now.day + 7);
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      initialDate: firstDate,
      lastDate: lastDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    setState(() {
      _selectedDate = pickedDate ?? pickedDate!;
      _hideKeyboard();
    });
  }

  Future<void> _showTimePicker() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    setState(() {
      _selectedTime = pickedTime ?? pickedTime!;
      _hideKeyboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    Product product = widget.product;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: BouncingScrollPhysics(),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20 * Dimentions.hUnit),
              child: Column(
                children: [
                  SizedBox(height: 40 * Dimentions.hUnit),
                  //
                  // PRODUCT IMAGE
                  Center(
                    child: Stack(
                      children: [
                        //
                        // PRODUCT IMAGE + ICON
                        CircleAvatar(
                          backgroundImage: _imageFile != null
                              ? FileImage(File(_imageFile!.path))
                              // : AssetImage('assets/images/default-product.jpg'),
                              : NetworkImage(
                                  AppConstants.BASE_URL +
                                      AppConstants.PRODUCT_IMAGE_URI +
                                      product.image,
                                ),
                          radius: 100 * Dimentions.hUnit,
                        ),
                        Positioned(
                          bottom: 10 * Dimentions.hUnit,
                          right: 10 * Dimentions.hUnit,
                          child: InkWell(
                            onTap: () {
                              _showBottomSheetForImage();
                            },
                            child: Icon(
                              Icons.camera_alt,
                              color: AppColors.mainColor,
                              size: 30 * Dimentions.hUnit,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30 * Dimentions.hUnit),
                  //
                  // NAME + CATEGORY ROW
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //
                      // PRODUCT NAME
                      Container(
                        width: 180 * Dimentions.hUnit,
                        child: AppTextField(
                          label: 'Product Name',
                          controller: _productNameController,
                          iconColor: AppColors.mainColor,
                          hintText: 'Product name',
                          icon: Icons.fastfood_outlined,
                        ),
                      ),
                      Spacer(),
                      //
                      // CATEGORY DROP DOWN BUTTON
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10 * Dimentions.hUnit,
                          vertical: 5 * Dimentions.hUnit,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(10 * Dimentions.hUnit),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 10,
                                // spreadRadius: 5,
                                offset: const Offset(0, 5))
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.category,
                              color: AppColors.mainColor,
                            ),
                            SizedBox(width: 10 * Dimentions.hUnit),
                            DropdownButton<Category>(
                              borderRadius:
                                  BorderRadius.circular(10 * Dimentions.hUnit),
                              dropdownColor: Colors.white,
                              //padding: EdgeInsets.all(10 * Dimentions.hUnit),

                              hint: BigText(
                                text: _selectedCategory.categoryName,
                                color: AppColors.lightGreyColor,
                                size: 15 * Dimentions.hUnit,
                                fontWeight: FontWeight.w400,
                              ),
                              items: _categories
                                  .map(
                                    (category) => DropdownMenuItem(
                                      value: category,
                                      child: BigText(
                                        text: category.categoryName,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.lightGreyColor,
                                        size: 15 * Dimentions.hUnit,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (newCategory) {
                                setState(() {
                                  _selectedCategory = newCategory!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20 * Dimentions.hUnit),
                  //
                  // DESCRIPTION
                  AppTextField(
                    label: 'Description',
                    controller: _descriptionController,
                    iconColor: AppColors.mainColor,
                    hintText: 'Description',
                    icon: Icons.description,
                  ),
                  SizedBox(height: 20 * Dimentions.hUnit),

                  //PRICE
                  Row(
                    children: [
                      //
                      // ORIGINAL PRICE
                      Container(
                        width: 160 * Dimentions.hUnit,
                        child: AppTextField(
                          label: 'Original price',
                          controller: _originalPriceController,
                          iconColor: AppColors.mainColor,
                          hintText: 'Original price',
                          icon: Icons.money_off_sharp,
                          textInputType: TextInputType.number,
                        ),
                      ),
                      Spacer(),
                      //
                      // DISCOUNTED PRICE
                      Container(
                        width: 190 * Dimentions.hUnit,
                        child: AppTextField(
                          label: 'Discounted price',
                          controller: _discountedPriceController,
                          iconColor: AppColors.mainColor,
                          hintText: 'Discounted price',
                          icon: Icons.discount_rounded,
                          textInputType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20 * Dimentions.hUnit),
                  //
                  // QUANTITY
                  AppTextField(
                    label: 'Quantity',
                    controller: _quantityController,
                    iconColor: AppColors.mainColor,
                    hintText: 'quantity',
                    icon: Icons.groups_2,
                    textInputType: TextInputType.number,
                  ),
                  SizedBox(height: 20 * Dimentions.hUnit),
                  //
                  // VALID UNTIL
                  // AppTextField(
                  //   controller: _validUntilController,
                  //   iconColor: AppColors.mainColor,
                  //   hintText: 'valid until',
                  //   icon: Icons.date_range,
                  // ),

                  // VALID UNTIL
                  Row(
                    children: [
                      BigText(
                        text: 'Valid Until - ',
                        color: AppColors.darkGreyColor,
                        size: 16 * Dimentions.hUnit,
                      ),
                      //
                      // DATE PICKER
                      MaterialButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _showDatePicker();
                          FocusScope.of(context).unfocus();
                        },
                        color: AppColors.iconColorPurple,
                        child: BigText(
                          text:
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          color: Colors.white,
                          size: 15 * Dimentions.hUnit,
                        ),
                      ),
                      SizedBox(width: 20 * Dimentions.hUnit),
                      //
                      // TIME PICKER
                      MaterialButton(
                        onPressed: _showTimePicker,
                        color: AppColors.iconColorPurple,
                        child: BigText(
                          text: _selectedTime.format(context).toString(),
                          color: Colors.white,
                          size: 15 * Dimentions.hUnit,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40 * Dimentions.hUnit),
                  //
                  // UPDATE PRODUCT BUTTON
                  ElevatedButton(
                    onPressed: _isButtonDisabled
                        ? null
                        : () {
                            print('*********************update pressed');
                            _addProduct();
                          },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40 * Dimentions.hUnit,
                          vertical: 8 * Dimentions.hUnit,
                        ),
                        shadowColor: Colors.white),
                    child: BigText(
                      text: 'Update product',
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      size: 25 * Dimentions.hUnit,
                    ),
                  ),
                  GetBuilder<ProductController>(
                    builder: (productController) {
                      return productController.isLoading
                          ? LoadingIndicator()
                          : Container();
                    },
                  ),
                  SizedBox(height: 20 * Dimentions.hUnit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
