import '../../ui/advertise/adWidget.dart';
import 'package:flutter/material.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/app_preferences.dart';

// final List<String> _benefits = [
//   "Placement and job opportunities guidance for India and Abroad.",
//   "Legal guidance for nurses",
//   "Supporting for GNAT member's higher education. (eg. PBBSc(N), Msc(N), PhD(N))",
//   "Organising training programs for state and central government jobs.",
//   "Guiding coaching classes for abroad exams",
//   "Donating blood and providing medical assistant for GNAT members and their family.",
//   "Helping poor and needy nurses.",
//   "Free career guidance for student nurses.",
//   "Providing Health insurance to the members on request.",
//   "Engage members by providing knowledge Refreshment",
//   "Notifying current updates in the nursing profession and entire health care delivery system",
//   "Organising webinars/ Seminars/ Conferences/ Workshops/ Skill training to share the knowledge and get latest updates.",
//   "Conducting events on  the world health days to create awareness to all communities.",
//   "Taking part of the welfare of nurses.",
//   "Raising voice for nurses in need. Stand for Nurses rights and welfare as a family.",
//   "Connecting network between nurses in India and abroad.",
//   "Getting concessions through GNAT reference and enjoy medical and also other benefits.",
//   "Research studies conducted regularly for the benefits of the members.",
//   "Share your thoughts and ideas to the nurses in worldwide via GNAT NURSES TODAY.",
//   "Guest room facilities arrangement on request only for the active members.",
// ];

class MembershipBenefits extends StatefulWidget {
  @override
  _MembershipBenefitsState createState() => _MembershipBenefitsState();
}

class _MembershipBenefitsState extends State<MembershipBenefits> {
  bool isDataLoaded = false;

  List<String> benefitsData; // = _benefits;

  @override
  initState() {
    super.initState();
    benefitsData = List<String>();
    getBenefitsContent();

    /// Initialize Admob
    initializeAd();
  }

  getBenefitsContent() async {
    String data = await AppPreferences.getMembershipBenefitsContent();
    if (data.isNotEmpty) {
      setState(() {
        isDataLoaded = true;
        benefitsData = data.split('\\n');
        // print(benefitsData);
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        brightness: Brightness.light,
        title:
            Text("Membership Benefits", style: TextStyle(color: Colors.white)),
      ),
      body: isDataLoaded
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, i) =>
                        benefitsData[i].trim().length > 0
                            ? Container(
                                margin: const EdgeInsets.all(18)
                                    .copyWith(top: i == 0 ? 18 : 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Flexible(
                                    //   fit: FlexFit.tight,
                                    //   flex: 1,
                                    //   child: Text('${i + 1}.'),
                                    // ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 12,
                                      child: Text(
                                          "${benefitsData[i]}${benefitsData[i].endsWith('.') ? '' : '.'}"),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                    itemCount: benefitsData.length,
                  ),
                ),

                /// Show Banner Ad
                getSivisoftAdWidget(),
              ],
            )
          : LinearProgressIndicator(),
    );
  }
}
