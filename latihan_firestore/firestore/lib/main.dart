import 'package:firebase_core/firebase_core.dart';
import 'package:firestore/firebase_options.dart';
import 'package:firestore/user/user_data.dart';
import 'package:firestore/user/user_list.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(UserList());
}