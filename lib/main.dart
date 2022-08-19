import 'package:fl_cicd/global/bloc/page_bloc.dart';
import 'package:fl_cicd/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PageBloc()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePagePdfView(),
      ),
    );
  }
}
