import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'home_page.dart';
import 'comiclist_page.dart';
import 'favorite_page.dart';
import 'more_page.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _selectedIndex = 3;

  final List<Map<String, String>> historyComics = [
    {
      'title': 'The Begening After The End',
      'image': 'assets/img/comic_1.jpg',
      'lastRead': '2 days ago'
    },
    {
      'title': 'Martial Gods Regressed To Level 2',
      'image': 'assets/img/comic_2.jpg',
      'lastRead': '1 week ago'
    },
    {
      'title': 'Kasim Kedua Mendapatkan Kembali Kejantananya',
      'image': 'assets/img/comic_3.jpg',
      'lastRead': '3 hours ago'
    },
  ];

  void _onNavBarTap(int index) {
    setState(() => _selectedIndex = index);

    final pages = [
      HomePage(),
      ComicListPage(),
      FavoritePage(),
      HistoryPage(),
      MorePage(),
    ];

    if (index != 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => pages[index]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF09C4F8),
        title: Center(
          child: Text(
            'History',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: historyComics.length,
        itemBuilder: (context, index) {
          final comic = historyComics[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 5,
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 0.7,
                  child: Image.asset(comic['image']!, fit: BoxFit.cover),
                ),
              ),
              title: Text(comic['title']!,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Last read: ${comic['lastRead']}'),
              trailing: Icon(Icons.history, color: Colors.blue),
              onTap: () => print("Tapped on ${comic['title']}"),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Color(0xFF09C4F8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
          child: GNav(
            gap: 8,
            backgroundColor: Color(0xFF09C4F8),
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
      ),
    );
  }
}
