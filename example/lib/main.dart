import 'package:collect/collect.dart';
import 'package:flutter/material.dart';

List<String> menuValues = ['first', 'second', 'third', 'fourth', 'fifth'];
Colour colour = Colours.white;
List<MenuItem> menuItems = [
  MenuItem(label: 'First', value: '1'),
  MenuItem(label: 'Second', value: '2'),
  MenuItem(label: 'Third', value: '3'),
  MenuItem(label: 'Fourth', value: '4'),
  MenuItem(label: 'Fifth', value: '5'),
];

void main() {
  runApp(MenuDemo());
}

class MenuDemo extends StatefulWidget {
  const MenuDemo({super.key});

  @override
  State<MenuDemo> createState() => _MenuDemoState();
}

class _MenuDemoState extends State<MenuDemo> {
  String selected = menuItems[0].value;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          color: AppTheme.background(context),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Menu(
                  items: menuItems,
                  width: 500,
                  height: 40,
                  menuConfig: MenuConfig(searchable: true),
                  onSelected: (item) {
                    setState(() {
                      selected = item.value;
                    });
                    print('Selected: ${item.label} (${item.value})');
                  },
                ),
                SizedBox(height: 20),
                Word('Selected value: $selected'),
              ],
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
