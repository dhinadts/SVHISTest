import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../../bloc/user_info_bloc.dart';
import '../../login/colors/color_info.dart';
import '../../login/utils/custom_progress_dialog.dart';
import '../../model/user_info.dart';
import '../../ui/custom_drawer/drawer_theme.dart';
import '../../ui/tabs/app_localizations.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'navigation_home_screen.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer(
      {Key key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex,
      this.drawerList})
      : super(key: key);

  final AnimationController iconAnimationController;
  final int screenIndex;
  final Function(int) callBackIndex;
  final List<DrawerList> drawerList;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  Uint8List imageBytes;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    loadProfileImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DrawerTheme.notWhite.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            color: AppColors.primaryColor,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return ScaleTransition(
                        scale: AlwaysStoppedAnimation<double>(
                            1.0 - (widget.iconAnimationController.value) * 0.2),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation<double>(Tween<double>(
                                      begin: 0.0, end: 24.0)
                                  .animate(CurvedAnimation(
                                      parent: widget.iconAnimationController,
                                      curve: Curves.fastOutSlowIn))
                                  .value /
                              360),
                          child: Container(
                            width: 120.0,
                            height: 80.0,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () async {
                                      await selectProfileImage(context);
                                    },
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: DrawerTheme.grey
                                                  .withOpacity(0.6),
                                              offset: const Offset(0.0, 0.0),
                                              blurRadius: 1),
                                        ],
                                      ),
                                      child: (imageBytes != null &&
                                              imageBytes.length > 0)
                                          ? ClipOval(
                                              child: Image.memory(
                                                imageBytes,
                                                fit: BoxFit.fitWidth,
                                                width: double.maxFinite,
                                                height: double.maxFinite,
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10.0)),
                                              child: Container(
                                                margin: EdgeInsets.all(8),
                                                child: Image.asset(
                                                  'assets/images/user.png',
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                // Align(
                                //   alignment: Alignment.centerRight,
                                //   child: GestureDetector(
                                //     child: CircleAvatar(
                                //       child: Icon(
                                //         Icons.photo_camera,
                                //         size: 25.0,
                                //         color: Colors.white,
                                //       ),
                                //       backgroundColor: AppColors.primaryColor,
                                //       radius: 16.0,
                                //     ),
                                //     onTap: () async {
                                //       await selectProfileImage(context);
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      AppPreferences().fullName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      AppPreferences().role,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      AppPreferences().email,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            color: DrawerTheme.grey.withOpacity(0.6),
          ),
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(0.0),
                itemCount: widget.drawerList.length,
                itemBuilder: (BuildContext context, int index) {
                  return inkwell(widget.drawerList[index]);
                },
              ),
            ),
          ),
          Divider(
            height: 1,
            color: DrawerTheme.grey.withOpacity(0.6),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: DrawerTheme.darkText,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                ),
                onTap: () async {
                  // print("logout icon pressed...");
                  String name = await AppPreferences.getFullName();
                  AlertUtils.logoutAlert(context, name);
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationToScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    decoration: BoxDecoration(
                      color: widget.screenIndex == listData.index
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? listData.imageName.startsWith('http')
                          ? Container(
                              width: 28,
                              height: 28,
                              child: Image.network(
                                listData.imageName,
                              ),
                            )
                          : Container(
                              width: 28,
                              height: 28,
                              child: Image.asset(
                                listData.imageName,
                              ),
                            )
                      : Icon(listData.icon.icon,
                          color: widget.screenIndex == listData.index
                              ? AppColors.primaryColor
                              : DrawerTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? Colors.black
                          : DrawerTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) *
                                (1.0 -
                                    widget.iconAnimationController.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationToScreen(int indexScreen) async {
    widget.callBackIndex(indexScreen);
  }

  loadProfileImage() async {
    UserInfo userInfo = await AppPreferences.getUserInfo();
    // print("===========================> ${userInfo.profileImage}");
    if (userInfo.profileImage != null) {
      imageBytes = base64Decode(userInfo.profileImage);
    } else {
      if (imageBytes != null) imageBytes.clear();
    }
    setState(() {
      imageBytes = imageBytes;
    });
  }

  Future<void> selectProfileImage(BuildContext context) async {
    ImagePicker imagePicker = ImagePicker();
    ImageSource imageSource = await selectedImageSource(context);
    if (imageSource != null) {
      PickedFile pickedFile = await imagePicker.getImage(
        source: imageSource,
        imageQuality: 40,
      );
      if (pickedFile != null) {
        setState(() {
          imageBytes = File(pickedFile.path).readAsBytesSync();
        });
        String profileImage = base64Encode(imageBytes);
        await updateProfileImage(profileImage);
      }
    }
  }

  Future<ImageSource> selectedImageSource(BuildContext context) async {
    ImageSource imageSource;
    Platform.isIOS
        ? await showCupertinoModalPopup(
            context: context,
            builder: (context) {
              return CupertinoActionSheet(
                title: Text(
                  'Select Image From',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                message: Text(
                  'Choose the source of image to be uploaded',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                actions: [
                  CupertinoActionSheetAction(
                    onPressed: () {
                      imageSource = ImageSource.camera;
                      Navigator.pop(context);
                    },
                    child: Text('Camera'),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () {
                      imageSource = ImageSource.gallery;
                      Navigator.pop(context);
                    },
                    child: Text('Gallery'),
                  ),
                  imageBytes != null && imageBytes.length > 0
                      ? CupertinoActionSheetAction(
                          onPressed: () async {
                            Uint8List previousImage = imageBytes;
                            setState(() {
                              imageBytes = Uint8List(0);
                            });
                            Navigator.pop(context);
                            if (previousImage.length > 0)
                              await updateProfileImage(null);
                          },
                          child: Text(
                            'Remove Image',
                            style: TextStyle(
                              color: Colors.redAccent,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              );
            },
          )
        : await showModalBottomSheet(
            context: context,
            builder: (context) {
              return BottomSheet(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                )),
                onClosing: () {},
                builder: (context) {
                  return Container(
                    height: 170.0,
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " Select Image From",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 30.0,
                                    color: Color(ColorInfo.DATE_PICKER_COLOR),
                                  ),
                                  Text(
                                    'Camera',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Color(ColorInfo.DATE_PICKER_COLOR),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                imageSource = ImageSource.camera;
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.storage,
                                    size: 30.0,
                                    color: Color(ColorInfo.DATE_PICKER_COLOR),
                                  ),
                                  Text(
                                    'Gallery',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Color(ColorInfo.DATE_PICKER_COLOR),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                imageSource = ImageSource.gallery;
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            imageBytes != null && imageBytes.length > 0
                                ? GestureDetector(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.delete_forever,
                                          size: 30.0,
                                          color: Colors.redAccent,
                                        ),
                                        Text(
                                          'Remove\nImage',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () async {
                                      Uint8List previousImage = imageBytes;
                                      setState(() {
                                        imageBytes = Uint8List(0);
                                      });
                                      Navigator.pop(context);
                                      if (previousImage.length > 0)
                                        await updateProfileImage(null);
                                    },
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
    return imageSource;
  }

  Future<void> updateProfileImage(String profileImage) async {
    UserInfoBloc userInfoBloc = new UserInfoBloc(context);
    CustomProgressLoader.showLoader(context);
    UserInfo userInfo = await AppPreferences.getUserInfo();
    userInfo.profileImage = profileImage;
    userInfoBloc.updateUserInfo(userInfo, null);
    userInfoBloc.createFetcher.listen((value) async {
      if (value.status == 201 || value.status == 200) {
        await AppPreferences.setUserInfo(userInfo);
        await AppPreferences.setProfileUpdate(true);
        if (profileImage == null) {
          Fluttertoast.showToast(
              msg: "Profile picture removed successfully",
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 5,
              gravity: ToastGravity.TOP);
        } else {
          Fluttertoast.showToast(
              msg: "Profile picture updated successfully",
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 5,
              gravity: ToastGravity.TOP);
        }

        CustomProgressLoader.cancelLoader(context);
      } else {
        CustomProgressLoader.cancelLoader(context);
        AlertUtils.showAlertDialog(
            context,
            value.message ??
                AppLocalizations.of(context)
                    .translate("key_somethingwentwrong"));
      }
    });
  }
}

// class DrawerList {
//   DrawerList({
//     this.isAssetsImage = true,
//     this.labelName = '',
//     this.icon,
//     this.index,
//     this.imageName = '',
//   });

//   String labelName;
//   Icon icon;
//   bool isAssetsImage;
//   String imageName;
//   int index;
// }
