import 'package:crafty_bay/presentation/state_holder/verify_otp_controller.dart';
import 'package:crafty_bay/presentation/ui/screen/main_bottom_nav_screen.dart';
import 'package:crafty_bay/presentation/ui/utility/app_colors.dart';
import 'package:crafty_bay/presentation/ui/widgets/center_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../state_holder/otp_time_decrease_controller.dart';
import '../../widgets/app_logo.dart';
import 'complete_profile_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key, required this.email});

  final String email;

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final OtpTimeDecreaseController _otpTimeDecrease =
      Get.find<OtpTimeDecreaseController>();

  final TextEditingController _otpTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _otpTimeDecrease.decreaseTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(42),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 120),
              const AppLogo(height: 100),
              const SizedBox(height: 10),
              Text(
                'Enter OTP Code',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'A 4 Digit OTP Code has been sent',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(
                height: 24,
              ),
              PinCodeTextField(
                errorTextMargin: const EdgeInsets.only(left: 30, top: 50),
                controller: _otpTEController,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                appContext: context,
                length: 6,
                obscureText: true,
                obscuringCharacter: "*",
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  selectedColor: Colors.black,
                  activeColor: Colors.green,
                  inactiveColor: AppColors.primaryColor,
                ),
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                validator: (value) {
                  if (value!.trim().isEmpty ?? true) {
                    return "Enter Value";
                  }
                  if (value!.length < 6) {
                    return "Enter 6 digit otp";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GetBuilder<VerifyOtpController>(builder: (controller) {
                return SizedBox(
                  width: double.infinity,
                  child: Visibility(
                    visible: controller.inProgress == false,
                    replacement: const CenterCircularProgressIndication(),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final bool response = await controller.verifyOtp(
                              widget.email, _otpTEController.text);
                          if (response) {
                            if (controller.shouldNavigateCompleteProfile) {
                              Get.to(() => const CompleteProfileScreen());
                            } else {
                              Get.offAll(() => const MainBottomNavScreen());
                            }
                          } else {
                            Get.showSnackbar(GetSnackBar(
                              duration: const Duration(seconds: 2),
                              isDismissible: true,
                              title: 'Verify otp failed',
                              message: controller.errorMessage,
                              backgroundColor: Colors.red,
                            ));
                          }
                        }
                      },
                      child: const Text('Next'),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
              GetBuilder<OtpTimeDecreaseController>(builder: (controller) {
                return RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.grey),
                    children: [
                      const TextSpan(text: "This code will expire in "),
                      TextSpan(
                        text: '${_otpTimeDecrease.seconds.toString()}s',
                        style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              }),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Resend Code',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  @override
  void dispose() {
    _otpTEController.clear();
    super.dispose();
  }
}
