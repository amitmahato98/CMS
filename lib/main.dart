import 'package:cms/datatypes/datatypes.dart';
import 'package:cms/navigations/body/admin_dashboard.dart';
import 'package:cms/navigations/navbar/admin_navbar.dart';
import 'package:cms/navigations/screens/notifications/notification.dart';
import 'package:cms/theme/theme_provider.dart' as theme;
import 'package:cms/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  int? localColor = prefs.getInt('themeColor');

  int? firebaseColor;
  try {
    final doc =
        await FirebaseFirestore.instance
            .collection('app_settings')
            .doc('theme_color')
            .get();
    if (doc.exists) firebaseColor = doc['colorValue'] as int;
  } catch (_) {}

  // Corrected: use .value for default Color
  blueColor = Color(firebaseColor ?? localColor ?? blueColor.value);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<theme.ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'CMS',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.currentTheme,
          home: MainNavigator(),
        );
      },
    );
  }
}

class MainNavigator extends StatefulWidget {
  @override
  _MainNavigatorState createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showingDashboard = true;

  void _pushPage(Widget page) {
    setState(() {
      _showingDashboard = false;
    });
    _navigatorKey.currentState
        ?.push(
          MaterialPageRoute(
            builder: (context) => page,
            fullscreenDialog: false,
          ),
        )
        .then((_) {
          setState(() {
            _showingDashboard = true;
          });
        });
  }

  Future<bool> _onWillPop() async {
    if (!_showingDashboard) {
      if (_navigatorKey.currentState?.canPop() ?? false) {
        _navigatorKey.currentState?.pop();
        return false;
      }
      setState(() {
        _showingDashboard = true;
      });
      return false;
    }

    bool shouldExit =
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => WillPopScope(
                onWillPop: () async => false,
                child: AlertDialog(
                  title: Text('Exit App'),
                  content: Text('Do you want to exit the app?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('Yes'),
                    ),
                  ],
                ),
              ),
        ) ??
        false;

    if (shouldExit) {
      SystemNavigator.pop();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: _showingDashboard ? Navbar() : null,
        appBar:
            _showingDashboard
                ? AppBar(
                  backgroundColor: blueColor,
                  leading: IconButton(
                    icon: Icon(Icons.menu),
                    tooltip: 'Open Menu',
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  title: const Text('Admin'),
                  actions: [
                    IconButton(
                      icon: Icon(
                        themeProvider.isDarkMode
                            ? Icons.light_mode
                            : Icons.dark_mode,
                      ),
                      tooltip:
                          themeProvider.isDarkMode
                              ? 'Bright Mode'
                              : 'Dark Mode',
                      onPressed: () => themeProvider.toggleTheme(),
                    ),
                    IconButton(
                      icon: Icon(Icons.notifications),
                      tooltip: 'Notifications',
                      onPressed: () => _pushPage(SendNotificationPage()),
                    ),
                  ],
                )
                : null,
        body: Stack(
          children: [
            Navigator(
              key: _navigatorKey,
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder:
                      (context) => Dashboard(
                        onSectionSelected: (Widget page) {
                          _pushPage(page);
                        },
                      ),
                );
              },
            ),
            if (_showingDashboard) ...[
              Positioned(
                right: 60,
                bottom: 60,
                child: FloatingActionButton(
                  onPressed: () => _pushPage(ThemeSelector()),
                  backgroundColor: blueColor,
                  tooltip: 'Theme Selector',
                  child: Icon(Icons.color_lens, color: Colors.white),
                ),
              ),
              // Firebase test button
              Positioned(
                right: 60,
                bottom: 130,
                child: FloatingActionButton(
                  onPressed: () async {
                    try {
                      final doc =
                          await FirebaseFirestore.instance
                              .collection('test')
                              .doc('ping')
                              .get();

                      if (doc.exists) {
                        print("Firebase apps: ${Firebase.apps}");
                        print("Firebase connected! Doc data: ${doc.data()}");
                      } else {
                        print("Firebase apps: ${Firebase.apps}");
                        print(" Firebase connected, but no doc found.");
                      }
                    } catch (e) {
                      print("Firebase apps: ${Firebase.apps}");
                      print(" Firebase test failed: $e");
                    }
                  },
                  backgroundColor: blueColor,
                  tooltip: 'Connection Test',
                  child: Icon(Icons.cloud, color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
