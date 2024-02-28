import 'package:artist_community_admin/screens/artist_details_screen.dart';
import 'package:artist_community_admin/screens/user_details_page.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import '../screens/category_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/main_category_screen.dart';
import '../screens/sub_category_screen.dart';

class SideMenu extends StatefulWidget {
  static const String id = 'side-menu';

  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  Widget _selectedScreen = const DashBoardScreen();
  screenSelector(item){
    switch (item.route){
      case DashBoardScreen.id :
        setState(() {
          _selectedScreen = const DashBoardScreen();
        });
        break;
      case CategoryScreen.id :
        setState(() {
          _selectedScreen = const CategoryScreen();
        });
        break;
      case MainCategoryScreen.id :
        setState(() {
          _selectedScreen = const MainCategoryScreen();
        });
        break;
      case SubCategoryScreen.id :
        setState(() {
          _selectedScreen = const SubCategoryScreen();
        });
        break;
      case ArtistDetailsScreen.id :
        setState(() {
          _selectedScreen = const ArtistDetailsScreen();
        });
        break;
      case UserDetailsPage.id :
        setState(() {
          _selectedScreen = const UserDetailsPage();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            route: DashBoardScreen.id,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Categories',
            icon: Icons.category,
            children: [
              AdminMenuItem(
                title: 'Category',
                route: CategoryScreen.id,
              ),
              AdminMenuItem(
                title: 'Main Category',
                route: MainCategoryScreen.id,
              ),
              AdminMenuItem(
                title: 'Sub Category',
                route: SubCategoryScreen.id,
              ),
            ],
          ),
          AdminMenuItem(
            title: 'Artist Details',
            route: ArtistDetailsScreen.id,
            icon: Icons.person,
          ),
          AdminMenuItem(
            title: 'User Details',
            route: UserDetailsPage.id,
            icon: Icons.supervised_user_circle_rounded,
          ),

        ],
        selectedRoute: SideMenu.id,
        onSelected: (item) {
          screenSelector(item);
          // if (item.route != null) {
          //   Navigator.of(context).pushNamed(item.route!);
          // }
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Artispic',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
                ),
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child:  Center(
            child: Text(
              DateTimeFormat.format(DateTime.now(), format: AmericanDateFormats.dayOfWeek),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body:_selectedScreen,

    );
  }
}