import 'package:flutter/material.dart';

class QRResultScreen extends StatefulWidget {
  QRResultScreen({Key key}) : super(key: key);

  @override
  _QRResultScreenState createState() => _QRResultScreenState();
}

class _QRResultScreenState extends State<QRResultScreen> {
  var firstName = '';
  var lastName = '';
  var dateOfBirth = '';
  var dose1Date = '';
  var dose2Date = '';
  var vaccineName = '';
  var identificationType = '';
  var identificationNumber = "";
  var certificationNumber = "";
  String totalCounts = "0";
  String pause1 = "PAUSE";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Expanded(
          child: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    'Name : ',
                    //textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$firstName $lastName',
                    //textAlign: TextAlign.center,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Vaccination Name : ',
                    //textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$vaccineName',
                    //textAlign: TextAlign.center,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Identification Type : ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('$identificationType'),
                ],
              ),
              identificationType == "none"
                  ? SizedBox.shrink()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Identification No : ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$identificationNumber',
                          maxLines: 2,
                        ),
                      ],
                    ),

              // Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      Text(
                        'Certification No',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          // fontSize: 12,
                        ),
                      ),
                      Container(
                        child: Text(
                          '$certificationNumber',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              // fontSize: 12,
                              ),
                        ),
                      ),
                    ],
                  ),
                  /*           Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 1,
                            height: double.infinity,
                            color: Colors.blueGrey,
                          ),
                        ],
                      ),  */
                  Column(
                    children: [
                      Text(
                        'Dose 1 Date',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          // fontSize: 12,
                        ),
                      ),
                      Text(
                        '$dose1Date',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            // fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                  /*  Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 1,
                            height: double.infinity,
                            color: Colors.blueGrey,
                          ),
                        ],
                      ), */
                  Column(
                    children: [
                      Text(
                        'Dose 2 Date',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          // fontSize: 12,
                        ),
                      ),
                      Text(
                        '$dose2Date',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            // fontSize: 14,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment:
                    /* AppPreferences().role != "User"
                        ? MainAxisAlignment.spaceBetween
                        : */
                    MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Row(
                      children: [
                        Text(
                          "Today's Scanned Count : ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            // fontSize: 12,
                          ),
                        ),
                        Text(
                          "$totalCounts",
                          // style: TextStyle(
                          //   fontWeight: FontWeight.bold,
                          //   // fontSize: 14,
                          // ),
                        )
                      ],
                    ),
                  ),
                  /* if (AppPreferences().role != "User")
                        Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child: Row(
                            children: [
                              Text(
                                "Today's total Count: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // fontSize: 12,
                                ),
                              ),
                              Text(
                                "$totalCounts",
                                // style: TextStyle(
                                //   fontWeight: FontWeight.bold,
                                //   // fontSize: 12,
                                // ),
                              )
                            ],
                          ),
                        ), */
                ],
              )

              //   onPressed: qrCodeResult == null
              //       ? null
              //       : () {
              //           checkQRCode();
              //         },
              //   child: Text("SUBMIT"),
              // )
            ],
          ),
        ),
      )),
    );
  }
}
