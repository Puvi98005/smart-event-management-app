import 'package:flutter/material.dart';
//import 'package:smart_event_management_app/admin/eventDetailspage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_event_management_app/admin/updateevent.dart';
import 'package:smart_event_management_app/fluttertoast.dart';
import 'package:smart_event_management_app/services/eventdatabase.dart';

class EventListPage extends StatelessWidget {

  final String category;
 // final List<String> events;

  const EventListPage({super.key , required this.category });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(category),),
      body: StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection("events")
      .where("Category", isEqualTo: category)
      .snapshots(),
  builder: (context, snapshot){

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return const Center(child: Text("Something went wrong"));
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const Center(child: Text("No Events Found"));
    }

    final documents = snapshot.data!.docs;

    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (context, index) {

        DocumentSnapshot doc = documents[index];

        String eventName = doc['Title'];

        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            title: Text(
              eventName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Row( 
            mainAxisSize: MainAxisSize.min, 
            children: [ 
            IconButton( onPressed: (){ 
            Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateEvent(docId: doc.id , eventData : doc ) ),);
            }, icon: Icon(Icons.update)), 
            IconButton( onPressed: (){ 
              showDialog(context: context, builder: (context)=> 
               AlertDialog(
               title: Text("Delete Confirmation"),
               content: const Text("Are you sure want to delete"),
               actions: [
                TextButton(onPressed: (){
                 Navigator.pop(context);
                }, child: const Text("No")),
                TextButton(onPressed: () async{
                  try{
                   await DatabaseHelper.deleteEvent(doc.id);
                   Navigator.pop(context);
                   Message.show(message: "Event deleted succesfully" );
                  } catch(e){
                    Navigator.pop(context);
                    Message.show(message: "Deletion failed $e");

                  }
                 }, child: const Text("Yes"))
               ],
              )

              );
            }, icon: Icon(Icons.delete)), 
            
            ],), 
            
          ), 
          
        );
      },
    );
  },
),
    );
  }
}