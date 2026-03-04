
import 'package:flutter/material.dart';
import 'package:smart_event_management_app/fluttertoast.dart';
import 'package:smart_event_management_app/services/authdatabase.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

 TextEditingController email = TextEditingController();
 TextEditingController password = TextEditingController();
   bool ispasswordvisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Login Page", style: TextStyle(fontSize: 25, color: Color.fromARGB(255, 46, 1, 82)),),),

      body: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 SizedBox(height: 20,),
                 Text("Email", style: TextStyle(fontSize: 20, ),),
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
                    
                 Text("Password",style: TextStyle(fontSize: 20,),),
                    
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
                        ispasswordvisible = ! ispasswordvisible ;
                      });
                    }, )
                   ),
                 ),
                 SizedBox(height: 20,),
                    
                 Center(
                   child: ElevatedButton(
                    onPressed: () async{
                    
                    if(email.text.isEmpty || password.text.isEmpty){
                      Message.show(message: "Please fill all fiels");
                      return;
                    }
                     
                     var enteredEmail = email.text.trim().toLowerCase();
                   
                     if(! enteredEmail.endsWith("@gmail.com")){
                       Message.show(message: "Email must ends with @gmail.com");
                      email.clear();
                      return ;
                     }
                   
                     String result = await AuthenticationHelper.loginwithEmail(enteredEmail, password.text);
                   
                     if(!mounted) return;
                   
                     if(result == "admin"){
                         Navigator.pushReplacementNamed(context, "/adminhome");
                     }
                   
                     else if(result == "user"){
                      Navigator.pushReplacementNamed(context, "/userhome");
                     }
                     else{
                      Message.show(message: result);
                     }
                    }, child: const Text("Login")),
                 ),
                    
                  SizedBox(height: 20,),
                    
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text("Need an account?",style: TextStyle(fontSize: 20, ),),
                    TextButton(onPressed: (){
                       Navigator.pushNamed(context, "/signup");
                    }, child: const Text("Register", style: TextStyle(fontSize: 20, )))
                  ],),
              ],
            ),
          ),
        ),
      ),
    );
  }
}