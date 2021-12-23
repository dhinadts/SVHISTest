import '../../ui/log_reports/chart_state.dart';
import '../../ui/log_reports/report_card.dart';
import 'package:flutter/material.dart';

import 'bp_report_card.dart';

class LogbookSummaryScreen extends StatelessWidget {
  const LogbookSummaryScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            BPReportCard(showDetails: true),
            ReportCard<BMIData>(showDetails: true),
            ReportCard<BloodSugarData>(showDetails: true),
            ReportCard<Hba1cData>(showDetails: true),
            Container(height: 30),
          ],
        ),
      ),
    );
  }
}
