import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sakayna/sakayna_app.dart';
import 'package:sakayna/services/data_cacher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final DataCacher _cacher = DataCacher.instance;
  await Firebase.initializeApp();
  await _cacher.init();
  runApp(const SakayNaApp());
}
