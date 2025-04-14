import 'package:get/get.dart';
import 'package:social_media/Views/Chat.dart';
import 'package:social_media/Views/CreatePost.dart';
import 'package:social_media/Views/Home.dart';
import 'package:social_media/Views/Landing.dart';
import 'package:social_media/Views/Login.dart';
import 'package:social_media/Views/Messages.dart';
import 'package:social_media/Views/Notifications.dart';
import 'package:social_media/Views/Profile.dart';
import 'package:social_media/Views/Search.dart';
import 'package:social_media/Views/SignUp.dart';
import 'package:social_media/Views/Splash.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String landing = '/landing';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String home = '/home';
  static const String createPost = '/createPost';
  static const String search = '/search';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String messages = '/messages';
  static const String chat = '/chat';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashPage()),
    GetPage(name: landing, page: () => LandingPage()),
    GetPage(name: login, page: () => LoginPage()),
    GetPage(name: signUp, page: () => SignUpPage()),
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: search, page: () => SearchPage()),
    GetPage(name: notifications, page: () => NotificationsPage()),
    GetPage(name: profile, page: () => ProfilePage()),
    GetPage(name: messages, page: () => MessagesPage()),
    GetPage(name: chat, page: () => ChatPage()),
    GetPage(name: createPost, page: () => CreatePostPage()),
  ];
}
