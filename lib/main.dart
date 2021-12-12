import 'package:flutter/material.dart';

import 'data/data.dart';
import 'home/homepage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'X-Mines',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const HomePage(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   double width = 0.0;
//   int countWidth = 12;
//   int countMine = 20;
//   int countRevealed = 0;
//   late int totalCount;
//   late List<String> patches;
//   late List<bool> isrevealed;
//   late List<bool> isflaged;

//   setup() {
//     //inilizing
//     totalCount = countWidth * countWidth;
//     countRevealed = 0;
//     isrevealed = List.generate(totalCount, (index) => false);
//     isflaged = List.generate(totalCount, (index) => false);

//     //generating mines
//     List<List<int>> mines = List.generate(countWidth, (index) {
//       return List.generate(countWidth, (indexi) => 0);
//     });
//     var rand = Random();
//     int x, y;
//     for (int i = 0; i < countMine; i++) {
//       while (true) {
//         x = rand.nextInt(countWidth);
//         y = rand.nextInt(countWidth);
//         if (mines[x][y] != -1) {
//           mines[x][y] = -1;
//           break;
//         }
//       }
//     }
//     // ignore: avoid_print
//     print(mines);

//     for (int x = 0; x < countWidth; x++) {
//       for (int y = 0; y < countWidth; y++) {
//         if (mines[x][y] == -1) {
//           for (int i = x - 1; i <= x + 1; i++) {
//             for (int j = y - 1; j <= y + 1; j++) {
//               if (i >= 0 &&
//                   i < countWidth &&
//                   j >= 0 &&
//                   j < countWidth &&
//                   mines[i][j] != -1) {
//                 mines[i][j] += 1;
//               }
//             }
//           }
//         }
//       }
//     }

//     patches = [];
//     for (int i = 0; i < countWidth; i++) {
//       for (int j = 0; j < countWidth; j++) {
//         if (mines[i][j] == -1) {
//           patches.add('X');
//         } else {
//           patches.add(mines[i][j].toString());
//         }
//       }
//     }
//   }

//   // late Animation _animation;

//   @override
//   void initState() {
//     // _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
//     // _animation = Tween(begin: 0, end: 3).animate(_controller);

//     setup();
//     super.initState();
//   }

//   Future revealN(int index) async {
//     if (!isrevealed[index]) {
//       isrevealed[index] = true;
//       isflaged[index] = false;
//       countRevealed += 1;
//       if (patches[index] == '0') {
//         if (index + countWidth < totalCount) {
//           if (index % countWidth != 0) {
//             revealN(index + countWidth - 1);
//           }
//           if (index % countWidth != countWidth - 1) {
//             revealN(index + countWidth + 1);
//           }
//           revealN(index + countWidth);
//         }
//         if (index - countWidth >= 0) {
//           if (index % countWidth != 0) {
//             revealN(index - countWidth - 1);
//           }
//           if (index % countWidth != countWidth - 1) {
//             revealN(index - countWidth + 1);
//           }
//           revealN(index - countWidth);
//         }
//         if (index % countWidth != 0) {
//           revealN(index - 1);
//         }
//         if (index % countWidth != (countWidth - 1)) {
//           revealN(index + 1);
//         }
//       }
//     }
//   }

//   alert(String text) {
//     for (int i = 0; i < totalCount; i++) {
//       isflaged[i] = false;
//       isrevealed[i] = true;
//     }
//     setState(() {});

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(
//             text,
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Colors.brown[100]),
//           ),
//           backgroundColor: Colors.brown[800]!.withAlpha(200),
//           actions: [
//             Align(
//               alignment: Alignment.center,
//               child: TextButton.icon(
//                 onPressed: () {
//                   setup();
//                   Navigator.of(context).pop();
//                   setState(() {});
//                 },
//                 icon: Icon(Icons.restart_alt, color: Colors.brown[300]),
//                 label: Text(
//                   'Restart',
//                   style: TextStyle(color: Colors.brown[300]),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // restart(){
//   //   setup();

//   // }

//   @override
//   Widget build(BuildContext context) {
//     width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Colors.teal,
//       appBar: AppBar(
//         title: Text(
//           widget.title,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               setup();
//               setState(() {});
//             },
//             icon: const Icon(Icons.restart_alt_rounded),
//           ),
//         ],
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Container(
//             margin: const EdgeInsets.all(8),
//             height: 150,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: Colors.brown[700],
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Text(
//                       'Matrix',
//                       style: TextStyle(color: Colors.brown[100], fontSize: 20),
//                     ),
//                     SizedBox(
//                       width: 100,
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           GestureDetector(
//                               onTap: () {
//                                 countWidth = 8;
//                                 setup();
//                                 // _controller.
//                                 setState(() {});
//                               },
//                               child: Text(
//                                 '8',
//                                 style: TextStyle(
//                                     color: Colors.brown[200],
//                                     fontSize: (countWidth == 8) ? 20 : 15),
//                               )),
//                           GestureDetector(
//                               onTap: () {
//                                 countWidth = 10;
//                                 setup();
//                                 // _controller.
//                                 setState(() {});
//                               },
//                               child: Text(
//                                 '10',
//                                 style: TextStyle(
//                                     color: Colors.brown[200],
//                                     fontSize: (countWidth == 10) ? 20 : 15),
//                               )),
//                           GestureDetector(
//                               onTap: () {
//                                 countWidth = 12;
//                                 setup();
//                                 setState(() {});
//                                 // _controller.
//                               },
//                               child: Text(
//                                 '12',
//                                 style: TextStyle(
//                                     color: Colors.brown[200],
//                                     fontSize: (countWidth == 12) ? 20 : 15),
//                               )),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Text(
//                       'Mines',
//                       style: TextStyle(color: Colors.brown[100], fontSize: 20),
//                     ),
//                     SizedBox(
//                       width: 100,
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           GestureDetector(
//                               onTap: () {
//                                 countMine = 10;
//                                 setup();
//                                 // _controller.
//                                 setState(() {});
//                               },
//                               child: Text(
//                                 '10',
//                                 style: TextStyle(
//                                     color: Colors.brown[200],
//                                     fontSize: (countMine == 10) ? 20 : 15),
//                               )),
//                           GestureDetector(
//                               onTap: () {
//                                 countMine = 20;
//                                 // _controller.
//                                 setup();
//                                 setState(() {});
//                               },
//                               child: Text(
//                                 '20',
//                                 style: TextStyle(
//                                     color: Colors.brown[200],
//                                     fontSize: (countMine == 20) ? 20 : 15),
//                               )),
//                           GestureDetector(
//                               onTap: () {
//                                 countMine = 30;
//                                 setup();
//                                 setState(() {});
//                                 // _controller.
//                               },
//                               child: Text(
//                                 '30',
//                                 style: TextStyle(
//                                     color: Colors.brown[200],
//                                     fontSize: (countMine == 30) ? 20 : 15),
//                               )),
//                         ],
//                       ),
//                     ),
//                     // Text(countMine.toString(), style: TextStyle(color: Colors.brown[200], fontSize: 15),),
//                   ],
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             width: width - 20,
//             height: width - 20,
//             child: GridView.builder(
//               itemCount: totalCount,
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: countWidth,
//                 crossAxisSpacing: 2,
//                 mainAxisSpacing: 2,
//               ),
//               itemBuilder: (ctx, index) {
//                 return GestureDetector(
//                   onLongPress: () {
//                     if (!isrevealed[index]) {
//                       isflaged[index] ^= true;
//                       setState(() {});
//                     }
//                   },
//                   onTap: () async {
//                     if (!isflaged[index] && !isrevealed[index]) {
//                       if (patches[index] == 'X') {
//                         alert('Oh! You Loose it.');
//                       } else if (patches[index] == '0') {
//                         await revealN(index);
//                         setState(() {});
//                       } else {
//                         setState(() {
//                           isrevealed[index] = true;
//                           countRevealed += 1;
//                         });
//                       }

//                       if (countMine == totalCount - countRevealed) {
//                         alert('Yeh! You Won.');
//                       }
//                     }
//                   },
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 400),
//                     margin: (isrevealed[index])
//                         ? const EdgeInsets.all(2.0)
//                         : const EdgeInsets.all(0.0),
//                     decoration: BoxDecoration(
//                       border: (!isrevealed[index] || patches[index] == '0')
//                           ? null
//                           : Border.all(
//                               width: 2,
//                               color: (patches[index] == 'X')
//                                   ? Colors.red
//                                   : Colors.brown[500]!),
//                       color: (!isrevealed[index])
//                           ? Colors.brown[700]
//                           : (patches[index] == 'X')
//                               ? Colors.red
//                               : Colors.white,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     alignment: Alignment.center,
//                     child: (isflaged[index])
//                         ? Icon(
//                             Icons.flag,
//                             color: Colors.brown[100],
//                           )
//                         : (isrevealed[index] && patches[index] != '0')
//                             ? Text(patches[index])
//                             : null,
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
