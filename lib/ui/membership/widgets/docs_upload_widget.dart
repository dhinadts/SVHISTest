import 'dart:io';

import '../../../ui/membership/controller/image_picker.dart';
import '../../../ui/membership/widgets/image_container.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';

enum DocumentSide { FRONT, BACK }

class DocsUploadWidget extends StatefulWidget {
  final void Function(File) documentFrontImageCallback;
  final void Function(File) documentBackImageCallback;

  //final Uint8List documentFrontImageBytes;
  //final Uint8List documentBackImageBytes;
  final String documentFrontImageUrl;
  final String documentBackImageUrl;
  final bool isRestrictToEditFields;

  const DocsUploadWidget({
    Key key,
    @required this.documentFrontImageCallback,
    @required this.documentBackImageCallback,
    //@required this.documentFrontImageBytes,
    //@required this.documentBackImageBytes,
    @required this.documentFrontImageUrl,
    @required this.documentBackImageUrl,
    @required this.isRestrictToEditFields,
  }) : super(key: key);
  @override
  _DocsUploadWidgetState createState() => _DocsUploadWidgetState();
}

class _DocsUploadWidgetState extends State<DocsUploadWidget> {
  final picker = ImagePicker();
  //Uint8List documentFrontImageBytes, documentBackImageBytes;
  File documentFrontImage, documentBackImage;

  @override
  void initState() {
    super.initState();
    //documentFrontImageBytes = widget.documentFrontImageBytes;
    //documentBackImageBytes = widget.documentBackImageBytes;
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
                    (widget.documentFrontImageUrl != null &&
                                widget.documentFrontImageUrl.isNotEmpty) ||
                            documentFrontImage != null
                        ? Stack(
                            children: [
                              ImageContainer(
                                //imageBytes: documentFrontImageBytes,
                                imageUrl: widget.documentFrontImageUrl,
                                imageFile: documentFrontImage,
                                onPressed: widget.isRestrictToEditFields
                                    ? null
                                    : () {
                                        _getDocumentFrontImage();
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
                                            imageUrl:
                                                widget.documentFrontImageUrl,
                                          );
                                        });
                                  },
                                ),
                              )
                            ],
                          )
                        : ImageContainer(
                            imageText: "Front Picture",
                            onPressed: () {
                              _getDocumentFrontImage();
                            },
                          ),
                    SizedBox(
                      height: 10.0,
                    ),
                    (widget.documentBackImageUrl != null &&
                                widget.documentBackImageUrl.isNotEmpty) ||
                            documentBackImage != null
                        ? Stack(
                            children: [
                              ImageContainer(
                                //imageBytes: documentBackImageBytes,
                                imageUrl: widget.documentBackImageUrl,
                                imageFile: documentBackImage,
                                onPressed: widget.isRestrictToEditFields
                                    ? null
                                    : () {
                                        _getDocumentBackImage();
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
                                            imageFile: documentBackImage,
                                            imageUrl:
                                                widget.documentBackImageUrl,
                                          );
                                        });
                                  },
                                ),
                              )
                            ],
                          )
                        : ImageContainer(
                            imageText: "Back Picture",
                            onPressed: () {
                              _getDocumentBackImage();
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

  _getDocumentFrontImage() async {
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
      widget.documentFrontImageCallback(documentFrontImage);
    }
  }

  _getDocumentBackImage() async {
    FocusScope.of(context).requestFocus(FocusNode());
    File image = await getImage(
      context: context,
      documentSide: DocumentSide.BACK,
      imagePicker: picker,
      imageQuality: 50,
    );
    if (image != null) {
      setState(() {
        //documentBackImageBytes = image.readAsBytesSync();
        documentBackImage = image;
      });
      //widget.documentBackImageBytesCallback(documentBackImageBytes);
      widget.documentBackImageCallback(documentBackImage);
    }
  }
}

class ImageViewerDialog extends StatelessWidget {
  final String imageUrl;
  final File imageFile;

  const ImageViewerDialog({@required this.imageUrl, @required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Align(
              alignment: Alignment(1, 0),
              child: InkWell(
                child: Icon(
                  Icons.close,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )),
          InteractiveViewer(
            boundaryMargin: EdgeInsets.all(0.0),
            child: Container(
              child: imageUrl != null && imageUrl.length > 0
                  ? FadeInImage.memoryNetwork(
                      fadeInDuration: const Duration(milliseconds: 200),
                      placeholder: kTransparentImage,
                      image: imageUrl,
                      fit: BoxFit.fitWidth,
                    )
                  : Image.file(
                      imageFile,
                      fit: BoxFit.fitWidth,
                    ),
            ),
          ),
        ],
      ),
    ));
  }
}
