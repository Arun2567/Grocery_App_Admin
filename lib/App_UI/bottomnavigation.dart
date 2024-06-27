import 'package:flutter/material.dart';
import 'package:my_project/App_UI/Others.dart';
import 'package:my_project/App_UI/Userprofile.dart';
import 'package:my_project/App_UI/orderdetails.dart';
import 'package:my_project/App_UI/viewproducts.dart';



class bottomnavigation extends StatefulWidget {

  @override
  _bottomnavigationState createState() => _bottomnavigationState();
}

class _bottomnavigationState extends State<bottomnavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Retrivedata(),
    Others(),
    OrderCategory(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red.withOpacity(1.0),// Set the background color here
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo,),
            label: 'images',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag,),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.cyan,
        selectedLabelStyle: TextStyle(color: Colors.cyan),
        unselectedItemColor: Colors.black,
        unselectedLabelStyle: TextStyle(color: Colors.black),
      ),

    );
  }
}