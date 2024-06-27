import 'package:flutter/material.dart';
import 'package:my_project/App_UI/bottomnavigation.dart';
import 'package:my_project/App_UI/verification.dart';
import 'package:shared_preferences/shared_preferences.dart';


String finalEmail="";

class SplashScreen1 extends StatefulWidget {

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {


  @override
  void initState() {
    getvalidationData();
    getvalidationData().whenComplete(() async{
      Future.delayed(Duration(seconds: 2), () => Navigator.push(context, MaterialPageRoute(builder: (context)=>((finalEmail==null || finalEmail.isEmpty) ? Numberverification() : bottomnavigation()))));
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Text("hi....."),
      ),
    );
  }


  Future getvalidationData() async {
    final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    var obtainedEmail = sharedpreferences.getString("name");
    setState(() {
      finalEmail = obtainedEmail!;
    });
    print("--------------------------------------->$finalEmail");
  }
}
