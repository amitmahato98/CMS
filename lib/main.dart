import 'package:cms/navigations/body/dashboard.dart';
import 'package:cms/navigations/navbar/navbar.dart';
import 'package:cms/navigations/screens/notifications/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CMS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF167AFA),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF167AFA),
          elevation: 0,
        ),
      ),
      home: MainNavigator(),
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

    // Show exit confirmation dialog when on main screen
    // Always show the dialog and never return true directly
    bool shouldExit =
        await showDialog(
          context: context,
          barrierDismissible: false, // User must tap a button to close dialog
          builder:
              (context) => WillPopScope(
                // Prevent dialog itself from being dismissed by back button
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
      SystemNavigator.pop(); // Use system navigator to exit the app
    }

    return false; // Always return false to handle the exit within this method
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: _showingDashboard ? Navbar() : null,
        appBar:
            _showingDashboard
                ? AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  title: const Text('Admin'),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: () => _pushPage(SendNotification()),
                    ),
                  ],
                )
                : null,
        floatingActionButton: _showingDashboard ? FloatingButtonMenu() : null,
        body: Navigator(
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
      ),
    );
  }
}
