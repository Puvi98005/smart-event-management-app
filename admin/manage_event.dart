//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_event_management_app/admin/eventlist.dart';

class ManageEvent extends StatefulWidget {
  const ManageEvent({super.key});
  @override
  State<ManageEvent> createState() => _ManageEventState();
}


class _ManageEventState extends State<ManageEvent> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Manage Event"),),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(height: 5,),
              SizedBox(height: 20,),
              EventCategory("Tech"),
              SizedBox(height: 20,),
              EventCategory("Cultural"),
              SizedBox(height: 20,),
              EventCategory("WorkShop"),
              SizedBox(height: 20,),
              EventCategory("Sports"),
            ],
          ),
        ),
      ),
    );
  
  }


Widget EventCategory (String category) {
   return InkWell( onTap: (){
             Navigator.push(context, MaterialPageRoute(builder: (context) => EventListPage(category: category,)));
            },
              child: Container( 
                width:double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(category, style: TextStyle(fontSize: 20),),
                      Icon(Icons.arrow_forward_ios,size: 20,)
                    ],
                  ),
              ), );
}
}