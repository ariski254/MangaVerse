import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'database.dart';
import 'comicListdetails.dart';
import 'comiclist_page.dart';
import 'favorite_page.dart';
import 'history_page.dart';
import 'more_page.dart';
import 'profile_page.dart';
import 'notif_page.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _profilePictureUrl = 'assets/img/profile_picture.jpg';
  DatabaseHelper _dbHelper = DatabaseHelper();

  final List<Widget> _pages = [
    HomePage(),
    ComicListPage(),
    FavoritePage(),
    HistoryPage(),
    MorePage(),
  ];

  void _loadProfile() async {
    var profiles = await _dbHelper.getProfiles();
    if (profiles.isNotEmpty) {
      setState(() {
        _profilePictureUrl = profiles[0].profilePicture;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF09C4F8),
        elevation: 0,
        leading: IconButton(
          icon: CircleAvatar(
            radius: 15,
            backgroundImage:
                _profilePictureUrl == 'assets/img/profile_picture.jpg'
                    ? null
                    : FileImage(File(_profilePictureUrl)),
            backgroundColor: Colors.transparent,
            child: _profilePictureUrl == 'assets/img/profile_picture.jpg'
                ? Icon(Icons.account_circle, color: Colors.white)
                : null,
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          ),
        ),
        title: _buildSearchBar(),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, size: 30, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotifPage()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHighlightSection(),
            _buildPopularSection(),
            _buildRecommendationSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      child: TextField(
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightSection() {
    return Stack(
      children: [
        Container(
          height: 250,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF09C4F8), Color(0xFF6DD5FA), Color(0xFFD4FC79)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            image: DecorationImage(
              image: AssetImage('assets/img/logo.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.darken),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: Text(
            'Welcome to MangaVerse',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopularSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top 10 Popular Titles',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showComicDetails(context, index, true),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        color: Colors.blue[100],
                        child: Image.asset(
                          'assets/img/comic_${index + 1}.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recommendation',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            itemCount: 16,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showComicDetails(context, index, false),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    color: Colors.blue[50],
                    child: SizedBox(
                      width: 150,
                      height: 200,
                      child: Image.asset(
                        'assets/img/genre_${index + 1}.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
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

  void _showComicDetails(BuildContext context, int index, bool isPopular) {
    String title = isPopular
        ? 'Popular Comic ${index + 1}'
        : 'Recommended Comic ${index + 1}';
    String genre = 'Action, Comedy, Fantasy';
    String description = 'This is a description of the comic.';
    String imagePath = isPopular
        ? 'assets/img/comic_${index + 1}.jpg'
        : 'assets/img/genre_${index + 1}.jpg';

    bool isFavorite = false;

    Map<String, String> comic = {
      'title': title,
      'genre': genre,
      'description': description,
      'image': imagePath,
    };

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('$title'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(imagePath),
                  SizedBox(height: 10),
                  Text('Genre: $genre'),
                  Text('Description: $description'),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Color(0xFF09C4F8) : Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                      ),
                      Text('Add to Favorites'),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ComicListDetails(comic: comic)),
                      );
                    },
                    child: Text('View Chapters'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
