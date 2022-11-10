import 'package:flutter/material.dart';

import '../../components/button/Button.dart';
import '../../styles/fonts.dart';
import '../search/SearchView.dart';

class EmptyFeedMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Find friends to see pins here', style: SubHeading.SH14),
        const SizedBox(height: 8),
        Button(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SearchView(),
            ));
          },
          label: 'Search for friends',
        ),
      ],
    );
  }
}
