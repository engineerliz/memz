import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/users/UserStore.dart';
import 'package:memz/components/scaffold/CommonScaffold.dart';
import 'package:memz/features/profile/UserProfileView.dart';
import 'package:memz/styles/fonts.dart';

import '../../../res/custom_colors.dart';
import '../../../screens/authentication/email_password/email_password.dart';
import '../../components/scaffold/CommonAppBar.dart';
import '../../utilsBoilerplate/authentication/email_password_auth/authentication.dart';
import '../../utilsBoilerplate/authentication/email_password_auth/validator.dart';
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
  late bool _isEmailVerified;
  late User? _user;
  bool _verificationEmailBeingSent = false;

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final homeBaseController = TextEditingController();

  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser;
    _isEmailVerified = _user?.emailVerified ?? false;

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    homeBaseController.dispose();

    super.dispose();
  }

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
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
                // Navigator.of(context).pop(),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _isEmailVerified
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check,
                                size: 18,
                                color: MColors.green,
                              ),
                              const SizedBox(width: 8.0),
                              const Text(
                                'Email is verified',
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 20,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.close,
                                size: 18,
                                color: MColors.red,
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                'Email not verified',
                                style: SubHeading.SH14
                                    .copyWith(color: MColors.red),
                              ),
                            ],
                          ),
                    const SizedBox(height: 8.0),
                    Visibility(
                      visible: !_isEmailVerified,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _verificationEmailBeingSent
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Palette.firebaseGrey,
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _verificationEmailBeingSent = true;
                                    });
                                    await _user!.sendEmailVerification();
                                    setState(() {
                                      _verificationEmailBeingSent = false;
                                    });
                                  },
                                  child: Text('Resend Verification Email',
                                      style: SubHeading.SH14),
                                  style: const ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            MColors.grayV9),
                                  ),
                                ),
                          const SizedBox(width: 16.0),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () async {
                              User? user =
                                  await Authentication.refreshUser(_user!);

                              if (user != null) {
                                setState(() {
                                  _user = user;
                                  _isEmailVerified = user.emailVerified;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),
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
                                Navigator.of(context, rootNavigator: true)
                                    .pop();

                              }
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ));
                              // Navigator.of(context)
                              //     .pushReplacement(_routeToSignInScreen());
                            },
                            child: Text('Sign out???',
                                style: SubHeading.SH18
                                    .copyWith(color: MColors.red)),
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  MColors.grayV9),
                            ),
                          ),

                    // : ElevatedButton(
                    //     style: ButtonStyle(
                    //       backgroundColor: MaterialStateProperty.all(
                    //         Colors.redAccent,
                    //       ),
                    //       shape: MaterialStateProperty.all(
                    //         RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(10),
                    //         ),
                    //       ),
                    //     ),
                    // onPressed: () async {
                    //   setState(() {
                    //     _isSigningOut = true;
                    //   });
                    //   await FirebaseAuth.instance.signOut();
                    //   setState(() {
                    //     _isSigningOut = false;
                    //   });
                    //   if (!mounted) return;
                    //   Navigator.of(context)
                    //       .pushReplacement(_routeToSignInScreen());
                    // },
                    //     child: const Padding(
                    //       padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    //       child: Text(
                    //         'Sign Out',
                    //         style: TextStyle(
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.white,
                    //           letterSpacing: 2,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    const SizedBox(height: 50),
                  ],
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
