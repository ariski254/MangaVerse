import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class Profile {
  final int? id;
  final String username;
  final String name;
  final String bio;
  final String email;
  final String profilePicture;

  Profile({
    this.id,
    required this.username,
    required this.name,
    required this.bio,
    required this.email,
    required this.profilePicture,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'bio': bio,
      'email': email,
      'profilePicture': profilePicture,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      username: map['username'],
      name: map['name'],
      bio: map['bio'],
      email: map['email'],
      profilePicture: map['profilePicture'],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'profiles.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE profiles(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            name TEXT,
            bio TEXT,
            email TEXT,
            profilePicture TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertProfile(Profile profile) async {
    final db = await database;
    await db.insert(
      'profiles',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Profile>> getProfiles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('profiles');

    return List.generate(maps.length, (i) {
      return Profile.fromMap(maps[i]);
    });
  }

  Future<void> updateProfile(Profile profile) async {
    final db = await database;
    await db.update(
      'profiles',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  Future<void> deleteProfile(int id) async {
    final db = await database;
    await db.delete(
      'profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
