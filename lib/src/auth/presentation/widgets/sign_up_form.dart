// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:education_app/core/common/widgets/i_field.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    required this.emailController,
    required this.fullNameController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController fullNameController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey formKey;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool obscuredPassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: Column(
          children: [
            IField(
              controller: widget.emailController,
              hintText: 'Email Address',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 25),
            IField(
              controller: widget.fullNameController,
              hintText: 'Full Name',
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 25),
            IField(
              controller: widget.passwordController,
              hintText: 'Password',
              keyboardType: TextInputType.visiblePassword,
              obscuredText: obscuredPassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscuredPassword = !obscuredPassword;
                  });
                },
                icon: Icon(
                  obscuredPassword ? IconlyLight.show : IconlyLight.hide,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 25),
            IField(
              controller: widget.confirmPasswordController,
              hintText: 'Confirm Password',
              obscuredText: obscuredPassword,
              keyboardType: TextInputType.visiblePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscuredPassword = !obscuredPassword;
                  });
                },
                icon: Icon(
                  obscuredPassword ? IconlyLight.show : IconlyLight.hide,
                ),
              ),
              validator: (value) {
                if (value != widget.passwordController.text) {
                  return 'Password do not match';
                }
                return null;
              },
            ),
          ],
        ));
  }
}
