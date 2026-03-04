import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_event_management_app/fluttertoast.dart';
import 'package:smart_event_management_app/user/qrcode.dart';

class UsereventDetails extends StatefulWidget {
  final QueryDocumentSnapshot eventdetails;

  const UsereventDetails({super.key, required this.eventdetails});

  @override
  State<UsereventDetails> createState() => _UsereventDetailsState();
}

class _UsereventDetailsState extends State<UsereventDetails> {
  @override
  Widget build(BuildContext context) {

    var event = widget.eventdetails;
    
    var timestamp = event["Date"] as Timestamp;
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat("dd MMM yyyy").format(dateTime);

    int totalseats = event["Total Seats"] ?? 0;

    //int availableseats = event[]

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Event Details", style: TextStyle(fontSize: 25, color: Color.fromARGB(255, 2, 72, 56)),),) ,

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(15),
          child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              Text(event['Title'] ?? 'No Title', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
              ClipRRect(borderRadius: BorderRadius.circular(12),
              child: Image.network(event['ImageUrl'],width: double.infinity,fit: BoxFit.fitWidth,),),
              const SizedBox(height: 10,),
              Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(event['Description'] ?? 'No Description', style: TextStyle(fontSize: 18,),),
              const SizedBox(height: 10,),
              Text("Category : ${event['Category']} " , style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
              Text("Date: $formattedDate", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10,),
              Text("Time : ${event["Time"]}",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10,),
              Text("Total Seats: $totalseats",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10,),
              StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection("registrations").where('eventId', isEqualTo: event.id).snapshots(),
               builder: (context,snapshot){
                 int bookedseats =0;

                 if(snapshot.hasData){
                  for(var doc in snapshot.data!.docs){
                    bookedseats += (doc['seatsBooked'] as int);
                  }
                 }
                 int availableseats = totalseats - bookedseats;
                 return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    availableseats !=0 ?
                    Text("Available Seats: $availableseats", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)):
                    
                    Text(" No Ticket Available: $availableseats", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    
                
                  ],
                 );
               }),

              const SizedBox(height: 30,),
              
              ElevatedButton(onPressed: (){
                showDialog(context: context, builder: (context){
                  TextEditingController seatcontroller = TextEditingController();
                  TextEditingController usernamecontroller = TextEditingController();

                     return AlertDialog(
                     title: const Text("Enter User Name & Number of Seats"),
            
                     content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                        
                         TextField(
                          controller: usernamecontroller,
                          
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                            hintText: "Enter user name"
                          ),
                         ),
                         SizedBox(height: 15,),
                        
                         TextField(
                          controller: seatcontroller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                            hintText: "Enter seats"
                          ),
                         ),
                       ],
                     ),
                     actions: [
                      TextButton(onPressed: (){
                         Navigator.pop(context);
                      }, child: const Text('Cancel')),

                      ElevatedButton(onPressed: () async{
                         int seats = int.parse(seatcontroller.text);
                         
                         await FirebaseFirestore.instance.collection("registrations").
                         add({"eventId": event.id,"eventName":event["Title"],"userName":usernamecontroller.text,"seatsBooked": seats,"registeredAt":Timestamp.now(),});

                         Navigator.pop(context);
                         Navigator.push(context, MaterialPageRoute(builder: (context)=> QrcodePage(eventId: event.id, eventname:event["Title"], seats: seats, userName: usernamecontroller.text)));
                         Message.show(message: "registered successfully");
                      }, child: const Text("Confirm"))
                     ],
                  );
                });

              }, child: const Text("Register",style: TextStyle(fontSize: 18),))

        
            ],
          )),
      ),
    );
  }
}