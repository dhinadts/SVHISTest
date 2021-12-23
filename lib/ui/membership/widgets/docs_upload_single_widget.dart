import 'dart:io';

import '../../../ui/membership/controller/image_picker.dart';
import '../../../ui/membership/widgets/image_container.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'docs_upload_widget.dart';

class DocsUploadSingleWidget extends StatefulWidget {
  final void Function(File) documentImageCallback;
  final String documentImageUrl;
  final bool isRestrictToEditFields;

  const DocsUploadSingleWidget({
    Key key,
    @required this.documentImageCallback,
    @required this.documentImageUrl,
    @required this.isRestrictToEditFields,
  }) : super(key: key);
  @override
  _DocsUploadSingleWidgetState createState() => _DocsUploadSingleWidgetState();
}

class _DocsUploadSingleWidgetState extends State<DocsUploadSingleWidget> {
  final picker = ImagePicker();
  File documentFrontImage, documentBackImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 5.0,
              shadowColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    (widget.documentImageUrl != null &&
                                widget.documentImageUrl.isNotEmpty) ||
                            documentFrontImage != null
                        ? Stack(
                            children: [
                              ImageContainer(
                                imageUrl: widget.documentImageUrl,
                                imageFile: documentFrontImage,
                                onPressed: widget.isRestrictToEditFields
                                    ? null
                                    : () {
                                        _getDocumentImage();
                                      },
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: GestureDetector(
                                  child: Icon(
                                    Icons.fullscreen,
                                    size: 30.0,
                                  ),
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return new ImageViewerDialog(
                                            imageFile: documentFrontImage,
                                            imageUrl: widget.documentImageUrl,
                                          );
                                        });
                                  },
                                ),
                              )
                            ],
                          )
                        : ImageContainer(
                            imageText: "Picture",
                            onPressed: () {
                              _getDocumentImage();
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _getDocumentImage() async {
    FocusScope.of(context).requestFocus(FocusNode());
    File image = await getImage(
      context: context,
      documentSide: DocumentSide.FRONT,
      imagePicker: picker,
      imageQuality: 50,
    );
    if (image != null) {
      setState(() {
        //documentFrontImageBytes = image.readAsBytesSync();
        documentFrontImage = image;
      });
      //widget.documentFrontImageBytesCallback(documentFrontImageBytes);
      widget.documentImageCallback(documentFrontImage);
    }
  }
}
