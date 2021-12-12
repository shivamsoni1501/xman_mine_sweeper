import 'package:flutter/material.dart';
import 'package:xman_mine_sweeper/data/constants.dart';

class UserLogo extends StatelessWidget {
  UserLogo({Key? key, required this.name}) : super(key: key);
  String name;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: XColor.basedarkC,
      child: Text(
        name,
        style: const TextStyle(
            color: XColor.basetextC, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
