import 'package:flutter/material.dart';
import 'package:memz/features/profile/UserProfileView.dart';
import 'package:memz/styles/fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../styles/colors.dart';
import 'BottomBar.dart';
import 'CommonAppBar.dart';

class PullToRefresh extends StatefulWidget {
  final Widget? body;
  final VoidCallback? onRefresh;

  const PullToRefresh({
    super.key,
    this.body,
    this.onRefresh,
  });

  @override
  PullToRefreshState createState() => PullToRefreshState();
}

class PullToRefreshState extends State<PullToRefresh> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    if (widget.onRefresh != null) {
      widget.onRefresh!();
    }

    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: widget.body ?? const SizedBox(),
    );
  }
}
