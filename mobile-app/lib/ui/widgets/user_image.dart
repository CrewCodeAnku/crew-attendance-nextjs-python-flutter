import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:crew_attendance/ui/widgets/round_image.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';

import '../../core/providers/auth_provider.dart';
import '../../util/shared_preference.dart';

class UserImage extends StatefulWidget {
  final void Function(String) onFileChanged;

  UserImage({required this.onFileChanged});

  @override
  _UserImageState createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  final ImagePicker _picker = ImagePicker();
  Dio dio = Dio();
  String? imageUrl;

  getProfilePci() async {
    var profilepic = await UserPreferences().getProfilePic();
    print("Profile Pic");
    print(profilepic);
    setState(() {
      imageUrl = profilepic;
    });
  }

  @override
  void initState() {
    super.initState();
    getProfilePci();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (imageUrl == null || imageUrl == "")
          Icon(Icons.image, size: 68, color: Theme.of(context).primaryColor),
        if (imageUrl != null && imageUrl != "")
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => _selectPhoto(),
            child: AppRoundImage.url(
              imageUrl!,
              height: 80,
              width: 80,
            ),
          ),
        InkWell(
          onTap: () => _selectPhoto(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              imageUrl != null || imageUrl != "" ? 'Change Photo' : 'Select Photo',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }

  Future _selectPhoto() async {
    print("Inside select photo");
    await showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        onClosing: onClosing,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
                leading: Icon(Icons.camera),
                title: Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                }),
            ListTile(
                leading: Icon(Icons.filter),
                title: Text('Pick a file'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                })
          ],
        ),
      ),
    );
  }

  Future _pickImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 58);
    if (pickedFile == null) {
      return;
    }

    var file = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1));
    if (file == null) {
      return;
    }
    var compressedFile = await compressImage(file.path, 35);
    await _uploadFile(compressedFile?.path ?? "");
  }

  Future<File?> compressImage(String path, int quality) async {
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');
    final result = await FlutterImageCompress.compressAndGetFile(path, newPath,
        quality: quality);
    return result;
  }

  Future _uploadFile(String imagepath) async {
    try {
      await EasyLoading.show(
        status: 'Updating image...',
        maskType: EasyLoadingMaskType.black,
      );
      AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
      String filename = imagepath.split('/').last;
      final Future<Map<String, dynamic>> successfulMessage =
          auth.updateProfilePic(imagepath, filename);

      successfulMessage.then((response) async {
        if (response['status']) {
          Flushbar(
            title: "Upload success",
            message: response['message'].toString(),
            duration: const Duration(seconds: 3),
          ).show(context);
          await UserPreferences()
              .setProfilePic(response['data']['profile_picture']);
          setState(() => imageUrl = response['data']['profile_picture']);

          await EasyLoading.dismiss();
        } else {
          Flushbar(
            title: "Failed Uploading",
            message: response['message'].toString(),
            duration: const Duration(seconds: 3),
          ).show(context);
          await EasyLoading.dismiss();
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void onClosing() {}
}
