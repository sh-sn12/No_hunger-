import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<UserModel?> getUserRole(String uid) async {
    try {
      print('Fetching user document for uid: $uid');
      final docSnapshot = await _firestore.collection('users').doc(uid).get();

      if (!docSnapshot.exists) {
        print('User document does not exist for uid: $uid');
        return null;
      }

      final data = docSnapshot.data();
      if (data == null) {
        print('User document exists but has no data for uid: $uid');
        return null;
      }

      print('User document data: $data');

      // Safely extract and validate email
      final email = data['email'];
      if (email == null) {
        print('Email field is null in user document');
        return null;
      }
      final emailString = email.toString();
      if (emailString.isEmpty) {
        print('Email is empty in user document');
        return null;
      }

      // Safely extract and validate role
      final role = data['role'];
      if (role == null) {
        print('Role field is null in user document, defaulting to "other"');
        return UserModel(
          uid: uid,
          email: emailString,
          role: 'other',
        );
      }
      final roleString = role.toString();

      print('Creating UserModel with email: $emailString, role: $roleString');
      return UserModel(
        uid: uid,
        email: emailString,
        role: roleString,
      );
    } catch (e, stackTrace) {
      print('Error getting user role: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  static Future<void> createUser(String uid, String email, String role) async {
    try {
      if (uid.isEmpty) {
        throw Exception('UID cannot be empty');
      }
      if (email.isEmpty) {
        throw Exception('Email cannot be empty');
      }
      if (role.isEmpty) {
        throw Exception('Role cannot be empty');
      }

      print('Creating user document for uid: $uid');
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('User document created successfully');
    } catch (e, stackTrace) {
      print('Error creating user: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}

class UserModel {
  final String uid;
  final String email;
  final String role;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
  });

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, role: $role)';
  }
}
