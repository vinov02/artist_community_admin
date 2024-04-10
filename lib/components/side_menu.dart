import 'package:artist_community_admin/screens/artist_details_screen.dart';
import 'package:artist_community_admin/screens/exhibition_details.dart';
import 'package:artist_community_admin/screens/paintings_page.dart';
import 'package:artist_community_admin/screens/settings_screen.dart';
import 'package:artist_community_admin/screens/user_details_page.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import '../screens/category_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/main_category_screen.dart';
import '../screens/products.dart';
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
      case SettingsScreen.id :
        setState(() {
          _selectedScreen = const SettingsScreen();
        });
        break;
      case ImageUploadScreen.id :
        setState(() {
          _selectedScreen =  const ImageUploadScreen();
        });
        break;
     case ExhibitionDetails.id :
      setState(() {
        _selectedScreen =  const ExhibitionDetails();
      });
      break;
     case PaintingsPage.id :
        setState(() {
          _selectedScreen =  const PaintingsPage();
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
            icon: Icons.dashboard_outlined,
          ),
          AdminMenuItem(
            title: 'Categories',
            icon: Icons.category_outlined,
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
            icon: Icons.person_2_outlined,
          ),
          AdminMenuItem(
            title: 'User Details',
            route: UserDetailsPage.id,
            icon: Icons.supervised_user_circle_outlined,
          ),
          AdminMenuItem(
            title: 'Add Product Category',
            route: ImageUploadScreen.id,
            icon: Icons.image,
          ),
          AdminMenuItem(
            title: 'Exhibition Details',
            route: ExhibitionDetails.id,
            icon: Icons.post_add,
          ),
          AdminMenuItem(
            title: 'Paintings Details',
            route: PaintingsPage.id,
            icon: Icons.collections,
          ),
          AdminMenuItem(
            title: 'Settings',
            route: SettingsScreen.id,
            icon: Icons.settings_outlined,
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
          color: Colors.deepPurple,
          child: const Center(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '   Artispic',
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
          color: Colors.deepPurple,
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