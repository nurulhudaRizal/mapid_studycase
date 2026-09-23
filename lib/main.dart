import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await configureDependencies();

  runApp(const MapidCaseStudyApp());
}

class MapidCaseStudyApp extends StatelessWidget {
  const MapidCaseStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAPID Case Study',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(body: Center(child: Text('MAPID Case Study'))),
    );
  }
}
