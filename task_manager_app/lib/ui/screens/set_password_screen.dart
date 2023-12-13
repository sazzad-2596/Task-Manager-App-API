import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/widgets/body_background.dart';

import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';
import '../../style/styles.dart';
import '../controller/validation_input.dart';
import '../widgets/snack_message.dart';
import 'login_screen.dart';

class SetPasswordScreen extends StatefulWidget {
  final String email;
  final String pin;
  const SetPasswordScreen({super.key, required this.email, required this.pin});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController _newPasswordTEController =
  TextEditingController();
  final TextEditingController _confirmPasswordTEController =
  TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool setPasswordInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackGround(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 60,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Set Password",
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 8),
                    Text(
                      "Minimum length password 8 character with letters & numbers combination",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _newPasswordTEController,
                      decoration: const InputDecoration(
                        hintText: "New Password",
                      ),
                      validator: FormValidation.inputValidation,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmPasswordTEController,
                      decoration: const InputDecoration(
                        hintText: "Confirm Password",
                      ),
                      validator: FormValidation.inputValidation,
                    ),
                    const SizedBox(height: 8),
                    Visibility(
                      visible: setPasswordInProgress == false,
                      replacement: Center(
                        child: CircularProgressIndicator(
                          color: PrimaryColor.color,
                        ),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: setNewPassword,
                          child: const Text("confirm",style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Have account?",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                                  (route) => false,
                            );
                          },
                          child: Text(
                            "Sign in",
                            style: TextStyle(color: PrimaryColor.color),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> setNewPassword() async {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordTEController.text.length > 7) {
        if (_newPasswordTEController.text ==
            _confirmPasswordTEController.text) {
          setPasswordInProgress = true;
          if (mounted) {
            setState(() {});
          }
          final NetworkResponse response = await NetworkCaller.postRequest(
            Urls.setNewPassword,
            body: {
              "email": widget.email,
              "OTP": widget.pin,
              "password": _newPasswordTEController.text,
            },
          );
          setPasswordInProgress = false;
          if (mounted) {
            setState(() {});
          }

          if (response.isSuccess) {
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
              );
            }
          } else {
            if (mounted) {
              SnackMsg(context, "Action Failed! Please try again.", true);
            }
          }
        } else {
          SnackMsg(context, "Plz confirm password does not matched", true);
        }
      } else {
        SnackMsg(context, "Minimum password length must be 8", true);
      }
    }
  }
}