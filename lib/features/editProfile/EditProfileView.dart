import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/users/UserStore.dart';
import 'package:memz/components/scaffold/CommonScaffold.dart';
import 'package:memz/styles/fonts.dart';

import '../../../screens/authentication/email_password/email_password.dart';
import '../../components/scaffold/CommonAppBar.dart';
import '../../api/users/UserModel.dart';
import '../../styles/colors.dart';

// Define a custom Form widget.
class EditProfileView extends StatefulWidget {
  final UserModel? user;

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
  bool _isSigningOut = false;

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
      usernameController.text = widget.user!.username ?? '';
      emailController.text = widget.user!.email;
      homeBaseController.text = widget.user!.homeBase ?? '';

      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: CommonScaffold(
          title: 'Edit Profile',
          appBar: CommonAppBar(
            title: 'Edit Profile',
            rightWidget: GestureDetector(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  'Save',
                  style: SubHeading.SH14,
                ),
              ),
              onTap: () async => {
                await UserStore.updateUser(
                    user: widget.user!.updateEditableFields(
                  newName: nameController.text,
                  newUsername: usernameController.text,
                  newEmail: emailController.text,
                  newHomebase: homeBaseController.text,
                )),
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListView(
              children: [
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
                    controller: homeBaseController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Homebase',
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
                const SizedBox(height: 50),
                _isSigningOut
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.redAccent,
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isSigningOut = true;
                          });
                          await FirebaseAuth.instance.signOut();
                          setState(() {
                            _isSigningOut = false;
                          });
                          if (!mounted) return;
                          if (Navigator.canPop(context)) {
                            print('canPop!');
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => SignInScreen(),
                          ));
                        },
                        child: Text('Sign out',
                            style:
                                SubHeading.SH18.copyWith(color: MColors.red)),
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(MColors.grayV9),
                        ),
                      ),
              ],
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
