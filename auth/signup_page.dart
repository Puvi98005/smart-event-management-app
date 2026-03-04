import 'package:flutter/material.dart';
import 'package:smart_event_management_app/fluttertoast.dart';
import 'package:smart_event_management_app/services/authdatabase.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController role = TextEditingController();
  bool ispasswordvisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("SignUp Page", style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 46, 1, 82)),),),

      body: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text("Admin/User",style: TextStyle(fontSize: 20, )),
                 SizedBox(height: 10,),
                 TextField(
                  controller: role,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    hintText: "Enter Admin / user ",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.email),
                    
                   ),
                 ),
                 SizedBox(height: 10,),
                 Text("Email",style: TextStyle(fontSize: 20, )),
                 TextField(
                   controller: email,
                   decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    hintText: "Enter your email ",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.email),
                    
                   ),
                 ),
                 SizedBox(height: 10,),
                    
                 Text("Password",style: TextStyle(fontSize: 20, )),
                    
                 TextField(
                   controller: password,
                   obscureText: !ispasswordvisible,
                   decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    hintText: "Enter your password ",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.password),
                    suffixIcon: IconButton(
                      icon: Icon(
                        ispasswordvisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: (){
                       setState(() {
                         ispasswordvisible = !ispasswordvisible ;
                       });
                    }, )
                    
                   ),
                 ),
                 SizedBox(height: 20,),
                Padding( padding: EdgeInsetsGeometry.all(20),
                  child: Row( 
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [  
                   ElevatedButton(onPressed: (){
                      Navigator.pushNamed(context, "/login");
                   }, child: const Text("Cancel")),
                  
                   ElevatedButton(
                    onPressed: () async{
                  if(email.text.isEmpty || password.text.isEmpty){
                    Message.show(message: "Please fill all fiels");
                    return;
                  }
            
                      var enteredEmail = email.text.trim().toLowerCase();
                      var enteredpassword = password.text.trim().toLowerCase();
                      var enteredrole  = role.text.trim().toString();
            
                      if(!enteredEmail.endsWith("@gmail.com")){
                         Message.show(message: "Email must ends with @gmail.com");
                         email.clear();
                         return ;
                      }
                   
                    
                    if(enteredrole== "admin"){
                    RegExp digits = RegExp(r'^[0-9]+$');
            
                    if(!digits.hasMatch(enteredpassword)){
                       Message.show(message: "Admin password must contain only digits");
                       password.clear();
                       return;
                    }
                    }
                    else if(enteredrole=="user"){
                      RegExp regExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]+$');
                      if(!regExp.hasMatch(enteredpassword)){
                        Message.show(message: "User password must contain letters and numbers");
                        password.clear();
                        return ;
                      }
                    }
            
                      await AuthenticationHelper.createUserWithEmailAndPassword(enteredEmail, enteredpassword, enteredrole).then((value){
                        if(value == "Account created Successfully!"){
                           Message.show(message: "$enteredrole Account created Successfully!");
                           return Navigator.popAndPushNamed(context, "/login");
                  
                        }
                        else if(value == "This email is already registered. Try another email."){
                          Message.show(message:"This email is already registered. Try another email." );
                        }
                      });
                    }, child: const Text("Sign Up")),], ),
                ),
                    
                  SizedBox(height: 20,),
                    
                  Row( mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text("Already have an account?"),
                    TextButton(onPressed: (){
                       Navigator.pushReplacementNamed(context, "/login");
                    }, child: const Text("Login"))
                  ],),
              ],
              ),
          ),
        ),
      ) ,);
  }
}