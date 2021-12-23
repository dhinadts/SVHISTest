import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../custom_drawer/custom_app_bar.dart';
import '../../ui_utils/app_colors.dart';
import 'package:http/http.dart' as http;
import '../../repo/common_repository.dart';
import '../../utils/app_preferences.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import '../../widgets/ratting_widget.dart';

class ReviewAppointment extends StatefulWidget {
  final appointment;
  ReviewAppointment(this.appointment);
  @override
  _ReviewAppointmentState createState() => _ReviewAppointmentState();
}

class _ReviewAppointmentState extends State<ReviewAppointment> {
  double rate = 0.0;
  TextEditingController review = TextEditingController();

  @override
  initState() {
    super.initState();
    review.clear();
    rate = 0.0;
    /* setState(() {
      rate = widget.appointment.rating == null
          ? 0
          : widget.appointment.rating + 0.0;
      review = TextEditingController(
          text: widget.appointment.review == null ||
                  widget.appointment.review.isEmpty
              ? ""
              : widget.appointment.review);
    }); */
  }

  @override
  void dispose() {
    super.dispose();
    review.clear();
    rate = 0.0;
  }

  sendReview() async {
    if (review.text.isNotEmpty && rate > 0) {
      var body = {"review": review.text, "rating": rate};
      Map<String, String> header = {};
      header.putIfAbsent(WebserviceConstants.contentType,
          () => WebserviceConstants.applicationJson);
      header.putIfAbsent(
          WebserviceConstants.username, () => AppPreferences().username);
      header.putIfAbsent("tenant", () => WebserviceConstants.tenant);
      var response = await http.post(
          WebserviceConstants.baseAppointmentURL +
              '/v2/patient_appointment/${AppPreferences().deptmentName}/${AppPreferences().username}/${widget.appointment.bookingId}/review',
          headers: header,
          body: json.encode(body));
      print(header);
      print(body);
      print(WebserviceConstants.baseAppointmentURL +
          '/v2/patient_appointment/${AppPreferences().deptmentName}/${AppPreferences().username}/${widget.appointment.bookingId}/review');
      print(response.body);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Review submitted succesfully", gravity: ToastGravity.TOP);
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
            msg: "Failed to submit the review", gravity: ToastGravity.TOP);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please fill the review and rating fields",
          gravity: ToastGravity.TOP);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Appointment Review", pageId: 0),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * .20,
                    //color: Colors.red,
                    child: widget.appointment.downloadProfileURL.length == 0
                        ? Image.asset(
                            'assets/images/doctor_image.png',
                            width: 100.0,
                            height: 100.0,
                          )
                        : CircleAvatar(
                            radius: 100.0,
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                                widget.appointment.downloadProfileURL),
                          )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Doctor Name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        "${widget.appointment.doctorFullName.length == 0 ? widget.appointment.doctorName : widget.appointment.doctorFullName}",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 13),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        "Booking ID",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        "${widget.appointment.bookingId}",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StarRating(
                    color: Colors.yellow,
                    rating: rate,
                    onRatingChanged: (rating) =>
                        setState(() => this.rate = rating),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Write a review :")),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: review,
                      maxLines: 10,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide:
                                new BorderSide(color: Colors.grey[100])),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: AppColors.primaryColor,
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      sendReview();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
