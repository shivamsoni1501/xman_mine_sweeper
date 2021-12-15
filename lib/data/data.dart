import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Patch {
  int x;
  int y;
  bool isRevealed = false;
  bool isFlaged = false;
  int value = 0;

  int index(int columnW) {
    return x * columnW + y;
  }

  Patch({required this.x, required this.y});
}

class Game {
  static bool isgamestarted = false;
  static bool isgameOn = false;
  static bool isgamepaused = false;
  static bool isgameover = false;
  static bool isgamewon = false;

  static List<User> users = [User()];
  static int defaultUser = 0;

  static List<List<Patch>> field = [];
  static List<int> fWidth = [8, 9, 10, 11, 12];

  static List<int> fHeight = [8, 12, 16, 20, 24];

  static int points = 0;

  static List<double> fProb = [
    .1,
    .15,
    .2,
    .25,
    .3,
  ];

  static int defaultWidth = 10;
  static int defaultHeight = 16;
  static double defaultProb = 0.15;

  static getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Game.defaultUser = prefs.getInt('defaultUser') ?? 0;
    Game.defaultWidth = prefs.getInt('defaultWidth') ?? 10;
    Game.defaultHeight = prefs.getInt('defaultHeight') ?? 16;
    Game.defaultProb = prefs.getDouble('defaultProb') ?? .15;
    Game.points = prefs.getInt('points') ?? 5;
    Game.users = (prefs.getStringList('users') ?? [User().toJson()])
        .map((e) => User.fromJson(e))
        .toList();
    // return users;
  }

  static saveUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('defaultUser', Game.defaultUser);
    // await saveDefaultLayout();
    prefs.setStringList('users', Game.users.map((e) => e.toJson()).toList());
  }

  static saveDefaultUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('defaultUser', Game.defaultUser);
  }

  static saveDefaultLayout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('defaultWidth', Game.defaultWidth);
    prefs.setInt('defaultHeight', Game.defaultHeight);
    prefs.setDouble('defaultProb', Game.defaultProb);
  }

  static savePoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('points', Game.points);
  }

  static createFieldSquare(int n, double prob) {
    Game.field =
        List.generate(n, (i) => List.generate(n, (j) => Patch(x: i, y: j)));
    var random = Random();
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (random.nextDouble() <= prob) {
          Game.field[i][j].value = -1;
          for (int r = i - 1; r <= i + 1; r++) {
            for (int c = j - 1; c <= j + 1; c++) {
              if (r >= 0 &&
                  r < n &&
                  c >= 0 &&
                  c < n &&
                  Game.field[r][c].value != -1) {
                Game.field[r][c].value += 1;
              }
            }
          }
        }
      }
    }
  }

  static createFieldRectangle(int l, int w, double prob) {
    Game.field =
        List.generate(l, (i) => List.generate(w, (j) => Patch(x: i, y: j)));
    var random = Random();
    int cmines = (l * w * prob + (5 * random.nextDouble())).floor() + 1;
    int count = 0;
    while (count < cmines) {
      int i = random.nextInt(l);
      int j = random.nextInt(w);
      if (Game.field[i][j].value != -1) {
        count += 1;
        Game.field[i][j].value = -1;
        for (int r = i - 1; r <= i + 1; r++) {
          for (int c = j - 1; c <= j + 1; c++) {
            if (r >= 0 &&
                r < l &&
                c >= 0 &&
                c < w &&
                Game.field[r][c].value != -1) {
              Game.field[r][c].value += 1;
            }
          }
        }
      }
    }
    // for (int i = 0; i < l; i++) {
    //   for (int j = 0; j < w; j++) {
    //     if (random.nextDouble() <= prob) {
    //       Game.field[i][j].value = -1;
    //       for (int r = i - 1; r <= i + 1; r++) {
    //         for (int c = j - 1; c <= j + 1; c++) {
    //           if (r >= 0 &&
    //               r < l &&
    //               c >= 0 &&
    //               c < w &&
    //               Game.field[r][c].value != -1) {
    //             Game.field[r][c].value += 1;
    //           }
    //         }
    //       }
    //     }
    //   }
    // }
  }
}

class User {
  String name;
  int sec = 0;
  int min = 0;
  User({this.name = 'Guest', this.sec = 0, this.min = 0});

  static User fromJson(String s) {
    dynamic obj = jsonDecode(s);
    return User(name: obj['name'], min: obj['min'], sec: obj['sec']);
  }

  String toJson() {
    String s = jsonEncode({'name': name, 'sec': sec, 'min': min});
    print(s);
    return s;
  }
}
