import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psinsx/pages/home_page.dart';
import 'package:psinsx/pages/insx_page.dart';
import 'package:psinsx/pages/signin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/homePage': (BuildContext context) => HomePage(),
  '/signIn': (BuildContext context) => SignIn(),
  '/insxPage': (BuildContext context) => InsxPage(),
  
};

String initialRount;

Future<Null> main()async {
 WidgetsFlutterBinding.ensureInitialized();
 SharedPreferences preferences = await SharedPreferences.getInstance();
 String string = preferences.getString('id');
 if (string?.isEmpty??true) {
   initialRount = '/signIn';
   runApp(MyApp());
 } else {
    initialRount = '/homePage';
   runApp(MyApp());
 }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'สดุดียี่สิบสาม',
      theme: ThemeData(
          fontFamily: 'Prompt',
          brightness: Brightness.dark,
          //primarySwatch: Colors.red,
          primaryColor: Colors.red[900],
          accentColor: Colors.redAccent,
          textTheme: TextTheme(
            headline5: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 18),
          )),
      debugShowCheckedModeBanner: false,
      routes: map,
      initialRoute: initialRount,
    );
  }
}
