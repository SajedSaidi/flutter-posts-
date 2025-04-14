import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/Controllers/AuthController.dart';
import 'package:social_media/Controllers/UserProfileController.dart';
import 'package:social_media/Utils/GlobalFunctions.dart';
import 'package:social_media/Widgets/FetchPosts.dart';
import 'package:social_media/Widgets/KeepAlivePageState.dart';
import 'package:social_media/Widgets/MyAppBar.dart';
import 'package:social_media/Widgets/MyBottomNavigationBar.dart';
import 'package:social_media/Widgets/MyFloatingActionButton.dart';
import 'package:social_media/Widgets/MyNetworkImage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin, GlobalFunctions {
  late final authController = Get.put(AuthController());
  late final userProfileController = Get.put(UserProfileController());
  late TabController _tabController = TabController(length: 3, vsync: this);
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    print('User Profile: ${authController.user}');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _submitLogout() async {
    await authController.logout();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await userProfileController.picker
          .pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          userProfileController.image = XFile(pickedFile.path);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void saveChanges() async {
    if (formKey.currentState!.validate()) {
      userProfileController.isLoading = true.obs;

      final isSuccess = await userProfileController.saveUserProfile();

      userProfileController.isLoading = false.obs;
      setState(() {});
      if (isSuccess) {
        print('image after rerender ${authController.user?.profile?.image}');
        Get.snackbar('Success', 'Profile updated successfully');
      } else {
        Get.snackbar('Error', 'An error occurred. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: MyAppBar(),
      floatingActionButton: MyFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: MyBottomNavigationBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.all(24), // Reduced padding for more compact layout
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 90, // Slightly larger avatar
                        height: 90,
                        child: authController.user?.profile?.image != null
                            ? userProfileController.isLoading.value
                                ? CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: MyNetworkImage(
                                      url: authController.user!.profile!.image,
                                    ))
                            : Icon(Icons.person, size: 90),
                      ),
                      SizedBox(
                          width: 24), // Reduced space between avatar and stats
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text('200',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text('Posts',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey)),
                              ],
                            ),
                            Column(
                              children: [
                                Text('123',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text('Followers',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey)),
                              ],
                            ),
                            Column(
                              children: [
                                Text('98',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text('Following',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Sajed Saidi',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text('@sajed_saidi',
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userProfileController.bioController.text,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const Divider(),
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.black,
              dividerColor: Colors.transparent,
              labelColor: Colors.black,
              indicatorWeight: 3,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(icon: Icon(Icons.dashboard_outlined, size: 28)),
                Tab(icon: Icon(Icons.bookmark_border, size: 28)),
                Tab(icon: Icon(Icons.settings_outlined, size: 28)),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  kToolbarHeight - // Adjust for app bar
                  kBottomNavigationBarHeight - // Adjust for bottom nav bar
                  48, // Adjust for the TabBar height
              child: TabBarView(
                controller: _tabController,
                children: [
                  KeepAlivePage(
                    child: FetchPosts(
                      user: authController.user,
                    ),
                  ),
                  KeepAlivePage(
                    child: Center(
                      child: Text(
                        'Save Page',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  KeepAlivePage(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Avatar or image logic
                              Container(
                                width: 80,
                                height: 80,
                                child: userProfileController.image != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(80),
                                        child: Image.file(
                                          File(userProfileController
                                              .image!.path),
                                        ),
                                      )
                                    : authController.user?.profile?.image !=
                                            null
                                        ? CircleAvatar(
                                            radius: 45,
                                            child: MyNetworkImage(
                                              url: authController
                                                  .user?.profile?.image,
                                            ),
                                          )
                                        : Icon(Icons.person, size: 90),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _pickImage,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.camera_alt),
                                    const SizedBox(width: 8),
                                    Text('Change Profile Picture'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Bio",
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 4, // Allow more space for bio input
                                style: TextStyle(fontSize: 16),
                                controller: userProfileController.bioController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Bio cannot be empty';
                                  }
                                  if (value.length > 191) {
                                    return 'Bio cannot be more than 191 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: saveChanges,
                                child: Text('Save Changes'),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  Get.dialog(
                                    AlertDialog(
                                      title: Text('Logout'),
                                      content: Text(
                                          'Are you sure you want to logout?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text('Cancel',
                                              selectionColor: Colors.black),
                                        ),
                                        ElevatedButton(
                                          onPressed: _submitLogout,
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.red),
                                          ),
                                          child: Text('Logout'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red),
                                ),
                                child: Text('Logout'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
