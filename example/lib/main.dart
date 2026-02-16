import 'package:collect/collect.dart';
import 'package:flutter/material.dart';

Colour colour = Colours.white;
List<MenuItem> menuItems = [
  MenuItem(value: 'first'),
  MenuItem(value: 'second'),
  MenuItem(value: 'third'),
  MenuItem(value: 'fourth'),
  MenuItem(value: 'fifth'),
];
List<String> menuValues = ['first', 'second', 'third', 'fourth', 'fifth'];

void main() {
  runApp(MenuDemo());
}

class MenuDemo extends StatefulWidget {
  const MenuDemo({super.key});

  @override
  State<MenuDemo> createState() => _MenuDemoState();
}

class _MenuDemoState extends State<MenuDemo> {
  TextEditingController controller = TextEditingController();
  String selected = menuItems[0].value;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      print(controller.text);
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: Center(
            child: MenuTextField(
              items: menuItems,
              controller: controller,
              enableSearch: true,
              enableFilter: true,
              selected: selected,
              width: 500,
              onSelected: (newValue) {
                controller.text = newValue;
                selected = newValue;
                setState(() {});
              },
            ),
          ),
        ),
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: Center(
            child: ColourPicker.wheel(
              style: PickerStyle(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(10),
              ),
              size: 500,
              currentColour: colour,
              onColourChanged: (value) {
                colour = value.colour;
                setState(() {});
              },
            ),
          ),
        ),
      ),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 1300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ColourPicker.wheel(
                      currentColour: colour,
                      onColourChanged: (value) {
                        colour = value.colour;
                        setState(() {});
                      },
                    ),
                    Container(
                      color: Colours.blueGrey,
                      height: 250,
                      width: 800,
                      child: ColourPicker.slides(
                        currentColour: colour,
                        onColorChanged: (value) {
                          colour = value.colour;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 2000,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ColourPicker.ring(
                      currentColour: colour,
                      onColorChanged: (value) {
                        colour = value.colour;
                        setState(() {});
                      },
                    ),
                    ColourPicker.square(
                      currentColour: colour,
                      onColorChanged: (value) {
                        colour = value.colour;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
