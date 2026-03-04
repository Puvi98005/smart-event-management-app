import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:smart_event_management_app/fluttertoast.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {

  // FIRESTORE FUNCTION 

  Future<void> addEventToFirestore(String id, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection("events")
        .doc(id)
        .set(data);
  }

  TextEditingController titleText = TextEditingController();
  TextEditingController descriptionText = TextEditingController();
  TextEditingController totalSeats = TextEditingController();

  String? selectedCatagory;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  File? selectedImage;

  bool isLoading = false;

  final String cloudName = "dbazxnlzj";
  final String uploadPreset = "event_upload_preset";

  //  CLOUDINARY UPLOAD 
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
      var responseData = await response.stream.bytesToString();
      var jsonData = json.decode(responseData);
      return jsonData['secure_url'];
    } else {
      return null;
    }
  }

  //  SAFE CREATE EVENT 

  Future<void> handleCreateEvent() async {

    if (selectedImage == null) {
      Message.show(message: "Please select image");
      return;
    }
    
    if (titleText.text.trim().isEmpty ||
        descriptionText.text.trim().isEmpty ||
        selectedCatagory == null ||
        selectedDate == null ||
        selectedTime == null ||
        totalSeats.text.trim().isEmpty) {
      Message.show(message: "Please fill all fields");
      return;
    }

    int? seats = int.tryParse(totalSeats.text.trim());

    if (seats == null || seats <= 0) {
      Message.show(message: "Enter valid seat number");
      return;
    }

    setState(() => isLoading = true);

    try {

      Navigator.pop(context); // close dialog

      Message.show(message: "Uploading Image...");

      String? imageUrl = await uploadToCloudinary(selectedImage!);

      if (imageUrl == null) {
        Message.show(message: "Image upload failed");
        setState(() => isLoading = false);
        return;
      }

      String id = randomAlphaNumeric(10);

      Map<String, dynamic> addEvent = {
        "Id": id,
        "Title": titleText.text.trim(),
        "Description": descriptionText.text.trim(),
        "Category": selectedCatagory,
        "Date": Timestamp.fromDate(selectedDate!),
        "Time": selectedTime!.format(context),
        "Total Seats": seats,
        "Available Seats": seats,
        "ImageUrl": imageUrl,
        "CreatedAt": Timestamp.now(),
      };

      await addEventToFirestore(id, addEvent);

      Message.show(message: "Event Created Successfully!");

      Navigator.pop(context); // go back

    } catch (e) {
      Message.show(message: "Error: $e");
    }

    setState(() => isLoading = false);
  }

  //  UI 
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 251, 231),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Create Event"),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              const Text("Event Title", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              TextField(
                controller: titleText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  prefixIcon: const Icon(Icons.event),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Description", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionText,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  prefixIcon: const Icon(Icons.description),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Category", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedCatagory,
                items: ["Tech", "Cultural", "WorkShop", "Sports"]
                    .map((category) =>
                        DropdownMenuItem(
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

              const Text("Select Date", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 15),
                      Text(selectedDate == null
                          ? "Choose Date"
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Select Time", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now());

                  if (pickedTime != null) {
                    setState(() {
                      selectedTime = pickedTime;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time),
                      const SizedBox(width: 15),
                      Text(selectedTime == null
                          ? "Choose Time"
                          : selectedTime!.format(context)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Total Seats", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              TextField(
                controller: totalSeats,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  prefixIcon: const Icon(Icons.event_seat),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Upload Image", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),

              selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        selectedImage!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Center(
                          child: Text("No Image Selected")),
                    ),

              const SizedBox(height: 10),

              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (pickedFile != null) {
                      setState(() {
                        selectedImage = File(pickedFile.path);
                      });
                    }
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("Choose Image"),
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                     title: const Text("Confirm Creation"),
                                    content: const Text(
                                        "Are you sure want to add event?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("No")),
                                      TextButton(
                                          onPressed: handleCreateEvent,
                                          child: const Text("Yes")),
                                    ],
                                  ));
                        },
                        child: const Text("Submit"),
                      ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}