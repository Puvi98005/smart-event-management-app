import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:smart_event_management_app/admin/eventlist.dart';
import 'package:smart_event_management_app/user/user_eventdetails.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Upcoming Events", style: TextStyle(fontSize: 25,color: Color.fromARGB(255, 6, 151, 45), ),),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/login");
            },
            icon: const Icon(Icons.logout_outlined),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder<QuerySnapshot>(
          stream:FirebaseFirestore.instance.collection('events').snapshots(),
          builder: (context, snapshot) {

            
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            
            if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong"),
              );
            }

            
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No Events Available"),
              );
            }

            var events = snapshot.data!.docs;

            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                var event = events[index];
       
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(

                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> UsereventDetails(eventdetails:event)));
                    },
                    
                    leading: const Icon(Icons.event, color: Colors.green),
                    title: Text(
                      event['Title'] ?? "No Title",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Builder(builder: (context){
                           var timestamp = event['Date'] as Timestamp;
                           DateTime dateTime = timestamp.toDate();
                           String formattedDate = DateFormat.yMMMd().format(dateTime);

                           return Text("Date : $formattedDate");
                         }),
                        Text("Category: ${event['Category'] ?? 'General'}"),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}