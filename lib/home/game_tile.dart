import 'package:flutter/material.dart';
import 'package:xman_mine_sweeper/data/constants.dart';
import 'package:xman_mine_sweeper/data/data.dart';

class GameTile extends StatelessWidget {
  GameTile({Key? key, required this.patch}) : super(key: key);
  Patch patch;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          if (patch.value != 0)
            const BoxShadow(
              color: XColor.basedarkC,
            ),
          BoxShadow(
            color: (patch.isRevealed) ? XColor.baseC : XColor.baselightC,
            spreadRadius: (patch.isRevealed) ? -1.0 : 0.0,
            blurRadius: (patch.isRevealed) ? 4.0 : 0.0,
          ),
        ],
        border: Border.all(
          color: (!patch.isRevealed)
              ? Colors.black
              : (patch.value == -1)
                  ? ((Game.isgamewon) ? XColor.greenC : XColor.redC)
                  : Colors.transparent,
        ),
      ),
      alignment: Alignment.center,
      child: (patch.isFlaged)
          ? const Icon(
              Icons.flag_outlined,
              color: XColor.accentC,
            )
          : (!patch.isRevealed || patch.value == 0)
              ? null
              : (patch.value == -1)
                  ? (Game.isgamewon)
                      ? Image.asset(
                          'assets/images/safe_mine-1.png',
                          cacheHeight: 50,
                          cacheWidth: 50,
                        )
                      : Image.asset(
                          'assets/images/d_mine.png',
                          cacheHeight: 50,
                          cacheWidth: 50,
                        )
                  : Text(
                      patch.value.toString(),
                      style: const TextStyle(color: XColor.basetextC),
                    ),
    );
  }
}
