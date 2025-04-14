import 'package:flutter/material.dart';
import 'package:social_media/Widgets/MyAppBar.dart';
import 'package:social_media/Widgets/MyBottomNavigationBar.dart';
import 'package:social_media/Widgets/MyFloatingActionButton.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: MyAppBar(),
      floatingActionButton: MyFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: MyBottomNavigationBar(),
      body: SingleChildScrollView(
        child: ModernSearchBar(
          onSearch: (p1) => {},
        ),
      ),
    );
  }
}

class ModernSearchBar extends StatelessWidget {
  final Function(String) onSearch;
  final String hintText;

  const ModernSearchBar({
    Key? key,
    required this.onSearch,
    this.hintText = "Search...",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: onSearch,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
