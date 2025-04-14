import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/Controllers/AuthController.dart';
import 'package:social_media/Utils/GlobalFunctions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with GlobalFunctions {
  final authController = Get.put(AuthController());
  var isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _submitForm() async {
    if (isLoading.value) return;

    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    isLoading = true.obs;
    final isSuccess = await authController.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    isLoading = false.obs;
    if (isSuccess) {
      Get.toNamed('home'); // Redirect on success
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for responsive adjustments
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Allow the screen to resize when the keyboard appears
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor, // Primary color background
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white, // Icon color set to white
              ),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          "Socially",
          style: TextStyle(
            color: Theme.of(context).primaryColor, // Primary color for title
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, // Adjust horizontal padding
            vertical: screenHeight * 0.02, // Adjust vertical padding
          ),
          child: Obx(() => SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Empty space with some text above the form
                      SizedBox(
                          height: screenHeight * 0.10), // Adjust top margin
                      Text(
                        "Welcome Back!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.065, // Responsive font size
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                          height: screenHeight * 0.02), // Responsive spacing

                      // Title Text
                      Text(
                        "Login to Proceed",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.06, // Responsive font size
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05, // Responsive spacing
                      ),
                      // Email TextField
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                          errorText: authController
                              .fieldErrors['email'], // Show email error
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Email is required";
                          }
                          if (!GetUtils.isEmail(value)) {
                            return "Invalid email address";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // Password TextField
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                          errorText: authController.fieldErrors['password'],
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password is required";
                          }
                          if (value.length < 8) {
                            return "Password must be at least 8 characters";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              print("Forget Password?");
                            },
                            child: Text(
                              "Forget Password?",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    screenWidth * 0.04, // Responsive font size
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      // Login Button
                      ElevatedButton(
                        onPressed: () {
                          if (!isLoading.value) {
                            _submitForm();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02),
                          textStyle: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                        child: isLoading.value
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Text("Login"),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // Register Text Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize:
                                  screenWidth * 0.04, // Responsive font size
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              Get.toNamed('signUp');
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    screenWidth * 0.045, // Responsive font size
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
