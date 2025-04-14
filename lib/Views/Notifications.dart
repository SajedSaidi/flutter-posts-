import 'package:flutter/material.dart';
import 'package:social_media/Widgets/MyAppBar.dart';
import 'package:social_media/Widgets/MyBottomNavigationBar.dart';
import 'package:social_media/Widgets/MyFloatingActionButton.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: MyAppBar(),
      floatingActionButton: MyFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: MyBottomNavigationBar(),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Expanded(
          child: ListView.separated(
            itemCount: 10,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage("images/avatar-04.png"),
                ),
                title: Text("User $index"),
                subtitle: Text("Commented on your post."),
                trailing: Text('2m ago'),
              );
            },
          ),
        ),
      ),
    );
  }
}
