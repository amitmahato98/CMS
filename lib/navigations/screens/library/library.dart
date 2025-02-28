import 'package:cms/datatypes/datatypes.dart';
import 'package:cms/navigations/screens/library/ibrary-notification.dart';
import 'package:flutter/material.dart';

class Library extends StatelessWidget {
  const Library({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Library'),
          actions: [
            IconButton(
              icon: Icon(Icons.notification_important),
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) =>
                            LibraryNotification(),
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        color: GrayColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: double.infinity,
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(25),
                  child: SearchBar(
                    onChanged: (value) {
                      // print(value);
                    },
                    hintText: 'Search...',
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Row(
              children: [
                Text("Books", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Text(
                  "Book History",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
