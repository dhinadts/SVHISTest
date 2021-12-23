import 'dart:io';

import '../../../ui/membership/widgets/custom_button.dart';
import '../../../ui/membership/widgets/docs_upload_widget.dart';
import '../../../ui_utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future getImage(
    {@required BuildContext context,
    @required DocumentSide documentSide,
    @required ImagePicker imagePicker,
    @required int imageQuality}) async {
  File imageFile;

  ImageSource imageSource = await getSource(context: context);
  if (imageSource != null) {
    final pickedFile = await imagePicker.getImage(
      source: imageSource,
      imageQuality: imageQuality,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
  }
  return imageFile;
}

Future<ImageSource> getSource({@required BuildContext context}) async {
  ImageSource imageSource;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text(
          "Select document from",
          style: TextStyle(
            color: AppColors.kMainTextColor,
            fontSize: 20.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        contentPadding: EdgeInsets.all(20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        children: [
          Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomButton(
                height: 50.0,
                buttonText: "Camera",
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                onPressed: () {
                  imageSource = ImageSource.camera;
                  Navigator.pop(context);
                },
                width: 150,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Divider(
                  thickness: 3.0,
                  height: 2.0,
                ),
              ),
              CustomButton(
                height: 50.0,
                buttonText: "Gallery",
                icon: Icon(
                  Icons.photo_library,
                  color: Colors.white,
                ),
                onPressed: () {
                  imageSource = ImageSource.gallery;
                  Navigator.pop(context);
                },
                width: 150,
              ),
            ],
          ),
        ],
      );
    },
  );
  return imageSource;
}
