import 'package:flutter/material.dart';

class ScreenShareMessageWidget extends StatelessWidget {
  final String name;
  final int uid;
  final IconData icon;
  final Color color;
  final Color textColor;
  final Function iconTapped;

  const ScreenShareMessageWidget({
    @required this.name,
    @required this.uid,
    this.icon = Icons.info_outline,
    this.color = Colors.redAccent,
    this.textColor = Colors.white,
    @required this.iconTapped,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: iconTapped,
      child: Container(
        color: color,
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: textColor,
                size: 24,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    "$name has started screen sharing",
                    style: TextStyle(color: textColor, fontSize: 12),
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    size: 32,
                  ),
                  color: textColor,
                  onPressed: iconTapped)
            ],
          ),
        ),
      ),
    );
  }
}
