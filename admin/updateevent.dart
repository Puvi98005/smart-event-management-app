import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
//import 'package:intl/intl.dart';
import 'package:smart_event_management_app/fluttertoast.dart';
import 'package:intl/intl.dart';

class UpdateEvent extends StatefulWidget {
  final String docId;
  final DocumentSnapshot eventData;

  const UpdateEvent({super.key, required this.docId, required this.eventData});

  @override
  State<UpdateEvent> createState() => _UpdateEventState();
}

class _UpdateEventState extends State<UpdateEvent> {
  late TextEditingController tittlecontroller;
  late TextEditingController descriptioncontroller;
  late TextEditingController seatcontroller;

  String? selectedCatagory;
  bool isLoading = false;
  File? selectedImage;
  String? imageurl;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final String cloudName = "dbazxnlzj";
  final String uploadPreset = "event_upload_preset";
  
  

  @override
  void initState() {
    super.initState();

    tittlecontroller =
        TextEditingController(text: widget.eventData["Title"]);

    descriptioncontroller =
        TextEditingController(text: widget.eventData["Description"]);

    seatcontroller = TextEditingController(
        text: widget.eventData["Total Seats"].toString());

    selectedCatagory = widget.eventData["Category"];

    imageurl = widget.eventData["ImageUrl"];

    // Load Date
    if (widget.eventData["Date"] != null) {
      selectedDate =
          (widget.eventData["Date"] as Timestamp).toDate();
    }

 
    if (widget.eventData["Time"] != null) {
      final timeParts =
          widget.eventData["Time"].toString().split(":");
      selectedTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]));
    }
  }

  Future<String?> uploadToCloudinary(File imageFile) async {
    var uri = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    var request = http.MultipartRequest("POST", uri);
    request.fields['upload_preset'] = uploadPreset;

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData =await response.stream.bytesToString();
      var jsonData = json.decode(responseData);
      return jsonData['secure_url'];
    } else {
      return null;
    }
  }

  Future<void> updateEvent() async {
    if (tittlecontroller.text.trim().isEmpty ||
        descriptioncontroller.text.trim().isEmpty ||
        seatcontroller.text.trim().isEmpty ||
        selectedCatagory == null ||
        selectedDate == null ||
        selectedTime == null) {
      Message.show(message: "Please fill all fields");
      return;
    }

    int? seats = int.tryParse(seatcontroller.text.trim());

    if (seats == null || seats <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid seat number")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      String finalImageurl = imageurl ?? "";

      if (selectedImage != null) {
        String? newimageurl = await uploadToCloudinary(selectedImage!);
        if (newimageurl != null) {
          finalImageurl = newimageurl;
        }
      }

      await FirebaseFirestore.instance
          .collection("events")
          .doc(widget.docId)
          .update({
        "Title": tittlecontroller.text.trim(),
        "Description":descriptioncontroller.text.trim(),
        "Category": selectedCatagory,
        "Date": Timestamp.fromDate(selectedDate!),
        "Time": "${selectedTime!.hour}:${selectedTime!.minute}",
        "Total Seats": seats,
        "Available Seats": seats,
        "ImageUrl": finalImageurl,
        "UpdatedAt": Timestamp.now(),
      });

      Message.show(message: "Event Updated Successfully");

      Navigator.pop(context);
    } catch (e) {
      Message.show(message: "Update Failed");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Update Event",
            style: TextStyle(
                fontSize: 25,
                color: Color.fromARGB(255, 3, 41, 99))),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text("Event Title",
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              TextField(
                controller: tittlecontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15)),
                  prefixIcon: const Icon(Icons.title),
                ),
              ),
          
              const SizedBox(height: 20),
          
              const Text("Description",
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              TextField(
                controller: descriptioncontroller,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15)),
                  prefixIcon:
                      const Icon(Icons.description),
                ),
              ),
          
              const SizedBox(height: 20),
          
              const Text("Category",
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
          
              DropdownButtonFormField<String>(
                value: selectedCatagory,
                items: ["Tech", "Cultural", "WorkShop", "Sports"]
                    .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCatagory = value;
                  });
                },
                 decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  prefixIcon: const Icon(Icons.category),
                ),
              ),
          
              const SizedBox(height: 20),
          
              const Text("Total Seats",
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              TextField(
                controller: seatcontroller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15)),
                  prefixIcon:
                      const Icon(Icons.event_seat),
                ),
              ),
          
              const SizedBox(height: 20),
          
              // DATE PICKER
              ListTile(
                title: Text(selectedDate == null
                    ? "Select Date"
                    : DateFormat.yMMMd()
                        .format(selectedDate!)),
                trailing:
                    const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked =
                      await showDatePicker(
                    context: context,
                    initialDate:
                        selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() =>
                        selectedDate = picked);
                  }
                },
              ),
          
              // TIME PICKER
              ListTile(
                title: Text(selectedTime == null
                    ? "Select Time"
                    : selectedTime!
                        .format(context)),
                trailing:
                    const Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay? picked =
                      await showTimePicker(
                    context: context,
                    initialTime:
                        selectedTime ??
                            TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() =>
                        selectedTime = picked);
                  }
                },
              ),
          
              const SizedBox(height: 20),
          
              selectedImage != null
                  ? Image.file(selectedImage!,
                      height: 150)
                  : Image.network(imageurl ?? "",
                      height: 150),
          
              ElevatedButton.icon(
                  onPressed: () async {
                    final picked =
                        await ImagePicker()
                            .pickImage(
                                source:
                                    ImageSource.gallery);
                    if (picked != null) {
                      setState(() {
                        selectedImage =
                            File(picked.path);
                      });
                    }
                  },
                  icon: const Icon(Icons.image),
                  label:
                      const Text("Change Image")),
          
              const SizedBox(height: 20),
          
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: updateEvent,
                      child:
                          const Text("Update Event")),
            ],
          ),
        ),
      ),
    );
  }
}