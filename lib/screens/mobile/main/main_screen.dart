import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/add_bottom_sheet/add_bottom_sheet.dart';
import 'package:flutter_qualification_work/screens/mobile/main/chats/chats_list_screen.dart';
import 'package:flutter_qualification_work/screens/mobile/main/discover/discover_screen.dart';
import 'package:flutter_qualification_work/screens/mobile/main/profile/profile_screen.dart';
import 'package:flutter_qualification_work/screens/mobile/main/search/search_screen.dart';
import 'package:flutter_svg/svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final widthButton = (screenWidth - 32 - 9) / 2;

    final screens = [
      DiscoverScreen(),
      SearchScreen(),
      Container(),
      ChatsListScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        type: BottomNavigationBarType.fixed,
        onTap: (index){
          if (index == 2){
            ShowAddBottomSheet().showAddBottomSheet(context, widthButton);
          }
          else{
            _onItemTapped(index);
          }
        },
        items:[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/tab_bar/toolbar_home.svg',
              color: Theme.of(context).colorScheme.primary,
            ),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/tab_bar/toolbar_search.svg',
              color: Theme.of(context).colorScheme.primary,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/tab_bar/toolbar_add.png'),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/tab_bar/toolbar_massage.svg',
              color: Theme.of(context).colorScheme.primary,
            ),
            label: 'Massage',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/tab_bar/toolbar_profile.svg',
              color: Theme.of(context).colorScheme.primary,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
