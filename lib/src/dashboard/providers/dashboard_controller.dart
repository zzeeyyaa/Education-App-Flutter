import 'package:education_app/core/common/app/providers/tab_navigator.dart';
import 'package:education_app/core/common/views/persistent_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardController extends ChangeNotifier {
  final List<Widget> _screen = [
    //add a page
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: const Placeholder(),
        ),
      ),
      child: const PersistentView(),
    ),
  ];
  //register the base screen
  //inject tabnavigator
}
