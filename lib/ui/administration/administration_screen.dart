import '../../ui/administration/user_list_account_unlock.dart';
import 'package:flutter/material.dart';
import '../custom_drawer/custom_app_bar.dart';
import 'change_branch.dart';

class AdministrationScreen extends StatefulWidget {
  final String title;
  AdministrationScreen({this.title = "Admin"});
  @override
  _AdministrationScreenState createState() => _AdministrationScreenState();
}

class _AdministrationScreenState extends State<AdministrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageId: null,
        title: widget.title,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BranchChange()));
              },
              child: ListTile(
                title: Text("Branch Change"),
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 1.0,
            ),
            // InkWell(
            //   onTap: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => UserListAccountUnlockScreen(title:"Account Unlock / Change Password")));
            //   },
            //   child: ListTile(
            //     title: Text("Account Unlock / Change Password"),
            //   ),
            // ),
            // Divider(
            //   color: Colors.grey,
            //   height: 1.0,
            // ),
            // InkWell(
            //   child: ListTile(
            //     title: Text("Reminders"),
            //   ),
            // ),
            // Divider(
            //   color: Colors.grey,
            //   height: 1.0,
            // ),
          ],
        ),
      ),
    );
  }
}
