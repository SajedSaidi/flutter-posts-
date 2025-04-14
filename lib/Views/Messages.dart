import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/Widgets/MyAppBar.dart';
import 'package:social_media/Widgets/MyBottomNavigationBar.dart';
import 'package:social_media/Widgets/MyFloatingActionButton.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      floatingActionButton: MyFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: MyBottomNavigationBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Icon + Title Section at the top
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!, width: 1),
                  bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.message, // Choose an icon here
                    color: Colors.black,
                    size: 20,
                  ),
                  SizedBox(width: 10), // Space between icon and text
                  Text(
                    'New Messages',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // Messages List
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.all(8),
                    onTap: () {
                      Get.toNamed('/chat');
                    },
                    leading: CircleAvatar(
                      backgroundImage: AssetImage("images/avatar-04.png"),
                    ),
                    title: Text("User $index"),
                    subtitle: Text("Sent you a message."),
                    trailing: Text('2m ago'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
