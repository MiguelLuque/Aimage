import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuItem {
  final String title;
  final IconData icon;

  const MenuItem({required this.title, required this.icon});
}

const appMenuItems = <MenuItem>[
  MenuItem(title: 'Text to Image', icon: Icons.camera_alt_outlined),
  MenuItem(title: 'Image to Image', icon: FontAwesomeIcons.images),
  MenuItem(title: 'Inpaint Image', icon: FontAwesomeIcons.marker),
];
