import 'dart:convert';
import 'dart:io';
import 'package:education_app/core/common/widgets/gradient_background.dart';
import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  //actively checking changes
  //save or collect the info of currenet user

  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final bioController = TextEditingController();

  File? pickedImage;

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedImage = File(image.path);
      });
    }
  }

  bool get nameChanged =>
      context.currentUser!.fullName.trim() != fullNameController.text.trim();

  bool get emailChanged =>
      context.currentUser!.email.trim() != emailController.text.trim();

  bool get passwordChanged => passwordController.text.trim().isNotEmpty;

  bool get bioChanged =>
      context.currentUser?.bio?.trim() != bioController.text.trim();

  bool get imageChange => pickedImage != null;

  bool get nothingChanged =>
      !nameChanged &&
      !emailChanged &&
      !passwordChanged &&
      !bioChanged &&
      !imageChange;

  @override
  void initState() {
    fullNameController.text = context.currentUser!.fullName.trim();
    emailController.text = context.currentUser!.email.trim();
    bioController.text = context.currentUser!.bio?.trim() ?? '';
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    bioController.dispose();
    passwordController.dispose();
    oldPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UserUpdated) {
          CoreUtils.showSnackBar(context, 'Profile updated Successfully');
          context.pop();
        } else if (state is AuthError) {
          CoreUtils.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: const NestedBackButton(),
            title: const Text(
              'Edit Profile',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (nothingChanged) {
                    context.pop();
                  }
                  final bloc = context.read<AuthBloc>();
                  if (passwordChanged) {
                    if (oldPasswordController.text.isEmpty) {
                      CoreUtils.showSnackBar(
                        context,
                        'Please enter your old password',
                      );
                      return;
                    }
                    bloc.add(
                      UpdateUserEvent(
                        action: UpdateUserAction.password,
                        userData: jsonEncode({
                          'oldPassword': oldPasswordController.text.trim(),
                          'newPassrod': passwordController.text.trim(),
                        }),
                      ),
                    );
                  }
                  if (nameChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        action: UpdateUserAction.displayName,
                        userData: fullNameController.text.trim(),
                      ),
                    );
                  }
                  if (emailChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        action: UpdateUserAction.email,
                        userData: emailController.text.trim(),
                      ),
                    );
                  }
                  if (bioChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        action: UpdateUserAction.bio,
                        userData: bioController.text.trim(),
                      ),
                    );
                  }
                  if (imageChange) {
                    bloc.add(
                      UpdateUserEvent(
                        action: UpdateUserAction.profilePic,
                        userData: pickedImage,
                      ),
                    );
                  }
                },
                child: state is AuthLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : StatefulBuilder(
                        builder: (_, refresh) {
                          fullNameController.addListener(() => refresh(() {}));
                          emailController.addListener(() => refresh(() {}));
                          passwordController.addListener(() => refresh(() {}));
                          bioController.addListener(() => refresh(() {}));
                          return Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: nothingChanged
                                  ? Colors.grey
                                  : Colors.blueAccent,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          body: GradientBackground(
            image: MediaRes.profileGradientBackground,
            child: ListView(),
          ),
        );
      },
    );
  }
}
