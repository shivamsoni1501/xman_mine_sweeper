import 'package:flutter/material.dart';
import 'package:xman_mine_sweeper/data/constants.dart';
import 'package:xman_mine_sweeper/data/data.dart';

import 'users_list_tile.dart';

class AlertDialogSettings extends StatelessWidget {
  AlertDialogSettings({Key? key}) : super(key: key);
  late TextEditingController newuser;

  int dwidth = Game.defaultWidth;
  int dheight = Game.defaultHeight;
  double dprob = Game.defaultProb;

  @override
  Widget build(BuildContext context) {
    bool isAddingUser = false;
    bool ischanedLaout = false;
    return StatefulBuilder(builder: (context, setState) {
      newuser = TextEditingController();
      return AlertDialog(
        backgroundColor: XColor.baseC,
        title: DropdownButton<int>(
          value: Game.defaultUser,
          underline: const SizedBox(),
          dropdownColor: XColor.baseC,
          onChanged: (int? s) {
            setState(() {
              Game.defaultUser = s ?? 0;
            });
            Game.saveDefaultUser();
          },
          icon: const Icon(Icons.arrow_drop_down_circle_rounded),
          items: Game.users
              .map(
                (e) => DropdownMenuItem(
                  value: Game.users.indexOf(e),
                  child: UsersListTile(user: e),
                ),
              )
              .toList(),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (isAddingUser)
                  Expanded(
                    child: TextField(
                      cursorColor: XColor.basetextC,
                      decoration: InputDecoration(
                        focusColor: Colors.white,
                        label: const Text('Name'),
                        labelStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      controller: newuser,
                      style: const TextStyle(color: XColor.basetextC),
                    ),
                  ),
                FlatButton.icon(
                  icon: const Icon(Icons.person_add),
                  // color: XColor.greenC,
                  textColor: Colors.grey,
                  // style: ButtonStyle(foregroundColor: XColor.greenC,),
                  onPressed: () {
                    setState(() {
                      if (isAddingUser) {
                        String name = newuser.text.trim().toUpperCase();
                        if (name.isNotEmpty) {
                          Game.defaultUser = Game.users.length;
                          Game.users.add(User(name: name));
                          Game.saveUsers();
                        } else {
                          newuser.clear();
                        }
                      }
                      isAddingUser ^= true;
                    });
                    // print(isAddingUser);
                  },
                  label: Text((isAddingUser) ? 'Add' : 'Add User'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(
              color: XColor.basetextC,
              thickness: 2,
              height: 2,
            ),
            const SizedBox(height: 10),
            const Text(
              'Field Width',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Wrap(
              runSpacing: 5,
              spacing: 8,
              children: Game.fWidth
                  .map((e) => GestureDetector(
                      onTap: () {
                        ischanedLaout = true;
                        setState(() {
                          dwidth = e;
                        });
                      },
                      child: SBox(
                          text: e.toString(), defaultT: dwidth.toString())))
                  .toList(),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Field Height',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Wrap(
              runSpacing: 5,
              spacing: 8,
              children: Game.fHeight
                  .map((e) => GestureDetector(
                      onTap: () {
                        ischanedLaout = true;
                        setState(() {
                          dheight = e;
                        });
                      },
                      child: SBox(
                        text: e.toString(),
                        defaultT: dheight.toString(),
                      )))
                  .toList(),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Mine Probability',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Wrap(
              runSpacing: 5,
              spacing: 8,
              children: Game.fProb
                  .map((e) => GestureDetector(
                      onTap: () {
                        ischanedLaout = true;
                        setState(() {
                          dprob = e;
                        });
                      },
                      child: SBox(
                        text: e.toString(),
                        defaultT: dprob.toString(),
                      )))
                  .toList(),
            ),
          ],
        ),
        actions: [
          if (ischanedLaout)
            TextButton.icon(
                onPressed: () {
                  Game.defaultHeight = dheight;
                  Game.defaultWidth = dwidth;
                  Game.defaultProb = dprob;
                  Game.saveDefaultLayout();
                  Navigator.of(context).pop(true);
                },
                icon: const Icon(Icons.save_rounded),
                label: const Text('Save'))
        ],
      );
    });
  }
}

class SBox extends StatelessWidget {
  SBox({Key? key, required this.text, required this.defaultT})
      : super(key: key);
  final String text;
  String defaultT;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: XColor.basedarkC, width: 5),
        borderRadius: BorderRadius.circular(10),
        color: (text == defaultT) ? XColor.basedarkC : null,
      ),
      child: Text(
        text,
        style: const TextStyle(color: XColor.basetextC),
      ),
    );
  }
}
