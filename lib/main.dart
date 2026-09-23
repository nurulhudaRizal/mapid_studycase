import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapid_studycase/presentation/map/bloc/map_bloc.dart';
import 'package:mapid_studycase/presentation/map/bloc/map_event.dart';
import 'package:mapid_studycase/presentation/map/pages/map_page.dart';

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
      home: BlocProvider(
        create: (_) => sl<MapBloc>()..add(const MapLoadRequested()),
        child: const MapPage(),
      ),
    );
  }
}
