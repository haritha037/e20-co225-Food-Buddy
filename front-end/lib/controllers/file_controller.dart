import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:food_buddy_frontend/data/repository/file_repo.dart';
import 'package:food_buddy_frontend/models/api_response.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FileController extends GetxController {
  final FileRepo fileRepo;

  FileController({required this.fileRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _uploadedImageName = 'default.jpg';
  String get uploadedImageName => _uploadedImageName;

  // COMPRESS IMAGE
  Future<XFile> compressImage(XFile imageXFile) async {
    File imageFile = File(imageXFile.path);
    var result = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '${imageFile.path}compressed.jpg',
      quality: 50,
    );
    print('****************Compressed');
    print(imageFile.lengthSync());
    print(File(result!.path).lengthSync());

    return result;
  }

  // UPLOAD IMAGE
  Future<ApiResponse> uploadImage(XFile imageFile, String uri) async {
    _isLoading = true;
    update();

    XFile compressedImageFile = await compressImage(imageFile);

    MultipartFile multipartImage = MultipartFile(
      await File(compressedImageFile.path).readAsBytes(),
      filename: compressedImageFile.name,
    );

    FormData formData = FormData({
      'image': multipartImage,
    });

    Response response = await fileRepo.uploadImage(formData, uri);

    late ApiResponse apiResponse;

    if (response.statusCode == 200) {
      _uploadedImageName = response.body['image'];
      print('Image uploaded successfully');
      apiResponse =
          ApiResponse(status: true, message: 'Image uploaded successfully');
    } else {
      print(response.statusCode);
      print('Image uploading failed');
      apiResponse =
          ApiResponse(status: false, message: 'Image uploading failed');
    }

    _isLoading = false;
    update();
    return apiResponse;
  }
}
