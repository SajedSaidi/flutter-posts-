import 'package:flutter/material.dart';
import 'package:social_media/Widgets/FetchPosts.dart';
import 'package:social_media/Widgets/MyAppBar.dart';
import 'package:social_media/Widgets/MyBottomNavigationBar.dart';
import 'package:social_media/Widgets/MyFloatingActionButton.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppBar(),
        floatingActionButton: MyFloatingActionButton(),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        bottomNavigationBar: MyBottomNavigationBar(),
        body: FetchPosts());
  }
}
