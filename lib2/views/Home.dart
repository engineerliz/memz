import 'package:flutter/material.dart';
import '../../lib2/views/SignIn.dart';
import '../../lib2/views/UserInfo.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final List<String> _listFireItems = [
    'Authentication',
    'Database',
    'Backend Actions',
    'Machine Learning',
    'Other utilities',
  ];

  final List<String> _listFireIcons = [
    'assets/love-emoji.png'
    'assets/love-emoji.png'
    'assets/love-emoji.png'
    'assets/love-emoji.png'
    'assets/love-emoji.png'

    // FireAssets.fireAuthentication,
    // FireAssets.fireDatabase,
    // FireAssets.fireBackend,
    // FireAssets.fireMachineLearning,
    // FireAssets.fireOtherUtilities,
  ];

  final List<Widget?> _listFeatureScreens = [
    SignInScreen(),
    // UserInfoScreen(),
    null,
    null,
    null,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueGrey,
        title: Text('samples'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.blueGrey,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 100.0,
                ),
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => SizedBox(height: 8.0),
                  itemCount: _listFireItems.length,
                  itemBuilder: (context, index) => InkWell(
                    borderRadius: BorderRadius.circular(16.0),
                    onTap: _listFeatureScreens[index] != null
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    _listFeatureScreens[index]!,
                              ),
                            );
                          }
                        : null,
                    child: Card(
                      color: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(
                          //     24.0,
                          //     16.0,
                          //     16.0,
                          //     16.0,
                          //   ),
                          //   child: Image.asset(
                          //     _listFireIcons[index],
                          //     color: Colors.yellow,
                          //     width: 40.0,
                          //   ),
                          // ),
                          Text(
                            _listFireItems[index],
                            style: TextStyle(
                              color: Colors.white.withOpacity(
                                _listFeatureScreens[index] != null ? 1.0 : 0.5,
                              ),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Footer(),
            // ),
          ],
        ),
      ),
    );
  }
}
