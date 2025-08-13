// ignore: file_names
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {

  final List<String> _options=[
    "HOME","CART","MENU","SETTINGS","FAVORITES"
  ];
  int _currentIndex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CurvedNavigationBar",style: TextStyle(
          fontWeight: FontWeight.bold
        ),),
        elevation: 0,
      ),
      body: Container(
        color: Colors.red,
        child: Center(
            child: Text(_options[_currentIndex],
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
        )),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.red,
        animationDuration: Duration(seconds: 1),
        animationCurve: Curves.bounceOut,
        items: <Widget>[
          Icon(Icons.home,color: Colors.red,),
          Icon(Icons.shopping_cart,color: Colors.red,),
          Icon(Icons.restaurant_menu,color: Colors.red,),
          Icon(Icons.settings,color: Colors.red,),
          Icon(Icons.favorite,color: Colors.red,),

        ],
        onTap: (index){
          setState(() {
            _currentIndex=index;
          });
        },
      ),
    );
  }
}
