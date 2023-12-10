import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String subTitle;
  final String? link;
  final IconData icon;

  const MenuItem(
      {required this.title,
      required this.subTitle,
      this.link,
      required this.icon});
}

const appMenuItems = <MenuItem>[
  MenuItem(
      title: 'Notices',
      subTitle: 'Notices',
      link: '/notices',
      icon: Icons.search),
  MenuItem(
      title: 'Signup/Login',
      subTitle: 'Login',
      link: '/login',
      icon: Icons.login_rounded),
];

const appLoggedMenuItems = <MenuItem>[
  MenuItem(
      title: 'Notices',
      subTitle: 'Notices',
      link: '/notices',
      icon: Icons.search),
  MenuItem(
      title: 'My Advertisements',
      subTitle: 'My Advertisements',
      link: '/my-notices',
      icon: Icons.add),
  MenuItem(title: 'Log out', subTitle: 'Logout', icon: Icons.logout_rounded),
];
