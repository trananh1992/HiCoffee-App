

import 'package:flutter/material.dart';
import 'package:hicoffee/widgets/slide_right_route.dart';
import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:hicoffee/screens/search_screen.dart';
import 'package:hicoffee/model/item.dart';
import 'package:hicoffee/widgets/wave.dart';
import 'package:hicoffee/widgets/cardLists.dart';
import 'package:hicoffee/screens/addItem_screen.dart';
class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  // Collection Data

  bool clickedOnSearch;
  int selectedMenuItemId;

  TextEditingController editingController = TextEditingController();
  Icon customIcon = Icon(Icons.search);
  Widget customTitle = Text(
    "Hi Coffee",
    style: TextStyle(
      fontSize: 19.0,
      fontWeight: FontWeight.bold,
    ),
  );




  final menu = new Menu(
    items: [
      new MenuItem(
        id: 'home',
        title: 'Home',
      ),
      new MenuItem(
        id: 'nightmode',
        title: 'Night Mode',
      ),
      new MenuItem(
        id: 'terms',
        title: 'Terms of Service',
      ),
      new MenuItem(
        id: 'about',
        title: 'About us',
      ),
    ],
  );

  List<Item> list = [Item("hello",3), Item("کلمبیا۱۹", 33), Item("اندونزی مدیوم", 30), Item("میلانو", 0), Item("ترک لایت", 25), Item("سالوادور", 0), Item("نیکاراگوئه", 28), Item("پرو", 5), Item("ویتنام", 0), Item("گلد اکوادور(بسته ۵ کیلویی)", 0), Item("چای ماسالا (بسته)", 30), Item("اتیوپی", 30), Item("پی بی", 15), Item("چری", 15), Item("برزیل", 19), Item(null,0)];
  List<String> tempList = [];

  // End of Collecting Data



  @override
  void initState() {
    super.initState();
//    tempList = list;
    clickedOnSearch = false;
  }



  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
      appBar: _appBar(),
      drawers: [
        _drawer(),
      ],
      builder: (context, id) => Scaffold(
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Stack(
            children: <Widget>[
              Center(child: CardLists(list: list)),
              Wave(),
            ],
          ),
        ),
        floatingActionButton: _floatingActionButton(),
      ),
    );
  }
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: _appBar(),
//      body: Container(
//        color: Theme.of(context).scaffoldBackgroundColor,
//        child: Stack(
//          children: <Widget>[
//            Center(child: CardLists(list: list)),
//            Wave(),
//          ],
//        ),
//      ),
//      floatingActionButton: _floatingActionButton(),
//    );
//  }


  Widget _drawer(){
    return SideDrawer(
        degree: 45,
        drawerWidth: MediaQuery.of(context).size.width/2.4,
        color: Theme.of(context).primaryColor,
        selectedItemId: selectedMenuItemId,
        onMenuItemSelected: (itemId) {
          setState(() {
            selectedMenuItemId = itemId;
          });
        },
        menu: menu,
        itemBuilder:
            (BuildContext context, MenuItem itemMenu, bool isSelected) {
          return Container(
            color: isSelected
                ? Theme.of(context).accentColor.withOpacity(0.7)
                : Colors.transparent,
            padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Text(
              itemMenu.title,
              style: Theme.of(context).textTheme.subhead.copyWith(
//                      color: isSelected ? Colors.black87 : Colors.black54),
                  color: Colors.black87),
            ),
          );
        }
    );
  }

  Widget _appBar(){
    return AppBar(
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        elevation: 0.0,
        centerTitle: true,
        title: customTitle,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 600),
                      pageBuilder: (_, __, ___) => SearchScreen(list: list)
                  ),
//              Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => SearchScreen(list: list)),
              );
            },
            icon: Hero(
              tag: "search",
              child: customIcon
            ),
          ),
        ]
    );
  }

  Widget _floatingActionButton(){
    return Align(
      alignment: Alignment(0.9, 0.95),
      child: FloatingActionButton(
        splashColor: Colors.blue,
        onPressed: (){
          setState(() {
            Navigator.push(
              context,
              SlideRightRoute(page: AddItemScreen(list: list)),
            );
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => AddItemScreen(list: list)),
//            );

          });
        },
        elevation: 20.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).accentColor, width: 2.0),
            borderRadius: BorderRadius.all(
                Radius.circular(20.0)
            )
        ),
        child: Icon(
          Icons.add,
          size: 36.0,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
