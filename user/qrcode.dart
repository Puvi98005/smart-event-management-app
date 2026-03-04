import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrcodePage extends StatelessWidget{
  final String eventId;
  final String eventname;
  final int seats;
  final String userName;

  const QrcodePage({super.key, required this.eventId , required this.eventname , required this.seats, required this.userName});
  
  @override
  Widget build(BuildContext context) {
    String qrcode = "$eventId|$eventname|$seats|$userName";
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: const Text("Qr Code", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold , color: Color.fromARGB(255, 72, 3, 107)),),),
      body:Center(
        child: QrImageView(data: qrcode, size: 250,),
      ) ,
    );
  }

  
}