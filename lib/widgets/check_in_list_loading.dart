import '../ui_utils/ui_dimens.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CheckInListLoading extends StatelessWidget {
  static const int listItemsMaxCount = 10;
  final int itemCount;

  const CheckInListLoading({this.itemCount = -1});

  Widget articleLoader(BuildContext context) {
    return SizedBox(
        child: Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.only(bottom: AppUIDimens.paddingMedium),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[400],
        highlightColor: Colors.grey[100],
        child: _shimmerDesign(context),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(
            left: AppUIDimens.paddingMedium,
            top: AppUIDimens.paddingMedium,
            right: AppUIDimens.paddingMedium),
        itemCount: listItemsMaxCount,
        itemBuilder: (BuildContext context, int index) {
          return articleLoader(context);
        });
  }

  Widget _shimmerDesign(BuildContext context) {
    return SizedBox(
        child: Column(children: <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Flexible(
              child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            AppUIDimens.zeroValue,
                            AppUIDimens.zeroValue,
                            AppUIDimens.paddingMedium,
                            AppUIDimens.zeroValue),
                        child: Container(
                          height: AppUIDimens.shimmerCardImgHeight + 10,
                          width: double.infinity,
                          color: Colors.amber,
                        )),
                  ]),
            ),
          )),
        ],
      ),
      Padding(
          padding: EdgeInsets.only(
              top: AppUIDimens.paddingXSmall,
              bottom: AppUIDimens.paddingMedium)),
      Container(
        width: double.infinity,
        height: 1,
        color: Colors.amber,
      ),
    ]));
  }
}
