import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../ui_utils/app_colors.dart';

class ImageContainer extends StatelessWidget {
  final String imageText;
  final Function onPressed;
  //final Uint8List imageBytes;
  final String imageUrl;
  final File imageFile;

  ImageContainer({
    this.imageText,
    this.onPressed,
    //this.imageBytes,
    this.imageUrl,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 154.0,
        color: AppColors.kImageBackgroundColor,
        child: DottedBorder(
          borderType: BorderType.Rect,
          color: AppColors.kImageBorderColor,
          dashPattern: [4, 4],
          child: imageFile != null
              ? Center(
                  child: Image.file(imageFile),
                )
              : imageUrl != null && imageUrl.length > 0
                  ? Center(
                      child: Image.network(imageUrl),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/images/camera.png",
                            height: 40.0,
                            width: 40.0,
                          ),
                        ),
                        Text(
                          imageText,
                          style: TextStyle(
                            color: AppColors.kHintTextColor,
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
