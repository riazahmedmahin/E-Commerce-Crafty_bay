import 'package:crafty_bay/presentation/state_holder/auth_controller.dart';
import 'package:crafty_bay/presentation/ui/screen/main_bottom_nav_screen.dart';
import 'package:crafty_bay/presentation/ui/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    moveToNextScreen();
  }

  void moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    await Get.find<AuthController>().initialize();
    Get.offAll(() => const MainBottomNavScreen());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            AppLogo(
              width: 120,
            ),
            Spacer(),
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Version 1.0"),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
