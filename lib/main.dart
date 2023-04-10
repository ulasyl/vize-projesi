import 'dart:io';

import 'package:banka/screens/add_screen.dart';
import 'package:banka/screens/main_screen.dart';
import 'package:banka/screens/process_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:banka/screens/details_screen.dart';



void main() {
  runApp(const MyApp());
  
}

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes:[
      GoRoute(
        path: '/',
        builder: (context, state) => const MainScreen()
        
      ),
      GoRoute(
        path: '/details',
        builder: (context, state) => DetailsScreen(
          isar: isar,
        )
      ),
      GoRoute(
        path: '/process',
        builder: (context, state) => ProcessScreen(
          isar: isar,
          id: state.queryParams['id'],
        )
      ),
      GoRoute(
        path: '/add',
        builder: (context, state) => AddScreen(
          isar: isar,
        )
      )
      
    ]
  );


class MyApp extends StatelessWidget {
  
  
  const MyApp({super.key});
  

  // This widget is the root of your application.

  @override
  
  Widget build(BuildContext context) {
    
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red,
          elevation: 0
        )
      ),
    );
  }
}
