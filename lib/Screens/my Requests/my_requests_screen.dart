import 'dart:async'; // For Timer
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:rebook_app/Screens/history/model/historymaodel.dart';
import 'package:rebook_app/backend/firebase_functions.dart';
import 'package:rebook_app/notifications/notification_back.dart';

class MyRequestsScreen extends StatefulWidget {
  static const String routeName = 'my_requests_screen';
  const MyRequestsScreen({super.key});

  @override
  _MyRequestsScreenState createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  // A method to periodically check for expired time and refresh the UI
  void startTimer(Duration duration, void Function() onTimeout) {
    Timer(
        duration, onTimeout); // After the time passes, the callback is executed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Requests",
          style: GoogleFonts.domine(
            fontSize: 30,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        child: StreamBuilder<List<HistoryModel>>(
          stream: FirebaseFunctions.getMyRequestStream(),
          builder: (context, snapshot) {
            // Debug info
            print('StreamBuilder - Connection state: ${snapshot.connectionState}');
            print('StreamBuilder - Has data: ${snapshot.hasData}');
            if (snapshot.hasError) {
              print('StreamBuilder - Error: ${snapshot.error}');
              print('Stack trace: ${snapshot.stackTrace}');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 60),
                    SizedBox(height: 16),
                    Text(
                      'Error loading requests',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              );
            }
            
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            
            final requests = snapshot.data ?? [];
            print('Number of requests: ${requests.length}');
            
            if (requests.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      "assets/lotties/Animation - 1738160219532.json",
                      height: 300,
                      width: 300,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'No requests found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            final historyList = snapshot.data!;
            return ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final history = historyList[index];

                // Handling null timestamp with a fallback
                DateTime timestamp = history.timestamp != null
                    ? DateTime.fromMillisecondsSinceEpoch(history.timestamp!)
                    : DateTime.now();

                String formattedTime = DateFormat('yyyy-MM-dd HH:mm a')
                    .format(timestamp.toLocal());

                return Card(
                  color: Colors.blue,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   '${"service-type"}: ${history.orderType ?? 'N/A'}',
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.bold, fontSize: 16),
                        // ),
                        SizedBox(height: 8),
                        Text(
                          "${"timestamp"}: ${formattedTime}",
                          style: TextStyle(fontSize: 16),
                        ),

                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'order-status' + ': ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              history.orderStatus == 'Pending'
                                  ? TextSpan(
                                      text: history.orderStatus,
                                      style: TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    )
                                  : TextSpan(
                                      text: history.orderStatus,
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 20,
                                      ),
                                    )
                            ],
                          ),
                        ),

                        // Display Quick Order data
                        if (history.serviceModel != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${"add-service-name"}: ${history.serviceModel!.name}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "${"add-service-description"}: ${history.serviceModel!.description}",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                Text(
                                  "${"add-service-price"}: ${history.serviceModel!.price}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Image.network(
                                  history.serviceModel!.image,
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),

                        // Display Cart Order data
                        if (history.items != null && history.items!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: history.items!.map((item) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Service Name: ${item.serviceModel.name}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "Service Description: ${item.serviceModel.description}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                    Text(
                                      "Price: ${item.serviceModel.price}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Image.network(
                                      item.serviceModel.image,
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        SizedBox(height: 10),
                        history.orderStatus == 'Pending'
                            ? Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("accept order"),
                                          actions: [
                                            TextButton(
                                              child: Text("yes"),
                                              onPressed: () {
                                                FirebaseFunctions
                                                    .acceptOrderStatus(
                                                        history.id!,
                                                        'Accepted');
                                                NotificationBack
                                                    .sendAcceptNotification(
                                                        history.userId!);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text("no"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }, // Disable the button if not within the cancellation time
                                  child: Text(
                                    "Accept",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Complete order"),
                                              actions: [
                                                TextButton(
                                                  child: Text("yes"),
                                                  onPressed: () {
                                                    FirebaseFunctions
                                                        .deleteHistoryOrder(
                                                            history.timestamp!);
                                                    FirebaseFunctions
                                                        .acceptOrderStatus(
                                                            history.id!,
                                                            'Completed');
                                                    FirebaseFunctions
                                                        .completOrder(
                                                            history.timestamp!,
                                                            history.userId!);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("no"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }, // Disable the button if not within the cancellation time
                                      child: Text(
                                        "Complete",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("cancel order"),
                                              actions: [
                                                TextButton(
                                                  child: Text("yes"),
                                                  onPressed: () {
                                                    FirebaseFunctions
                                                        .acceptOrderStatus(
                                                            history.id!,
                                                            'Pending');
                                                    NotificationBack
                                                        .sendDeclinedNotification(
                                                            history.userId!);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("no"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }, // Disable the button if not within the cancellation time
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
