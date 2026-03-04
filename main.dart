import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_event_management_app/admin/manage_event.dart';
//import 'package:smart_event_management_app/admin/updateevent.dart';
import 'package:smart_event_management_app/auth/loginpage.dart';
import 'package:smart_event_management_app/auth/signup_page.dart';
import 'package:smart_event_management_app/admin/home_admin.dart';
import 'package:smart_event_management_app/admin/create_event.dart';
import 'package:smart_event_management_app/user/home_user.dart';
import 'package:smart_event_management_app/services/authdatabase.dart';
//import 'package:smart_event_management_app/user/user_eventdetails.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event Management App',
      theme: ThemeData(
      colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),

      routes: {
        "/" : (context) => CheckuserloggedIn(),
        "/login" : (context) => LoginPage(),
        "/signup" : (context) => SignUpPage(),
        "/adminhome" : (context) => AdminHome(),
        "/userhome" : (context) => UserHome(),
        "/createEvent" : (context) => CreateEvent(),
        "/manageEvent" : (context)  => ManageEvent(),
        //"/usereventdetails":(context) => UsereventDetails(),
      //  "/updateEvent" : (context) => UpdateEvent(),
      },
      
    );
  }
}

class CheckuserloggedIn extends StatefulWidget {
  const CheckuserloggedIn({super.key});

  @override
  State<CheckuserloggedIn> createState() => _CheckuserloggedInState();
}

class _CheckuserloggedInState extends State<CheckuserloggedIn> {

  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Checkuserrole(); 
    }
    );
  }
  
  void Checkuserrole() async {
     String? role = await AuthenticationHelper.checkuser();

     if(!mounted){
      return;
     }

     if(role == "admin"){
      Navigator.pushReplacementNamed(context, "/adminhome");
     }
     else if(role == "user"){
      Navigator.pushReplacementNamed(context, "/userhome");
     }
     else{
      Navigator.pushReplacementNamed(context,"/login");
     }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title:  Text("Loading")),
      body: Center(
        child: 
            CircularProgressIndicator(),
          
        )
        
      );
    
  }
}

