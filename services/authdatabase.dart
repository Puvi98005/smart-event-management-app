
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";


class AuthenticationHelper{

  //create an account 

  static Future<String> createUserWithEmailAndPassword (String email ,String password, String role) async {
         
     
      try{
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

        await FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.uid).set({
             "email" : email, 
             "role" : role,
            "createdAt" : Timestamp.now(),
        });
        return "Account created Successfully!";
         }
         
    on FirebaseAuthException catch (e) {
    if (e.code == "email-already-in-use") {
      return "This email is already registered. Try another email.";
    }
    return e.message ?? "Authentication error";
    }
     catch(e){
        return e.toString();
     }
   
  }

  //login

  static Future<String > loginwithEmail(String email, String password) async{
   
   try{
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password);
    
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.uid).get();

    String role = documentSnapshot["role"];
    return role;
   }
   on FirebaseAuthException catch(e){
    return e.message.toString();
   }

   catch(e){
    return e.toString();
   }
  }

//logout 

static Future<String> logOut() async{
  try{
    await FirebaseAuth.instance.signOut();
    return "Logout Successfully!";
  }
  on FirebaseAuthException catch(e){
    return e.message.toString();
  }

  catch(e){
    return e.toString();
  }
}

 //checkuser logged in

 static Future<String?> checkuser() async{
    var currentuser = FirebaseAuth.instance.currentUser;
    
    if(currentuser==null){
      return null;
    }

    var doc = await FirebaseFirestore.instance.collection("Users").doc(currentuser.uid).get();

    if(doc.exists){
      return doc["role"];
    }
  return null;
 }
  }

  