// import 'package:flutter/material.dart';
// // import 'package:flutter/rendering.dart';

// const String cms = "Collage Management System";
// const Color grayColor = Color(0xFFA9A9A9);
// const Color darkBlue = Color(0xFF167AFA);
// const Color darkBlack = Color.fromARGB(255, 0, 0, 0);
// const Color blueColor = Colors.pink;
// // const Color blueColor = Color(0xFF167AFA);
// const Color cardTextColor = Colors.white;
// const Color backgroundColor = Color(0xFFF5F7FA);
// const Color whiteColor = Colors.white;
// DateTime selectedMonth = DateTime(2025, 3, 1); // Initialize with March 2025

// class ThemeSelector extends StatelessWidget {
//   const ThemeSelector({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String cms = "Collage Management System";
const Color grayColor = Color.fromARGB(255, 170, 169, 169);
const Color darkBlue = Color.fromARGB(255, 22, 122, 250);
const Color darkBlack = Color.fromARGB(255, 0, 0, 0);
Color blueColor = Colors.blue; // global theme color
const Color cardTextColor = Colors.white;
const Color backgroundColor = Color.fromARGB(255, 243, 245, 248);
const Color whiteColor = Colors.white;
DateTime selectedMonth = DateTime(2025, 3, 1);

class ThemeSelector extends StatefulWidget {
  const ThemeSelector({super.key});

  @override
  State<ThemeSelector> createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector>
    with SingleTickerProviderStateMixin {
  final List<Color> colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.amber,
    Colors.cyan,
    Colors.indigo,
    Colors.lime,
    Colors.deepPurple,
    Colors.deepOrange,
    Colors.yellow,
    Colors.brown,
    Colors.grey,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.blueGrey,
    Colors.red,
    Colors.redAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.tealAccent,
    Colors.amberAccent,
    Colors.cyanAccent,
    Colors.indigoAccent,
    Colors.limeAccent,
    Colors.deepOrangeAccent,
    Colors.deepPurpleAccent,
    Colors.lightBlueAccent,
    Colors.lightGreenAccent,
    Colors.pinkAccent,
    Colors.yellowAccent,
    Colors.brown.shade300,
    Colors.brown.shade500,
    Colors.blue.shade200,
    Colors.blue.shade700,
    Colors.green.shade200,
    Colors.green.shade700,
    Colors.orange.shade200,
    Colors.orange.shade700,
    Colors.purple.shade200,
    Colors.purple.shade700,
    Colors.teal.shade200,
    Colors.teal.shade700,
  ];

  final List<String> colorNames = [
    "Blue",
    "Green",
    "Orange",
    "Purple",
    "Pink",
    "Teal",
    "Amber",
    "Cyan",
    "Indigo",
    "Lime",
    "Deep Purple",
    "Deep Orange",
    "Yellow",
    "Brown",
    "Grey",
    "Light Blue",
    "Light Green",
    "Orange Accent",
    "Purple Accent",
    "Blue Grey",
    "Red",
    "Red Accent",
    "Green Accent",
    "Blue Accent",
    "Teal Accent",
    "Amber Accent",
    "Cyan Accent",
    "Indigo Accent",
    "Lime Accent",
    "Deep Orange Accent",
    "Deep Purple Accent",
    "Light Blue Accent",
    "Light Green Accent",
    "Pink Accent",
    "Yellow Accent",
    "Brown 300",
    "Brown 500",
    "Blue 200",
    "Blue 700",
    "Green 200",
    "Green 700",
    "Orange 200",
    "Orange 700",
    "Purple 200",
    "Purple 700",
    "Teal 200",
    "Teal 700",
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedColor();
  }

  Future<void> _loadSavedColor() async {
    final prefs = await SharedPreferences.getInstance();
    int? colorValue = prefs.getInt('themeColor');
    if (colorValue != null) {
      setState(() {
        blueColor = Color(colorValue);
      });
    }
  }

  Future<void> _saveSelectedColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeColor', color.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cms), backgroundColor: blueColor),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemCount: colors.length,
          itemBuilder: (context, index) {
            final color = colors[index];
            final colorName = colorNames[index];
            final isSelected = blueColor == color;

            // Choose text color for readability
            final textColor =
                color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

            return GestureDetector(
              onTap: () {
                setState(() {
                  blueColor = color;
                  _saveSelectedColor(color);
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  gradient:
                      isSelected
                          ? LinearGradient(
                            colors: [color.withOpacity(0.7), color],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                          : null,
                  color: isSelected ? null : color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isSelected ? color.withOpacity(0.5) : Colors.black26,
                      offset: const Offset(0, 6),
                      blurRadius: 10,
                    ),
                  ],
                  border:
                      isSelected
                          ? Border.all(width: 3, color: Colors.black)
                          : null,
                ),
                child: Stack(
                  children: [
                    Center(
                      child:
                          isSelected
                              ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 32,
                              )
                              : null,
                    ),
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Text(
                        colorName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
