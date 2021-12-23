import '../ui_utils/ui_dimens.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TransactionListLoadingWidget extends StatelessWidget {
  static const int listItemsMaxCount = 10;
  final int itemCount;

  const TransactionListLoadingWidget({this.itemCount = -1});

  Widget articleLoader() {
    return SizedBox(
        child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.all(Radius.circular(AppUIDimens.cardRadius))),
//      padding: EdgeInsets.only(bottom: AppUIDimens.paddingMedium),
      // EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[350],
        highlightColor: Colors.grey[100],
        child: _shimmerDesign(),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: list);
  }

  Widget get list => ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(
          left: AppUIDimens.paddingMedium, right: AppUIDimens.paddingMedium),
      itemCount: itemCount == -1 ? listItemsMaxCount : itemCount,
      itemBuilder: (BuildContext context, int index) {
        return articleLoader();
      });

  Widget _shimmerDesign() {
    return SizedBox(
        child: Column(children: <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Flexible(
              child: SizedBox(
            width: double.infinity,
            child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            AppUIDimens.zeroValue,
                            AppUIDimens.paddingXLarge,
                            AppUIDimens.paddingMedium,
                            AppUIDimens.zeroValue),
                        child: Container(
                          height: AppUIDimens.shimmerCardImgHeight,
                          width: double.infinity,
                          color: Colors.amber,
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            AppUIDimens.zeroValue,
                            AppUIDimens.paddingMedium,
                            AppUIDimens.paddingMedium,
                            AppUIDimens.zeroValue),
                        child: Container(
                          height: AppUIDimens.shimmerIconHeight,
                          width: double.infinity,
                          color: Colors.amber,
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            AppUIDimens.zeroValue,
                            AppUIDimens.paddingSmall,
                            AppUIDimens.paddingMedium,
                            AppUIDimens.zeroValue),
                        child: Container(
                          height: AppUIDimens.shimmerIconHeight,
                          width: double.infinity,
                          color: Colors.amber,
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            AppUIDimens.zeroValue,
                            AppUIDimens.paddingSmall,
                            AppUIDimens.paddingMedium,
                            AppUIDimens.zeroValue),
                        child: Container(
                          height: AppUIDimens.shimmerIconHeight,
                          width: double.infinity,
                          color: Colors.amber,
                        ))
                  ]),
            ),
          )),
        ],
      ),
      Padding(
          padding: EdgeInsets.only(
              //  top: AppUIDimens.paddingXSmall,
              bottom: AppUIDimens.paddingMedium)),
      Container(
        width: double.infinity,
        height: 1,
        color: Colors.amber,
      ),
    ]));
  }
}
