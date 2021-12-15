import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xman_mine_sweeper/data/constants.dart';
import 'package:xman_mine_sweeper/data/data.dart';
import 'package:xman_mine_sweeper/home/game_tile.dart';
import 'package:xman_mine_sweeper/home/user_circular_logo.dart';

import 'alert_dialog_settings.dart';
import 'board.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int grideW, grideL;
  late double mineProbability;
  late int countMine;
  late int countRelvealedTile;

  bool isfreshstart = true;
  // int min = 0;
  // int sec = 0;

  showSettingsDialog() {
    setState(() {
      Game.isgamepaused = true;
    });
    showDialog(
      context: context,
      builder: (contxt) {
        return AlertDialogSettings();
      },
    ).then((value) {
      setState(() {
        if (value == true) {
          setupGame();
        } else {
          Game.isgamepaused = false;
        }
      });
    });
  }

  @override
  void initState() {
    startGame();
    super.initState();
  }

  startGame() async {
    setupGame();
    await Game.getUsers();
    print(Game.defaultUser);
    setupGame();
    setState(() {});
  }

  setupGame() {
    Game.isgamepaused = false;
    Game.isgameover = false;
    Game.isgamestarted = false;
    Game.isgameOn = false;
    Game.isgamewon = false;

    grideL = Game.defaultHeight; //20;
    grideW = Game.defaultWidth; //12;
    mineProbability = Game.defaultProb; //.10;
    countMine = 0;
    countRelvealedTile = 0;

    Game.createFieldRectangle(grideL, grideW, mineProbability);

    for (int i = 0; i < grideL; i++) {
      for (int j = 0; j < grideW; j++) {
        if (Game.field[i][j].value == -1) {
          countMine += 1;
        }
      }
    }
  }

  tryRevealCell(i, j) {
    if (!Game.field[i][j].isFlaged) {
      if (!Game.field[i][j].isRevealed) {
        setState(() {
          Game.field[i][j].isRevealed = true;
          countRelvealedTile += 1;
        });
        if (Game.field[i][j].value == -1) {
          Game.isgameOn = false;
          Game.isgameover = true;
          restart(i: i, j: j);
          // setState(() {});
        } else if (Game.field[i][j].value == 0) {
          countRelvealedTile -= 1;
          Game.field[i][j].isRevealed = false;
          revealEmptyCells(i, j);
          setState(() {});
          checkwin();
        } else {
          checkwin();
        }
      }
    }
  }

  checkwin() {
    if (grideL * grideW - countRelvealedTile == countMine) {
      Game.isgamewon = true;
      Game.isgameOn = false;
      Game.isgameover = true;
      restart();
    }
  }

  revealEmptyCells(i, j) {
    if (!Game.field[i][j].isRevealed) {
      Game.field[i][j].isRevealed = true;
      Game.field[i][j].isFlaged = false;
      countRelvealedTile += 1;
      if (Game.field[i][j].value == 0) {
        for (int x = i - 1; x <= i + 1; x++) {
          for (int y = j - 1; y <= j + 1; y++) {
            if (x >= 0 && x < grideL && y >= 0 && y < grideW) {
              revealEmptyCells(x, y);
            }
          }
        }
      }
    }
  }

  revealNeighbourMines(i, j, {l = 1}) async {
    if (Game.points > 0) {
      for (int x = i - l; x <= i + l; x++) {
        for (int y = j - l; y <= j + l; y++) {
          if (x >= 0 && x < grideL && y >= 0 && y < grideW) {
            if (!(i == x && j == y) && Game.field[x][y].value == -1) {
              Game.field[x][y].isFlaged = true;
            }
          }
        }
      }
      Game.points -= 1;
      setState(() {});
      Game.savePoints();
    }
  }

  minI(x, y) {
    if (x < y) {
      return x;
    }
    return y;
  }

  maxI(x, y) {
    if (x < y) {
      return y;
    }
    return x;
  }

  revealAllCells({int i = 0, int j = 0}) {
    for (int l = 0; l <= grideW + grideL; l++) {
      int x = minI(l, grideL - 1);
      int y = maxI(l - grideL - 1, 0);
      while (x >= 0 && y < grideW) {
        if (!Game.field[x][y].isRevealed) {
          Game.field[x][y].isRevealed = true;
          Game.field[x][y].isFlaged = false;
          // });
        }
        x -= 1;
        y += 1;
      }
    }
  }

  restart({int i = 0, int j = 0}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    // print(sec);
    // setState(() {
    revealAllCells(i: i, j: j);
    setState(() {});
    // });

    // print(sec);
    await Future.delayed(const Duration(milliseconds: 2000));
    // print(sec);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            Game.isgamewon ? 'Yeh!, you won.' : 'Oh!, you loose it.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: XColor.basetextC),
          ),
          backgroundColor: XColor.baseC.withAlpha(150),
          actions: [
            Align(
              alignment: Alignment.center,
              child: TextButton.icon(
                onPressed: () {
                  setupGame();
                  setState(() {});
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.restart_alt, color: XColor.basetextC),
                label: const Text(
                  'Restart',
                  style: TextStyle(color: XColor.basetextC),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  pointsInfo() {
    showDialog(
        context: context,
        builder: (contx) {
          return AlertDialog(
            title: const Text(
              'Power Points',
              textAlign: TextAlign.center,
              style: TextStyle(color: XColor.basetextC),
            ),
            content: const Text(
              'Why rely on luck when you got special power. You can use the Power points to locate nearby mines by double tapping on any position. Remember!, this power will not take into account the tapping position.',
              style: TextStyle(color: Colors.grey),
            ),
            backgroundColor: XColor.baseC.withAlpha(150),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // print(countMine);
    // print(countRelvealedTile);
    // print(grideL * grideW);
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: CircleAvatar(
            maxRadius: 25,
            backgroundColor: XColor.basetextC,
            child: Image.asset(
              'assets/images/mine_icon.png',
              cacheWidth: 100,
              cacheHeight: 100,
              fit: BoxFit.contain,
              width: 30,
            ),
          ),
        ),
        title: const Text(
          "X-Mines",
          style: TextStyle(
              letterSpacing: 2,
              color: XColor.basetextC,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          // Align(
          //   child: GestureDetector(
          //     onTap: () {
          //       pointsInfo();
          //     },
          //     child: Container(
          //       padding:
          //           const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(50),
          //         border: Border.all(color: XColor.accentC, width: 2),
          //       ),
          //       child: Text(
          //         Game.points.toString(),
          //         style: const TextStyle(color: XColor.accentC, fontSize: 16),
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              showSettingsDialog();
            },
            child: UserLogo(name: Game.users[Game.defaultUser].name[0]),
          ),
          const SizedBox(width: 10),
        ],
        elevation: 0,
        backgroundColor: XColor.baseC,
      ),
      backgroundColor: XColor.baseC,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Divider(
              thickness: 2,
              height: 10,
              color: XColor.basetextC,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Board(
                      icon: Icon(
                        Icons.highlight_off_rounded,
                        color: XColor.basetextC.withAlpha(50),
                      ),
                      text: countMine.toString()),
                  InkWell(
                    onTap: () {
                      setupGame();
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: XColor.baseC,
                        boxShadow: const [
                          BoxShadow(
                            color: XColor.basedarkC,
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.restart_alt_rounded,
                        color: XColor.basetextC,
                        size: 24,
                      ),
                    ),
                  ),
                  Board(
                    icon: Icon(Icons.alarm,
                        color: XColor.basetextC.withAlpha(50)),
                    isgamestart: Game.isgamestarted,
                    isgameover: Game.isgameover,
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: grideW,
                    childAspectRatio: 1,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: grideL * grideW,
                  itemBuilder: (contx, index) {
                    int x, y;
                    x = (index / grideW).floor();
                    y = index % grideW;
                    return InkWell(
                        splashColor: XColor.basedarkC,
                        onLongPress: () {
                          if (!Game.field[x][y].isRevealed) {
                            setState(() {
                              Game.field[x][y].isFlaged ^= true;
                            });
                            checkwin();
                          }
                        },
                        onTap: () {
                          if (!Game.isgamestarted) {
                            Game.isgamestarted = true;
                            Game.isgameOn = true;
                            setState(() {});
                          }
                          tryRevealCell(x, y);
                        },
                        // onDoubleTap: () {
                        //   revealNeighbourMines(x, y);
                        // },
                        child: GameTile(
                          patch: Game.field[x][y],
                        ));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
