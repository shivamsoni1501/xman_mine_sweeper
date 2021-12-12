import 'package:flutter/material.dart';
import 'package:xman_mine_sweeper/data/constants.dart';
import 'package:xman_mine_sweeper/data/data.dart';
import 'package:xman_mine_sweeper/home/user_circular_logo.dart';

class UsersListTile extends StatelessWidget {
  UsersListTile({Key? key, required this.user}) : super(key: key);
  User user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 200,
      child: Row(
        children: [
          UserLogo(name: user.name[0]),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  color: XColor.basetextC,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${user.min.toString().padLeft(2, '0')}:${user.sec.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              )
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
