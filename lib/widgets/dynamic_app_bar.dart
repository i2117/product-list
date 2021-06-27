import 'package:flutter/material.dart';

class DynamicSliverAppBar extends StatelessWidget {
  static const double collapsedHeight = 40;
  static const double expandedHeight = 150;
  static const double minImageSize = 0;
  static const double maxImageSize = 70;

  final String title;
  final Color expandedColor;
  final Color collapsedColor;

  DynamicSliverAppBar({
    @required this.title,
    this.expandedColor = Colors.deepPurple,
    this.collapsedColor = Colors.lightBlueAccent,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: collapsedColor,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        collapseMode: CollapseMode.pin,
        stretchModes: [StretchMode.zoomBackground],
        titlePadding: EdgeInsets.zero,
        title: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/app_bar.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: DynamicSliverAppBar.collapsedHeight,
                child: Center(child: Text(title)),
              ),
            ],
          ),
        ),
        background: Container(
          color: expandedColor,
        ),
      ),
      // В нашем случае убираем тулбар вообще
      toolbarHeight: 0,
      collapsedHeight: DynamicSliverAppBar.collapsedHeight,
      expandedHeight: DynamicSliverAppBar.expandedHeight,
    );
  }
}
