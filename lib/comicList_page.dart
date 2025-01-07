import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'home_page.dart';
import 'favorite_page.dart';
import 'history_page.dart';
import 'more_page.dart';
import 'comicListdetails.dart';

class ComicListPage extends StatefulWidget {
  @override
  _ComicListPageState createState() => _ComicListPageState();
}

class _ComicListPageState extends State<ComicListPage> {
  int _selectedIndex = 1;

  final List<Map<String, String>> comics = [
    {'image': 'assets/img/comic_1.jpg', 'genre': 'Action'},
    {'image': 'assets/img/comic_2.jpg', 'genre': 'Action'},
    {'image': 'assets/img/comic_3.jpg', 'genre': 'Action'},
    {'image': 'assets/img/comic_4.jpg', 'genre': 'Action'},
    {'image': 'assets/img/comic_5.jpg', 'genre': 'Action'},
    {'image': 'assets/img/comic_6.jpg', 'genre': 'Action'},
    {'image': 'assets/img/comic_7.jpg', 'genre': 'Comedy'},
    {'image': 'assets/img/comic_8.jpg', 'genre': 'Comedy'},
    {'image': 'assets/img/comic_9.jpg', 'genre': 'Comedy'},
    {'image': 'assets/img/comic_10.jpg', 'genre': 'Comedy'},
    {'image': 'assets/img/genre_4.jpg', 'genre': 'Comedy'},
    {'image': 'assets/img/genre_5.jpg', 'genre': 'Comedy'},
    {'image': 'assets/img/genre_7.jpg', 'genre': 'Fantasy'},
    {'image': 'assets/img/genre_8.jpg', 'genre': 'Fantasy'},
    {'image': 'assets/img/genre_9.jpg', 'genre': 'Fantasy'},
    {'image': 'assets/img/genre_1.jpg', 'genre': 'Fantasy'},
    {'image': 'assets/img/genre_2.jpg', 'genre': 'Fantasy'},
    {'image': 'assets/img/genre_3.jpg', 'genre': 'Fantasy'},
  ];

  final List<String> genres = ['Action', 'Comedy', 'Fantasy'];

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    final routes = [
      HomePage(),
      ComicListPage(),
      FavoritePage(),
      HistoryPage(),
      MorePage()
    ];

    if (index != 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => routes[index]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF09C4F8);
    const textColor = Colors.white;
    const textBar = Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        title: Center(
          child: const Text(
            'Comic List',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: DefaultTabController(
        length: genres.length,
        child: Column(
          children: [
            TabBar(
              indicatorColor: primaryColor,
              labelColor: textBar,
              unselectedLabelColor: Colors.black54,
              tabs: genres.map((genre) => Tab(text: genre)).toList(),
            ),
            Expanded(
              child: TabBarView(
                children: genres.map((genre) {
                  final filteredComics =
                      comics.where((comic) => comic['genre'] == genre).toList();
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: filteredComics.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ComicListDetails(
                                  comic: filteredComics[index],
                                ),
                              ),
                            );
                          },
                          child: ComicTile(
                            comic: filteredComics[index],
                            primaryColor: primaryColor,
                            textColor: textColor,
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
          child: GNav(
            gap: 8,
            backgroundColor: primaryColor,
            color: Colors.white,
            activeColor: primaryColor,
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

class ComicTile extends StatelessWidget {
  final Map<String, String> comic;
  final Color primaryColor;
  final Color textColor;

  const ComicTile({
    required this.comic,
    required this.primaryColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      color: primaryColor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          comic['image']!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(child: Icon(Icons.error, color: textColor));
          },
        ),
      ),
    );
  }
}
