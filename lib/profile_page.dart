import 'package:flutter/material.dart';
import 'database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _profilePictureUrl = 'assets/img/profile_picture.jpg';

  DatabaseHelper _dbHelper = DatabaseHelper();
  Profile? _currentProfile;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  _loadProfile() async {
    var profiles = await _dbHelper.getProfiles();
    if (profiles.isNotEmpty) {
      setState(() {
        _currentProfile = profiles[0];
        _usernameController.text = _currentProfile!.username;
        _nameController.text = _currentProfile!.name;
        _bioController.text = _currentProfile!.bio;
        _emailController.text = _currentProfile!.email;
        _profilePictureUrl = _currentProfile!.profilePicture;
      });
    }
  }

  _saveProfile() async {
    if (_currentProfile != null) {
      Profile updatedProfile = Profile(
        id: _currentProfile!.id,
        username: _usernameController.text,
        name: _nameController.text,
        bio: _bioController.text,
        email: _emailController.text,
        profilePicture: _profilePictureUrl,
      );
      await _dbHelper.updateProfile(updatedProfile);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')));
    } else {
      Profile newProfile = Profile(
        username: _usernameController.text,
        name: _nameController.text,
        bio: _bioController.text,
        email: _emailController.text,
        profilePicture: _profilePictureUrl,
      );
      await _dbHelper.insertProfile(newProfile);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile created successfully')));
    }
  }

  _deleteProfilePicture() {
    setState(() {
      _profilePictureUrl = 'assets/img/profile_picture.jpg';
    });
  }

  _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePictureUrl = pickedFile.path;
      });
    }
  }

  _takePhoto() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _profilePictureUrl = pickedFile.path;
      });
    }
  }

  _clearField(TextEditingController controller) {
    setState(() {
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF09C4F8),
        title: Center(
          child: Text(
            'Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showImageSelectionDialog();
                    },
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: FileImage(File(_profilePictureUrl)),
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    top: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: _showImageSelectionDialog,
                        iconSize: 50,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -10,
                    right: -10,
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Color(0xFF09C4F8)),
                      onPressed: _deleteProfilePicture,
                      iconSize: 35,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            _buildEditableField(_usernameController, 'Username'),
            SizedBox(height: 16),
            _buildEditableField(_nameController, 'Full Name'),
            SizedBox(height: 16),
            _buildEditableField(_bioController, 'Bio', maxLines: 3),
            SizedBox(height: 16),
            _buildEditableField(_emailController, 'Email Address'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Save Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF09C4F8),
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                maxLines: maxLines,
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Color(0xFF09C4F8)),
              onPressed: () => _clearField(controller),
            ),
          ],
        ),
      ),
    );
  }

  _showImageSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Profile Picture'),
          content: Text('Choose an option to update your profile picture'),
          actions: [
            TextButton(
              child: Text('Gallery'),
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage();
              },
            ),
            TextButton(
              child: Text('Camera'),
              onPressed: () {
                Navigator.of(context).pop();
                _takePhoto();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
