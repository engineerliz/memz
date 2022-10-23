import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/users/UserStore.dart';
import 'package:memz/components/CommonScaffold.dart';
import 'package:memz/features/profile/ProfileView.dart';

import '../../../res/custom_colors.dart';
import '../../../screens/authentication/email_password/email_password.dart';
import '../../../utils/authentication/email_password_auth/authentication.dart';
import '../../../utils/authentication/email_password_auth/validator.dart';
import '../../api/users/MUser.dart';
import '../../styles/colors.dart';

// Define a custom Form widget.
class EditProfileView extends StatefulWidget {
  final MUser? user;

  const EditProfileView({
    super.key,
    this.user,
  });

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _EditProfileViewState extends State<EditProfileView> {

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final homeBaseController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    homeBaseController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.user != null) {
      nameController.text = widget.user!.name ?? '';
      usernameController.text = widget.user!.username;
      emailController.text = widget.user!.email;
      homeBaseController.text = widget.user!.homeBase ?? '';

      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: CommonScaffold(
        title: 'Edit Profile',
        body: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: nameController,
                    decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
              ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    controller: homeBaseController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Homebase',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async => {
                    await UserStore.updateUser(
                        user: widget.user!.updateEditableFields(
                      newName: nameController.text,
                      newUsername: usernameController.text,
                      newEmail: emailController.text,
                      newHomebase: homeBaseController.text,
                    )),
                    Navigator.of(context).pop(),
                  },
                  child: const Text('Save'),
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(MColors.grayV9),
                  ),
                ),
              ]),
            )

          ),
      );
    }
    return const SizedBox();
  }
}
