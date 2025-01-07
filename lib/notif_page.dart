import 'package:flutter/material.dart';

class NotifPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      'title': 'The Begening After The End - New Chapter Released!',
      'description':
          'The latest chapter of The Begening After The End has been released. Check it out!',
      'time': 'Just Now',
      'image': 'assets/img/comic_1.jpg',
    },
    {
      'title': 'Martial Gods Regressed To Level 2 - Chapter 10 Updated',
      'description':
          'Martial Gods Regressed To Level 2 has a new update in chapter 10. Dive into the adventure!',
      'time': '2 hours ago',
      'image': 'assets/img/comic_2.jpg',
    },
    {
      'title':
          'Kasim Kedua Mendapatkan Kembali Kejantananya - New Episode Released',
      'description':
          'The next episode of Kasim Kedua Mendapatkan Kembali Kejantananya is live. Don\'t miss out!',
      'time': '5 hours ago',
      'image': 'assets/img/comic_3.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF09C4F8),
        title: Center(
          child: Text(
            'Comic Update',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationTile(notification: notifications[index]);
        },
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final Map<String, String> notification;

  NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            notification['image']!,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          notification['title']!,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification['description']!),
            SizedBox(height: 4),
            Text(
              notification['time']!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.notifications_active,
          color: Colors.green,
        ),
      ),
    );
  }
}
