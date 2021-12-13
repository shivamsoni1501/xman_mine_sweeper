import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xman_mine_sweeper/data/constants.dart';
import 'package:xman_mine_sweeper/data/data.dart';

class Board extends StatefulWidget {
  Board({
    Key? key,
    required this.icon,
    this.text = 'timer',
    this.isgamestart = false,
    this.isgameover = false,
  }) : super(key: key);
  IconData icon;
  String text;
  bool isgamestart;
  bool isgameover;

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  int sec = 0;
  int min = 0;
  bool istimerOn = false;
  bool isfirst = true;

  @override
  void initState() {
    super.initState();
  }

  timer() {
    if (!istimerOn) {
      sec = 0;
      min = 0;
      isfirst = true;
      istimerOn = true;
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (Game.isgameOn) {
          if (!Game.isgamepaused) {
            setState(() {
              sec += 1;
              if (sec == 60) {
                min += 1;
                sec = 0;
              }
            });
            // print(sec);
          }
        } else {
          if (isfirst && Game.isgamewon) {
            isfirst = false;
            User _user = Game.users[Game.defaultUser];
            print('Game won');
            print(sec);
            if ((_user.min == 0 && _user.sec == 0) ||
                ((_user.min > min) ||
                    ((_user.min == min) && _user.sec > sec))) {
              print('saving');
              _user.min = min;
              _user.sec = sec;
              print(_user.sec);
              Game.saveUsers();
            }
          }

          if (!Game.isgameover) {
            setState(() {
              istimerOn = false;
              sec = 0;
              min = 0;
            });
            timer.cancel();
          }
        }
      });
      // istimerOn = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build $widget.text');
    if (widget.text == 'timer' &&
        widget.isgamestart &&
        !widget.isgameover &&
        !istimerOn) {
      print('Timer');
      timer();
    }
    return Container(
      width: 100,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: XColor.basedarkC,
          ),
          BoxShadow(
            color: XColor.baseC,
            spreadRadius: -2.0,
            blurRadius: 7.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.icon, color: XColor.basetextC.withAlpha(50)),
          const SizedBox(width: 10),
          Text(
            (widget.text == "timer")
                ? '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}'
                : widget.text,
            style: const TextStyle(color: XColor.basetextC),
          ),
        ],
      ),
    );
  }
}
