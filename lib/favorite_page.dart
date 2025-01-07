import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'home_page.dart';
import 'comiclist_page.dart';
import 'history_page.dart';
import 'more_page.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  int _selectedIndex = 2;

  final List<Map<String, dynamic>> favoriteComics = [
    {
      'title': 'The Begening After The End',
      'image': 'assets/img/comic_1.jpg',
      'description': 'A story of a young Man',
      'isFavorite': true,
    },
    {
      'title': 'Martial Gods Regressed To Level 2',
      'image': 'assets/img/comic_2.jpg',
      'description': 'A story that is just stuck at level 2',
      'isFavorite': false,
    },
    {
      'title': 'Kasim Kedua Mendapatkan Kembali Kejantananya',
      'image': 'assets/img/comic_3.jpg',
      'description':
          'Reincarnation of a high school student to the past who becomes a eunuch',
      'isFavorite': true,
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

    if (index != 2) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => pages[index]));
    }
  }

  void _toggleFavorite(int index) {
    setState(() {
      favoriteComics[index]['isFavorite'] =
          !(favoriteComics[index]['isFavorite'] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF09C4F8),
        title: Center(
          child: Text(
            'Favorite Comics',
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
        itemCount: favoriteComics.length,
        itemBuilder: (context, index) {
          final comic = favoriteComics[index];
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
              subtitle: Text(comic['description']!),
              trailing: IconButton(
                icon: Icon(
                  comic['isFavorite'] == true
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: comic['isFavorite'] == true
                      ? Color(0xFF09C4F8)
                      : Colors.black,
                ),
                onPressed: () {
                  _toggleFavorite(index);
                },
              ),
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
