import 'package:collect/collect.dart';

Future<void> main() async {
  print(await Fonts().loadAllFonts());
}

// import 'package:collect/collect.dart';
// import 'package:example/icons.dart';
// import 'package:flutter/material.dart';
//
// Colour colour = Colours.white;
//
// void main() {
//   runApp(Main());
// }
//
// class Main extends StatelessWidget {
//   const Main({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: AppTheme.light(),
//       home: Scaffold(
//         backgroundColor: AppTheme.background(context),
//         body: SizedBox(
//           height: MediaQuery
//               .of(context)
//               .size
//               .height * 1,
//           width: MediaQuery
//               .of(context)
//               .size
//               .width * 1,
//           child: Center(
//             child: Container(
//               // child: ColourPicker.wheel(
//               //   height: 250,
//               //   width: 800,
//               //   currentColour: colour,
//               //   onColorChanged: (value) {
//               //     print(value);
//               //   },
//               // ),
//               child: Icon(MyFlutterApp.format_colour_fill),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
