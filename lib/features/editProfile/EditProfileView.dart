import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/users/UserStore.dart';
import 'package:memz/components/CommonScaffold.dart';

import '../../../res/custom_colors.dart';
import '../../../screens/authentication/email_password/email_password.dart';
import '../../../utils/authentication/email_password_auth/authentication.dart';
import '../../../utils/authentication/email_password_auth/validator.dart';
import '../../api/users/MUser.dart';

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
  var user;
  @override
  void initState() {
    user = widget.user;
  }

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = user?.name ?? '';
    return CommonScaffold(
        title: 'Edit Profile',
        body: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
              ),
            ]))

        // floatingActionButton: FloatingActionButton(
        //   // When the user presses the button, show an alert dialog containing
        //   // the text that the user has entered into the text field.
        //   onPressed: () {
        //     showDialog(
        //       context: context,
        //       builder: (context) {
        //         return AlertDialog(
        //           // Retrieve the text the that user has entered by using the
        //           // TextEditingController.
        //           content: Text(nameController.text),
        //         );
        //       },
        //     );
        //   },
        //   tooltip: 'Show me the value!',
        //   child: const Icon(Icons.text_fields),
        // ),
        );
  }
}
