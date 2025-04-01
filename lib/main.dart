import 'package:flutter/material.dart';
import 'core/services/storage_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService().initializeMockData();
  runApp(const InkingiApp());
}
