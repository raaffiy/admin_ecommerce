import 'package:admin/components/my_button.dart';
import 'package:admin/components/my_textfield_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              backgroundColor: Colors.white,
              content: Text(
                'Password reset link sent! Check your email',
                style: TextStyle(color: Colors.red),
              ),
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              backgroundColor: Colors.white,
              content: Text(
                "Enter Email Correctly",
                style: TextStyle(color: Colors.red),
              ),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        elevation: 0,
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Container(
            width: 135,
            height: 135,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: Image.asset(
                'assets/forgot_account.png',
              ),
            ),
          ),

          // Text
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Enter Your Email and we will send you a password reset link',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),

          const SizedBox(height: 20),

          // email textfield
          MyTextFieldEmail(
            controller: emailController,
            hintText: 'Email',
            obscureText: false,
          ),

          const SizedBox(height: 15),

          // Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: MyButton(
              text: "Reset Password",
              onTap: passwordReset,
            ),
          ),
        ],
      ),
    );
  }
}
