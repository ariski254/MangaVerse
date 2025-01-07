import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_page.dart';
import 'comiclist_page.dart';
import 'favorite_page.dart';
import 'history_page.dart';
import 'home_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'profile_page.dart';
import 'notif_page.dart';

class MorePage extends StatefulWidget {
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  int _selectedIndex = 4;

  final List<Widget> _pages = [
    HomePage(),
    ComicListPage(),
    FavoritePage(),
    HistoryPage(),
    MorePage(),
  ];

  void _onNavBarTap(int index) {
    if (index != 4) {
      setState(() {
        _selectedIndex = index;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _pages[index]),
      );
    }
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to log out?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Log Out'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF09C4F8),
        elevation: 0,
        centerTitle: true,
        title: Text('More',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.account_circle, color: Color(0xFF09C4F8)),
              title: Text('Profile Settings'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.notifications, color: Color(0xFF09C4F8)),
              title: Text('Check Notifications'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotifPage()),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Color(0xFF09C4F8)),
              title: Text('Logout'),
              onTap: _showLogoutDialog,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF09C4F8), Color(0xFF6DD5FA)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        child: GNav(
          gap: 8,
          backgroundColor: Colors.transparent,
          color: Colors.white,
          activeColor: Color(0xFF09C4F8),
          tabBackgroundColor: Colors.white,
          padding: EdgeInsets.all(12),
          tabs: [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.book, text: 'Comic List'),
            GButton(icon: Icons.favorite, text: 'Favorite'),
            GButton(icon: Icons.history, text: 'History'),
            GButton(icon: Icons.more_horiz, text: 'More'),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: _onNavBarTap,
        ),
      ),
    );
  }
}
