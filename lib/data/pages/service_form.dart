import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_car_service/Api_integration/ProfileGet.dart';
import 'package:flutter_car_service/Api_integration/RequestData.dart';
import 'package:flutter_car_service/Api_integration/ServicedetailsGet.dart';
import 'package:flutter_car_service/data/pages/Termsandcondition.dart';
import 'package:flutter_car_service/data/pages/submissionscreen.dart';
import 'package:flutter_car_service/data/service.dart';
import 'package:flutter_car_service/models/service_models.dart';

import 'package:flutter_car_service/style/color.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceFormPage extends StatefulWidget {
  const ServiceFormPage({super.key});

  @override
  State<ServiceFormPage> createState() => _ServiceFormPageState();
}

class _ServiceFormPageState extends State<ServiceFormPage> {
  List<ServiceModels> serviceDataForm = [];
  List<ServiceModels> selectedService = [];
  DateTime? selectedDate;
  String? selectedTimeSlot;
  String? selectedDeliveryType;
  bool isPickupSelected = false;
  bool isContactSelected = true;
  bool termsAccepted = false;
  bool _isLoading = false;
  final TextEditingController pickupAddressController = TextEditingController();
  final TextEditingController ContactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (ServiceModels item in serviceItemsData) {
      serviceDataForm.add(item);
    }

    // serviceDataForm = serviceItemsData;
    print(serviceItemsData.length);
    selectedDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _handleSubmit() {
    // Check if all required fields are filled
    if (selectedService.isEmpty ||
        selectedTimeSlot == null ||
        selectedDeliveryType == null ||
        selectedDate == null) {
      // Show a SnackBar if any required field is missing
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all required fields."),
          backgroundColor: Colors.red,
        ),
      );
    } else if (!termsAccepted) {
      // Show a SnackBar if terms are not accepted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please accept the terms and conditions."),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Navigate to the SubmissionScreen
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => SubmissionScreen(
      //       selectedService: selectedService,
      //       selectedTimeSlot: selectedTimeSlot,
      //       selectedDeliveryType: selectedDeliveryType,
      //       selectedDate: selectedDate,
      //       isPickupSelected: isPickupSelected,
      //       pickupAddress: isPickupSelected ? pickupAddressController.text : '',
      //     ),
      //   ),
      // );

      // Show a confirmation SnackBar message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Details submitted successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    void clearTextFields() {
      pickupAddressController.clear();
      ContactController.clear();
    }

    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: blackAccent,
          ),
          title: Text(
            "Service Form",
            style: GoogleFonts.poppins(
                color: blackAccent, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          actions: [SizedBox()],
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: subText.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Car Detail",
                          style: GoogleFonts.poppins(
                              color: blackAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Car Name",
                              style: GoogleFonts.poppins(
                                  color: subText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              profiledata['car name'] ?? 'no car name',
                              style: GoogleFonts.poppins(
                                  color: blackAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Car Number",
                              style: GoogleFonts.poppins(
                                  color: subText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              profiledata['reg number'] ?? 'no reg number',
                              style: GoogleFonts.poppins(
                                  color: blackAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Service List",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: subText,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: serviceDataForm.isEmpty
                            ? 1
                            : serviceDataForm.length,
                        itemBuilder: ((context, index) {
                          return serviceDataForm.isEmpty
                              ? Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check_rounded,
                                          color: mainColor,
                                          size: 40,
                                        ),
                                        Text(
                                          "All Services have been Picked",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              color: mainColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedService.add(ServiceModels(
                                          id: serviceDataForm[index].id,
                                          logo: serviceDataForm[index].logo,
                                          title: serviceDataForm[index].title));
                                      serviceDataForm.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: mainColor),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          serviceDataForm[index]
                                              .logo
                                              .toString(),
                                          height: 20,
                                          width: 40,
                                        ),
                                        Text(
                                          serviceDataForm[index].title ?? '',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 11,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                        })),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      "Selected Service ",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: subText,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedService.isEmpty
                            ? 1
                            : selectedService.length,
                        itemBuilder: ((context, index) {
                          return selectedService.isEmpty
                              ? Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.close,
                                          color: mainColor,
                                          size: 40,
                                        ),
                                        Text(
                                          "No Service has been Picked",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              color: mainColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      serviceDataForm.add(ServiceModels(
                                          id: selectedService[index].id,
                                          logo: selectedService[index].logo,
                                          title: selectedService[index].title));
                                      selectedService.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: mainColor),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          selectedService[index]
                                              .logo
                                              .toString(),
                                          height: 20,
                                          width: 40,
                                        ),
                                        Text(
                                          selectedService[index].title ?? '',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 11,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                        })),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: subText.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Date",
                                  style: GoogleFonts.poppins(
                                      color: blackAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                InkWell(
                                  onTap: () => _selectDate(context),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        selectedDate == null
                                            ? 'Select Date'
                                            : '${selectedDate!.toLocal()}'
                                                .split(' ')[0],
                                        style: GoogleFonts.poppins(
                                            color: blackAccent,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        width: 28,
                                      ),
                                      Icon(
                                        Icons.calendar_today,
                                        color: mainColor,
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Time Slot",
                                  style: GoogleFonts.poppins(
                                      color: blackAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                DropdownButton<String>(
                                  value: selectedTimeSlot,
                                  hint: Text(
                                    'Select Time Slot',
                                    style: GoogleFonts.poppins(
                                        color: subText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedTimeSlot = newValue;
                                    });
                                  },
                                  items: <String>[
                                    '09:00 AM',
                                    '10:00 AM',
                                    '11:00 AM',
                                    '12:00 PM',
                                    '01:00 PM',
                                    '02:00 PM',
                                    '03:00 PM',
                                    '04:00 PM'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: GoogleFonts.poppins(
                                            color: blackAccent,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ]),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Contact Number",
                                style: GoogleFonts.poppins(
                                  color: Colors
                                      .black, // Replace with your blackAccent color
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left:
                                          8.0), // Space between Text and TextField
                                  child: TextField(
                                    controller:
                                        ContactController, // Set the controller to the TextField
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintText:
                                          'e.g. +1 234 567 8901', // Placeholder for guidance
                                      hintStyle: GoogleFonts.poppins(
                                        color: Colors
                                            .grey, // Replace with your subText color
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      border:
                                          OutlineInputBorder(), // Add border styling
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal:
                                              10), // Padding inside the TextField
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Delivery Type",
                            style: GoogleFonts.poppins(
                                color: blackAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text('Drop-off',
                                      style: GoogleFonts.poppins(
                                          color: blackAccent,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                  leading: Radio<String>(
                                    value: 'Drop-off',
                                    groupValue: selectedDeliveryType,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedDeliveryType = value;
                                        isPickupSelected = value == 'Pickup';
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text('Pickup',
                                      style: GoogleFonts.poppins(
                                          color: blackAccent,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                  leading: Radio<String>(
                                    value: 'Pickup',
                                    groupValue: selectedDeliveryType,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedDeliveryType = value;
                                        isPickupSelected = value == 'Pickup';
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (isPickupSelected) ...[
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Pickup Address",
                              style: GoogleFonts.poppins(
                                  color: blackAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextField(
                              controller: pickupAddressController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Pickup Address',
                              ),
                            ),
                          ],
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: termsAccepted,
                                onChanged: (bool? value) {
                                  setState(() {
                                    termsAccepted = value ?? false;
                                  });
                                },
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigate to the terms and conditions page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TermsAndConditionsPage()),
                                    );
                                  },
                                  child: Text(
                                    'I accept the terms and conditions',
                                    style: GoogleFonts.poppins(
                                      color:
                                          mainColor, // Change to a hyperlink color
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration
                                          .underline, // Underline to indicate hyperlink
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Material(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        height: 50,
                        child: InkWell(
                          splashColor: subText,
                          borderRadius: BorderRadius.circular(15),
                          onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });

                            List<Map<String, dynamic>> abc =
                                selectedService.map((doc) {
                              return {
                                'id': doc.id,
                                'title': doc.title,
                              };
                            }).toList();

                            String? email =
                                FirebaseAuth.instance.currentUser?.email;

                            Map<String, dynamic> data = {
                              'email': email,
                              "selectedService": abc,
                              "selectedTimeSlot": selectedTimeSlot,
                              "selectedDeliveryType": selectedDeliveryType,
                              "selectedDate": selectedDate.toString(),
                              "isPickupSelected": isPickupSelected,
                              "pickupAddress": isPickupSelected
                                  ? pickupAddressController.text
                                  : '',
                              "phoneNumber": ContactController.text,
                              "status": "Pending",
                              "mechanic": "not assign",
                              "cost": "estimated",
                            };

                            // Call RequestDetails and wait for it to complete
                            await RequestDetails(context, data);
                            FocusScope.of(context).unfocus();
                            // If there's additional data fetching, handle it here
                            await ServiceDataGet();
                            clearTextFields();
                            showSuccessAnimation(context);

                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    "SUBMIT FORM",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  )
                ]))));
  }

  void showSuccessAnimation(BuildContext context) {
    // Create a fullscreen dialog to show the success animation
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Disable back button
          child: Scaffold(
            backgroundColor: Colors.black54, // Overlay color
            body: Center(
              child: Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 100),
                    SizedBox(height: 20),
                    Text(
                      'Success!',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    // Dismiss the dialog after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close the dialog
    });
  }
}
