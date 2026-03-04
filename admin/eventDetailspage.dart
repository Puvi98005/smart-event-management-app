import 'package:flutter/material.dart';

class EventDetailPage extends StatelessWidget {
final String eventName;
  const EventDetailPage({super.key, required this.eventName});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(eventName),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "Details for $eventName",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}