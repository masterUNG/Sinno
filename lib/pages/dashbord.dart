import 'package:flutter/material.dart';
import 'package:psinsx/pages/map.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashbord extends StatefulWidget {
  Dashbord({Key key}) : super(key: key);

  @override
  _DashbordState createState() => _DashbordState();
}

class _DashbordState extends State<Dashbord> {
  String nameUser;

  @override
  void initState() {
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('staffname');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MyMap(),
          // Positioned(
          //   top: 8,
          //   left: 10,
          //   child: pinGreen(),
          // ),
          // Positioned(
          //   top: 75,
          //   left: 10,
          //   child: pinYellow(),
          // ),
          //  Positioned(
          //   top: 142,
          //   left: 10,
          //   child: pinBlue(),
          // ),
          // Positioned(
          //   top: 205,
          //   left: 10,
          //   child: pinRed(),
          // ),
        
        ],
      ),
    );
  }

      Widget pinRed() {
    return GestureDetector(
      child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pin_drop,
                size: 30,
                color: Colors.red,
              ),
              Text(
                '342',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              )
            ],
          ),
          color: Colors.red[100]),
    );
  }

    Widget pinBlue() {
    return GestureDetector(
      child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pin_drop,
                size: 30,
                color: Colors.blue,
              ),
              Text(
                '342',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              )
            ],
          ),
          color: Colors.red[100]),
    );
  }

  Widget pinGreen() {
    return GestureDetector(
      child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pin_drop,
                size: 30,
                color: Colors.green,
              ),
              Text(
                '34',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              )
            ],
          ),
          color: Colors.red[100]),
    );
  }


  Widget pinYellow() {
    return GestureDetector(
      child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pin_drop,
                size: 30,
                color: Colors.yellow,
              ),
              Text(
                '34',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              )
            ],
          ),
          color: Colors.red[100]),
    );
  }

 



  


 
}
