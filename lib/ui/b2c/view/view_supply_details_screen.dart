import '../../../ui/b2c/model/supplier_item_model.dart';
import 'package:flutter/material.dart';

class ViewSupplyDetailsScreen extends StatefulWidget {
  final SupplierItemModel supplierItemData;

  const ViewSupplyDetailsScreen({Key key, this.supplierItemData})
      : super(key: key);

  @override
  _ViewSupplyDetailsScreenState createState() =>
      _ViewSupplyDetailsScreenState();
}

class _ViewSupplyDetailsScreenState extends State<ViewSupplyDetailsScreen> {
  TextEditingController actionController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String allTags = widget.supplierItemData.allTags;
    List<String> allTagList = allTags.split(',');
    List<String> tagsList = [];
    allTagList.forEach((element) {
      if (element.length > 0) {
        tagsList.add(element);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("View Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Card(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 110,
                                child: Text(
                                  "Name :",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child:
                                      Text("${widget.supplierItemData.item}"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 110,
                                child: Text(
                                  "Description :",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                      "${widget.supplierItemData.description}"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 110,
                                child: Text(
                                  "Sell or Donate :",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                      "${widget.supplierItemData.capableSupplies}"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 110,
                                child: Text(
                                  "Unit :",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: widget.supplierItemData.unit.isEmpty
                                      ? Text("N/A")
                                      : Text("${widget.supplierItemData.unit}"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 110,
                                child: Text(
                                  "Quantity :",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: widget.supplierItemData.quantity == 0
                                      ? Text("N/A")
                                      : Text(
                                          "${widget.supplierItemData.quantity}"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 110,
                                child: Text(
                                  "Quantity Arranged :",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: widget.supplierItemData
                                              .arrangeQuantity ==
                                          0
                                      ? Text("N/A")
                                      : Text(
                                          "${widget.supplierItemData.arrangeQuantity}"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 110,
                                child: Text(
                                  "# Days to Arrange : ",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: widget.supplierItemData.arrangeDate ==
                                          0
                                      ? Text("N/A")
                                      : Text(
                                          "${widget.supplierItemData.arrangeDate}"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 110,
                                child: Text(
                                  "Item Updated : ",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                      "${widget.supplierItemData.itemUpdated}"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        widget.supplierItemData.allTags.isNotEmpty
                            ? Container(
                                //width: 110,
                                //height: 100.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 30.0,
                                      width: 110,
                                      child: Center(
                                          child: Text("Key Descriptors : ",
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight:
                                                      FontWeight.w800))),
                                      //height: 50.0,
                                    ),
                                    Expanded(
                                      child: Container(
                                        //height: 50.0,
                                        height: 30.0,

                                        child: ListView.builder(
                                            itemCount: tagsList.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return Card(
                                                color: Colors.blue,
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Colors.grey,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                                child: Center(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8.0),
                                                  child: Text(
                                                    "${tagsList[index]}",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )),
                                              );
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
