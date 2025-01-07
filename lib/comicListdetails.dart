import 'package:flutter/material.dart';

class ComicListDetails extends StatefulWidget {
  final Map<String, String> comic;

  const ComicListDetails({required this.comic});

  @override
  _ComicListDetailsState createState() => _ComicListDetailsState();
}

class _ComicListDetailsState extends State<ComicListDetails> {
  bool isFavorite = false;

  String get description {
    return "this is a description of this manga and this is a random description.";
  }

  List<String> get chapters {
    return [
      'Chapter 1',
      'Chapter 2',
      'Chapter 3',
      'Chapter 4',
    ];
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF09C4F8);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Center(
          child: Text(
            widget.comic['genre'] ?? 'Comic Detail',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: widget.comic['image'] != null
                    ? Image.asset(
                        widget.comic['image']!,
                        fit: BoxFit.cover,
                        height: 300,
                        width: double.infinity,
                      )
                    : Container(
                        height: 300,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Center(
                          child: Text(
                            'No Image Available',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Genre: ${widget.comic['genre']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Text(
              'Chapters:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: chapters.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.book),
                    title: Text(chapters[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
