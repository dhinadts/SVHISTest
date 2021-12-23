import '../../ui_utils/app_colors.dart';
import '../../utils/inappwebview_js_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SampleInAppWebView extends StatefulWidget {
  final showFlashView;

  const SampleInAppWebView({Key key, this.showFlashView}) : super(key: key);
  @override
  _SampleInAppWebViewState createState() => new _SampleInAppWebViewState();
}

class _SampleInAppWebViewState extends State<SampleInAppWebView> {
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      //  AppBar(
      //      title: Text("Sample InAppWebView"),
      //      backgroundColor: AppColors.primaryColor),
      body: SafeArea(
          child: Container(
        child: InAppWebView(
          initialData: InAppWebViewInitialData(
            data: """
<!DOCTYPE html>
<html lang="en">
    <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    </head>
    <style>
table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}
</style>
    <body>
       
<table>
  <tr>
    <th>Events</th>
    
  </tr>
  <tr onclick="myFunction(this)">
    <td>GNAT normal event</td>
   
  </tr>
  <tr onclick="donation(this)">
    <td>Donation Module</td>
    
  </tr>
    <tr onclick="flash(this)">
    <td>Flash</td>
   
  </tr>
    <tr onclick="wishes(this)">
    <td>Wishes</td>
   
  </tr>
  <tr onclick="logbook(this)">
    <td>Logbook</td>
   
  </tr>
  <tr onclick="profile(this)">
    <td>Profile</td>
   
  </tr>


</table>
          <script>
            var events = ["GNAT normal event","GNAT - Cricket Tournament", "GNAT - Throwball Tournament"];
            window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
              console.log("flutterInAppWebViewPlatformReady....");
            });

            function myFunction(x) {
              window.flutter_inappwebview.callHandler('handlerWithArgs', 
              {'route': 'EVENT', 'args': {'eventName' : events[x.rowIndex-1]}});
            }

            function donation(x){
              window.flutter_inappwebview.callHandler('handlerWithArgs', 
              {'route': 'DONATION', 'args': {"createdBy":"SuperAdmin Admin",
              "createdOn":"2021-03-25T08:56:21.125","modifiedBy":"SuperAdmin Admin",
              "modifiedOn":"2021-03-25T08:56:21.125",
              "active":false,"comments":null,
              "causeId":"e4213fee-9343-4b37-9dc4-89bb091de29a",
              "client_id":"GNAT","cause_title":"testbasic1",
              "cause_body":"testbasic1","cause_body_mime":"text/plain",
              "collection_status":"LIVE","end_date":null,"hashtags":"",
              "isFundRaiser":false,"achieved_amount":null,"min_amount":null,
              "receipt_required":false,"receipt_prefix":"","receipt_suffix":"",
              "receipt_template":null,"start_date":"2021-03-25T00:00:00.000+00:00",
              "supporting_docs":"","target_amount":null}});
            }

            function logbook(x){
              window.flutter_inappwebview.callHandler('handlerWithArgs', {'route': 'LOGBOOK',
               'args':{'active': true, 'viewed': null, 'column1': 0.0, 'column2': 0.0, 
               'column3': null, 'column4': null, 'column5': null, 'column6': null,
                'column7': null, 'column8': 0.0, 'column9': null, 'column10': null, 
                'column11': null, 'column12': null, 'column13': null, 'column14': null,
                 'column15': null, 'column16': null, 'column17': null, 'column18': null, 
                 'column19': null, 'column20': null, 'column21': null, 'column22': null, 
                 'column23': null, 'column24': null, 'column25': null, 'column26': null, 
                 'column27': null, 'column28': null, 'column29': null, 'column30': null, 
                 'column31': null, 'column32': null, 'column33': null, 'column34': null, 
                 'column35': null, 'column36': null, 'column37': null, 'column38': null, 
                 'column39': null, 'column40': null, 'comments': null, 'departmentName': "Diabetes Assoc",
                 'firstName': null, 'id': 'f0874f9f-06e7-4eda-931c-15ada3995f61', 'lastName': null,
                  'createdBy': 'DATT', 'createdOn': '2021-04-29T11:00:31.702', 'modifiedBy': "DATT", 
                  'modifiedOn': '2021-04-29T11:00:31.702', 'status': 'Reported',
                   'checkInDate': '2021-04-29T11:00:31.702', 'userName': 'DATT'}});
            }

            function profile(x){
 window.flutter_inappwebview.callHandler('handlerWithArgs', 
              {'route': 'PROFILE', 'args':{}});
            }
                      function flash(x){
 window.flutter_inappwebview.callHandler('handlerWithArgs', 
              {'route': 'FLASH', 'args':{'link': 'https://www.google.com/'}});
            }

            function wishes(x){
               window.flutter_inappwebview.callHandler('handlerWithArgs', 
              {'route': 'WISHES', 'args':{'link': 'https://www.google.com/'}});
            }
          </script>
    </body>
</html>
                        """,
          ),
          initialOptions: options,
          onWebViewCreated: (controller) {
            controller.addJavaScriptHandler(
                handlerName: 'handlerWithArgs',
                callback: (args) {
                  if (args.isNotEmpty) {
                    handleJavascriptEvents(
                        context: context, handlerData: args[0]);
                  }
                });
          },
          onConsoleMessage: (controller, consoleMessage) {
            debugPrint("consoleMessage --> $consoleMessage");
            // it will print: {message: {"bar":"bar_value","baz":"baz_value"}, messageLevel: 1}
          },
        ),
      )),
    );
  }
}
