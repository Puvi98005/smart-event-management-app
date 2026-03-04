import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_event_management_app/admin/admin_qr_scanner.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: const Text("Admin Home", style: TextStyle(fontSize: 25 , color:Colors.blue),), 
      actions: [
        IconButton(onPressed: (){
           Navigator.pushReplacementNamed(context, "/login");
        }, icon: Icon(Icons.logout_outlined))
      ],),
      body: Column(
      children: [
            SizedBox(height: 10,),
            Divider(height: 10, color: Colors.grey,),
            SizedBox(height: 20,),
            Text('''              Welcome Admin 👋
    Manage your events efficiently''', style: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 4, 139, 8)),),
           
           SizedBox(height: 20),

StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection("events").snapshots(),
  builder: (context, eventSnapshot) {

    if (eventSnapshot.connectionState ==ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!eventSnapshot.hasData) {
      return const SizedBox();
    }

    int totalEvents = eventSnapshot.data!.docs.length;

    int upcomingEvents =eventSnapshot.data!.docs.where((doc) {
      Timestamp timestamp = doc['Date']; 
      return timestamp.toDate().isAfter(DateTime.now());
    }).length;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("registrations").snapshots(),
      builder: (context, regSnapshot) {

        int totalRegistrations = regSnapshot.data?.docs.length ?? 0;

        return Padding(
          padding: const EdgeInsets.symmetric( horizontal: 20),
          child: Row(
            children: [
              Expanded( child: _buildStatCard("Total Events",totalEvents.toString()),),
              const SizedBox(width: 10),
              Expanded(child: _buildStatCard("Total Registrations",totalRegistrations.toString()),),
              const SizedBox(width: 10),
              Expanded(child: _buildStatCard("Upcoming Events",upcomingEvents.toString()),),
            ],
          ),
        );
      },
    );
  },
),


            SizedBox(height: 20,),
            Card(
              elevation: 10,
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
              color: const Color.fromARGB(255, 142, 98, 4),
              child: Padding( padding: EdgeInsetsGeometry.all(10),
              
                child: Padding( padding: EdgeInsetsGeometry.all(20),
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [ 
                      Text("Create Event" , style: TextStyle(fontSize: 20, color: Colors.white),),
                      FloatingActionButton(
                        heroTag: "createEventFab",
                        onPressed: (){
                      Navigator.pushNamed(context, "/createEvent");
                      }, child: const Icon(Icons.add,),)
                    ],
                  ),
                ),
              )
              

            ),

            SizedBox(height: 20,),

            
           Card(
              elevation: 10,
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
              color: const Color.fromARGB(255, 142, 98, 4),
              child: Padding( padding: EdgeInsetsGeometry.all(10),
              
                child: Padding( padding: EdgeInsetsGeometry.all(20),
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [ 
                      Text("Manage Event" , style: TextStyle(fontSize: 20, color: Colors.white),),
                      FloatingActionButton(
                        heroTag: "manageEventFab",
                        onPressed: (){
                        Navigator.pushNamed(context, "/manageEvent");
                      }, child: const Icon(Icons.manage_accounts,),)
                    ],
                  ),
                ),
              )
              

            ),

            SizedBox(height: 20,),

            Card(elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
            color: const Color.fromARGB(255, 142, 98, 4),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Scan Qr", style: TextStyle(fontSize: 20,color: Colors.white),),
                  FloatingActionButton(
                    heroTag: "scanFab",
                    onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> QrcodeScanner()));
                  },child: Icon(Icons.qr_code_scanner),)
                ],
              ),
            ),
            )


  ],      ),
    );
  }
  Widget _buildStatCard(String title, String value) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 150, 105, 229),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    ),
  );
}


}
