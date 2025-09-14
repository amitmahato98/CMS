import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Global theme color
Color blueColor = const Color(0xFF2196F3);

const String cms = "Collage Management System";
const Color grayColor = Color.fromARGB(255, 170, 169, 169);
const Color darkBlue = Color.fromARGB(255, 22, 122, 250);
const Color darkBlack = Color.fromARGB(255, 0, 0, 0);
const Color cardTextColor = Colors.white;
const Color backgroundColor = Color.fromARGB(255, 243, 245, 248);
const Color whiteColor = Colors.white;
DateTime selectedMonth = DateTime(2025, 3, 1);

class ThemeSelector extends StatefulWidget {
  const ThemeSelector({super.key});

  @override
  State<ThemeSelector> createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  late Color _selectedColor;

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
    _selectedColor = blueColor;
    _loadThemeColor();
  }

  Future<void> _loadThemeColor() async {
    try {
      final deviceId = FirebaseAuth.instance.currentUser?.uid;
      if (deviceId != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(deviceId)
            .collection('settings')
            .doc('theme_color')
            .get()
            .timeout(
              const Duration(seconds: 6),
              onTimeout: () {
                // Timeout → return empty snapshot
                return Future.value(
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(deviceId)
                      .collection('settings')
                      .doc('theme_color')
                      .snapshots()
                      .first,
                );
              },
            );

        if (snapshot.exists && snapshot.data() != null) {
          final data = snapshot.data() as Map<String, dynamic>;
          final int? savedColor = data['colorValue'] as int?;
          if (savedColor != null) {
            if (!mounted) return;
            setState(() {
              _selectedColor = Color(savedColor);
              blueColor = Color(savedColor);
            });
          }
        } else {
          // timeout or no color → keep default blueColor
          if (!mounted) return;
          setState(() {
            _selectedColor = blueColor;
          });
        }
      }
    } catch (e) {
      debugPrint("⚠️ Failed to load color from Firebase: $e");
      if (!mounted) return;
      setState(() {
        _selectedColor = blueColor;
      });
    }
  }

  Future<void> _saveSelectedColor(Color color) async {
    setState(() {
      _selectedColor = color;
      blueColor = color;
    });

    try {
      final deviceId = FirebaseAuth.instance.currentUser?.uid;
      if (deviceId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(deviceId)
            .collection('settings')
            .doc('theme_color')
            .set({'colorValue': color.value});
      }
    } catch (e) {
      debugPrint("⚠️ Failed to save to Firebase: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(cms), backgroundColor: _selectedColor),
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
            final isSelected = _selectedColor.value == color.value;

            final textColor =
                color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

            return GestureDetector(
              onTap: () async {
                await _saveSelectedColor(color);
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
                    if (isSelected)
                      const Center(
                        child: Icon(Icons.check, color: Colors.white, size: 32),
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
