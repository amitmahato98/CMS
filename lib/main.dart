import 'package:cms/navigations/body/dashboard.dart';
import 'package:cms/navigations/navbar/navbar.dart';
import 'package:cms/navigations/screens/notifications/notification.dart';
import 'package:flutter/material.dart';

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
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        )
        .then((_) {
          setState(() {
            _showingDashboard = true;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!_showingDashboard) {
          setState(() {
            _showingDashboard = true;
          });
          return true;
        }
        return true;
      },
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
