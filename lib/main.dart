import 'package:clippy_flutter/triangle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_map/bloc/custom_info_window_bloc.dart';
import 'package:google_map/custom_info.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: BlocProvider(
        create: (context) => CustomInfoWindowBloc(),
        child: CustomInfoWindowExample(),
      ),
    );
  }
}

