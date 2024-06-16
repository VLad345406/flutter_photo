import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/screens/mobile/main/add_photo_info.dart';
import 'package:flutter_qualification_work/screens/web/main/web_chats_screen.dart';
import 'package:flutter_qualification_work/screens/web/main/web_discover_screen.dart';
import 'package:flutter_qualification_work/screens/web/main/profile/web_profile_screen.dart';
import 'package:flutter_qualification_work/screens/web/main/search/web_search_screen.dart';
import 'package:flutter_qualification_work/services/pick_files_service.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class WebMainScreen extends StatefulWidget {
  const WebMainScreen({super.key});

  @override
  State<WebMainScreen> createState() => _WebMainScreenState();
}

class _WebMainScreenState extends State<WebMainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      WebDiscoverScreen(),
      WebSearchScreen(),
      Container(),
      WebChatsScreen(),
      WebProfileScreen(),
    ];

    return Scaffold(
      body: Row(
        children: [
          SizedBox(width: 16),
          SizedBox(
            height: double.infinity,
            width: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: _selectedIndex == 0
                        ? Colors.red
                        : Theme.of(context).colorScheme.secondary,
                  ),
                  child: IconButton(
                    onPressed: () {
                      _onItemTapped(0);
                    },
                    icon: SvgPicture.asset(
                      'assets/tab_bar/toolbar_home.svg',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: _selectedIndex == 1
                        ? Colors.red
                        : Theme.of(context).colorScheme.secondary,
                  ),
                  child: IconButton(
                    onPressed: () {
                      _onItemTapped(1);
                    },
                    icon: SvgPicture.asset(
                      'assets/tab_bar/toolbar_search.svg',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    Uint8List image = await selectGalleryImage();
                    if (image.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPhotoInfo(
                            image: image,
                          ),
                        ),
                      ).then((value) => Navigator.pop(context));
                    }
                  },
                  icon: Image.asset('assets/tab_bar/toolbar_add.png'),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: _selectedIndex == 3
                        ? Colors.red
                        : Theme.of(context).colorScheme.secondary,
                  ),
                  child: IconButton(
                    onPressed: () {
                      _onItemTapped(3);
                    },
                    icon: SvgPicture.asset(
                      'assets/tab_bar/toolbar_massage.svg',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: _selectedIndex == 4
                        ? Colors.red
                        : Theme.of(context).colorScheme.secondary,
                  ),
                  child: IconButton(
                    onPressed: () {
                      _onItemTapped(4);
                    },
                    icon: SvgPicture.asset(
                      'assets/tab_bar/toolbar_profile.svg',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: screens[_selectedIndex],
          ),
        ],
      ),
      //body: screens[_selectedIndex],
    );
  }
}
